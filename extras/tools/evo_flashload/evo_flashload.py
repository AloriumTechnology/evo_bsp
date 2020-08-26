# Connect to an Evo board and load a .evo file to it
# Author: Bryan Craker
# Alorium Technology
# MIT License

import rpd_2_evo

from time import sleep

import serial
from serial.tools import list_ports

import os
import sys
import binascii
import subprocess
import time

import argparse

# Reset the Evo
def reset_device(device_name) -> None:
  ser = serial.Serial(port=device_name, baudrate=1200)
  ser.setDTR(False)
  ser.close()
  sleep(3)

# When the board resets, it will disappear and reappear from the device list
def wait_on_device(device_name) -> 'New Name':
  start = time.time()
  devices = [device_name]
  rescan = False
  while device_name in devices:
    sleep(.1)
    # Give a warning if we've waited for 3 seconds
    if (time.time() - start) > 3:
      print("Warning: Evo did not release serial")
      sys.stdout.flush()
      device_name = ""
      break
      #sys.exit(0)
    # Get a list of all serial ports
    devices = []
    for idx, prt in enumerate(list_ports.comports()):
      try:
        devices.append(prt.device)
      except AttributeError as e:
        # Linux ports not returned the same way.  Just print the port
        devices.append(prt[0])
  start = time.time()
  # This will skip if we timed out above
  while device_name not in devices:
    sleep(.1)
    # Give a warning if we've waited for 3 seconds
    if (time.time() - start) > 3:
      print("Warning: Evo did not restart serial")
      device_name = ""
      break
    # Get a list of all serial ports
    for idx, prt in enumerate(list_ports.comports()):
      if prt.device not in devices:
        try:
          device_name = prt.device
          devices.append(prt.device)
        except AttributeError as e:
          # Linux ports not returned the same way.  Just print the port
          device_name = prt[0]
          devices.append(prt[0])
  return device_name
      

def init_argparse() -> argparse.ArgumentParser:
  parser = argparse.ArgumentParser(
    usage="%(prog)s --inputfile [INPUT FILE] (--device [UART DEVICE] --bossac [BOSSAC PATH] --sketch [SKETCH PATH] --verbose)",
    description="Send an evo_img file to a connected Evo device."
  )
  parser.add_argument('-i', '--inputfile', required=False)
  parser.add_argument('-d', '--device', required=False)
  parser.add_argument('-b', '--bossac', required=False)
  parser.add_argument('-s', '--sketch', required=False)
  parser.add_argument('-c', '--convert', action="store_true")
  parser.add_argument('-o', '--outputfile', required=False)
  parser.add_argument('-v', '--verbose', action="store_true")
  parser.add_argument('--onlyinfo', action="store_true")
  parser.add_argument('--noinfo', action="store_true")
  return parser

def load_info(device, info_bin, bossac, verbose) -> None:

  # Check if the precompiled info sketch is available
  if not os.path.isfile(info_bin):
    print(info_bin + " not present, exiting")
    sys.exit(0)

  # Load the info sketch with bossac
  for idx in range(3):
    if verbose:
      print("Resetting " + str(idx + 1) + "...")
      sys.stdout.flush()
    reset_device(device)
    # Get a list of all serial ports
    devices = []
    for idx, prt in enumerate(list_ports.comports()):
      try:
        devices.append(prt.device)
      except AttributeError as e:
        # Linux ports not returned the same way.  Just print the port
        devices.append(prt[0])
    if device not in devices:
      device = ""
      for dev in devices:
        if dev not in all_devices:
          # assume this is the new device
          if verbose:
            print("New device: " + dev)
            sys.stdout.flush()
          device = dev
      if device == "" and idx == 2:
        print("Error: device lost")
        sys.exit(0)

  command = bossac + " -i -d --port=" + device + " -U -i --offset=0x4000 -w -v " + info_bin + " -R"
  if verbose:
    print("Programming Evo SAMD...")
    print(command)
    sys.stdout.flush()
  output = subprocess.check_output(command, shell=True)
  device = wait_on_device(device)

  # Print a blank space between output blocks
  print()
  sys.stdout.flush()

  # configure the serial connections (the parameters differs on the device you are connecting to)
  ser = serial.Serial(
    port=device,
    baudrate=115200
  )

  cnt = 0
  while True:
    data = ser.readline().decode('ascii').strip()
    print(data)
    sys.stdout.flush()
    cnt += 1
    if cnt > 14:
      break

def main() -> None:

  parser = init_argparse()
  args = parser.parse_args()

  scriptpath = os.path.dirname(os.path.realpath(sys.argv[0])) # __file__ does not work properly with pyinstaller
  filepath = ''
  device = ''
  bossac = ''
  sketchpath = scriptpath + '/'
  verbose = False
  flashload_bin = 'evo_flashload.ino.bin'
  info_bin = 'get_evo_info.ino.bin'
  all_devices = []
  evo_devices = []

  # If the "convert" flag is set, short circuit evo_flashload and switch to rpd_2_evo
  if args.convert:
    rpd_2_evo.main()
    sys.exit(0)

  # Determine the connected Evo device
  if args.device is None:
    all_devices = []
    # Get a list of all serial ports
    for idx, prt in enumerate(list_ports.comports()):
      try:
        all_devices.append(prt.device)
        if prt.vid == 0x32BD:
          evo_devices.append(prt.device)
      except AttributeError as e:
        # Linux ports not returned the same way.  Just print the port
        all_devices.append(prt[0])
    if len(evo_devices) > 1:
      for idx, dev in enumerate(evo_devices):
        print("[" + str(idx) + "]: " + dev)
      choice = int(input("Choose a serial device:"))
      if choice >= len(evo_devices):
        print("Error: Choice [" + choice + "] out of range")
        sys.exit(0)
      print(evo_devices[choice])
      device = evo_devices[choice]
    elif len(evo_devices) == 0:
      print("Error: No Evo device found")
      sys.exit(0)
    else:
      device = evo_devices[0]
  else:
    device = args.device

  # Get Bossac, either from the path or from the current directory
  if args.bossac is None:
    if os.path.isfile(scriptpath + '/bossac'):
      bossac = scriptpath + '/bossac'
    elif os.path.isfile(scriptpath + "\\bossac.exe"):
      bossac = scriptpath + "\\bossac.exe"
    else:
      print("Error: could not find bossac")
      sys.exit(0)
  else:
    bossac = args.bossac

  # If a path is given to the precompiled sketches get it, otherwise assume the current directory
  if args.sketch is not None:
    sketchpath = args.sketch

  flashload_bin = sketchpath + flashload_bin
  info_bin = sketchpath + info_bin

  # If the "only info" flag is set, short circuit evo_flashload and only load the evo_get_info sketch
  if args.onlyinfo:
    load_info(device, info_bin, bossac, verbose)
    sys.exit(0)

  # Determine the new image to load
  filepath = args.inputfile
  if filepath is None:
    print("Error: Provide an inputfile with -i")
    sys.exit(0)

  # Ensure the precompiled evo_flashload.ino file is available
  if not os.path.isfile(flashload_bin):
    print("Error: could not find " + flashload_bin)
    sys.exit(0)

  # Note: get_evo_info is loaded at the end, but this program can continue if that file does not exist

  with open(filepath, 'rb') as f:
    filebytes = bytearray(f.read())

  if len(filebytes) % 132 != 0:
    print("Error: APAGE count invalid, file size should be a multiple of 132")
    sys.exit(0)

  apage_cnt = 0
  apages = []
  crcs = []
  while apage_cnt * 132 < len(filebytes):
    apage = filebytes[(apage_cnt * 132):(apage_cnt * 132) + 128]
    apages.append(apage)
    crc = filebytes[(apage_cnt * 132) + 128:(apage_cnt * 132) + 132]
    crcs.append(crc)
    apage_cnt += 1

  pointer = 0
  while pointer < apage_cnt:
    calc_crc = binascii.crc32(bytes(apages[pointer]))
    exp_crc = int.from_bytes(crcs[pointer],byteorder='big', signed=False)
    if calc_crc != exp_crc:
      print("Error: CRC check failed")
      sys.exit(0)
    pointer += 1

  print("Beginning Evo Flashload, this may take a few mintues...")

  # Load the flashload sketch with bossac
  if verbose:
    print("Resetting the Evo device")
    sys.stdout.flush()
  for idx in range(3):
    if verbose:
      print("Resetting " + str(idx + 1) + "...")
      sys.stdout.flush()
    reset_device(device)
    sleep(2)
    # Get a list of all serial ports
    devices = []
    for idx, prt in enumerate(list_ports.comports()):
      try:
        devices.append(prt.device)
      except AttributeError as e:
        # Linux ports not returned the same way.  Just print the port
        devices.append(prt[0])
    if device not in devices:
      #device = ""
      for dev in devices:
        if dev not in all_devices:
          # assume this is the new device
          if verbose:
            print("New device: " + dev)
            sys.stdout.flush()
          device = dev
      if device == "" and idx == 2:
        print("Error: device lost")
        sys.exit(0)

  command = bossac + " -i -d --port=" + device + " -U -i --offset=0x4000 -w -v " + flashload_bin + " -R"
  print("Programming Evo SAMD...")
  sys.stdout.flush()
  if verbose:
    print(command)
    sys.stdout.flush()
  output = subprocess.check_output(command, shell=True)
  device = wait_on_device(device)

  # configure the serial connections (the parameters differs on the device you are connecting to)
  ser = serial.Serial(
    port=device,
    baudrate=115200
  )

  try: 
    ser.isOpen()
  except Exception as e:
    print("Error opening serial port: " + str(e))
    sys.exit(0)

  while True:
    data = ser.readline().decode('ascii').strip()
    if data == "I":
      if verbose:
        print("Sending size in APAGES (" + str(len(apages)) + ")");
        sys.stdout.flush()
      b = (len(apages)).to_bytes(2, 'big')
      ser.write(b)
      break
    sleep(.1)

  pointer = 0
  while True:
    data = ser.readline().decode('ascii').strip()
    if data == "A":
      while pointer < len(apages):
        for i in apages[pointer]:
          b = bytes([i])
          ser.write(b)
        for c in crcs[pointer]:
          b = bytes([c])
          ser.write(b)
        if (pointer % 100 == 0):
          #just = "{0:>4s}".format(str(pointer))
          print("\rFinished APAGE " + str(pointer) + " of " + str(len(apages)), end='')
          sys.stdout.flush()
          sleep(.1)
        data = ser.readline().decode('ascii').strip()
        if int(data) % 2 != 0:
          print("Error: loading APAGE failed. Status = " + str(data))
          sys.exit(0)
        pointer += 1
      break
    sleep(.1)
  print("\rFinished APAGE " + str(len(apages)) + " of " + str(len(apages)), end='')
  print()
  sys.stdout.flush()

  while True:
    data = ser.readline().decode('ascii').strip()
    if data == "Finished":
      break
    sleep(.1)

  print("FPGA image load complete")
  sys.stdout.flush()

  # If user selected to skip info load, exit
  if args.noinfo:
    sys.exit(0)

  # Check if the precompiled info sketch is available
  if not os.path.isfile(info_bin):
    print(info_bin + " not present, exiting")
    sys.exit(0)

  # Load the info sketch with bossac
  if verbose:
    print("Resetting the Evo device")
    sys.stdout.flush()
  ser.close()
  for idx in range(3):
    if verbose:
      print("Resetting " + str(idx + 1) + "...")
      sys.stdout.flush()
    reset_device(device)
    # Get a list of all serial ports
    devices = []
    for idx, prt in enumerate(list_ports.comports()):
      try:
        devices.append(prt.device)
      except AttributeError as e:
        # Linux ports not returned the same way.  Just print the port
        devices.append(prt[0])
    if device not in devices:
      device = ""
      for dev in devices:
        if dev not in all_devices:
          # assume this is the new device
          if verbose:
            print("New device: " + dev)
            sys.stdout.flush()
          device = dev
      if device == "" and idx == 2:
        print("Error: device lost")
        sys.exit(0)

  command = bossac + " -i -d --port=" + device + " -U -i --offset=0x4000 -w -v " + info_bin + " -R"
  if verbose:
    print("Programming Evo SAMD...")
    print(command)
    sys.stdout.flush()
  output = subprocess.check_output(command, shell=True)
  device = wait_on_device(device)

  # Print a blank space between output blocks
  print()
  sys.stdout.flush()

  # configure the serial connections (the parameters differs on the device you are connecting to)
  ser = serial.Serial(
    port=device,
    baudrate=115200
  )

  cnt = 0
  while True:
    data = ser.readline().decode('ascii').strip()
    print(data)
    sys.stdout.flush()
    cnt += 1
    if cnt > 14:
      break

if __name__ == "__main__":
  main()
