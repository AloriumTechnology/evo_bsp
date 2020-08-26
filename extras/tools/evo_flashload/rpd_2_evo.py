# Select an RPD file and convert it to an EVO file with a CRC appended to each APAGE

import sys
import argparse
import os
import binascii

def init_argparse() -> argparse.ArgumentParser:
  parser = argparse.ArgumentParser(
    usage="%(prog)s --inputfile [INPUT FILE] (--outputfile [OUTPUT FILE])",
    description="Convert an RPD file to an EVO file."
  )
  parser.add_argument('-i', '--inputfile', required=True)
  parser.add_argument('-o', '--outputfile', required=False)
  parser.add_argument('-c', '--convert', action="store_true")
  return parser

def main() -> None:

  parser = init_argparse()
  args = parser.parse_args()

  inputfile = ''
  outputfile = ''

  inputfile = args.inputfile
  if args.outputfile is None:
    outputfile = os.path.splitext(inputfile)[0] + '.evo_img'
  else:
    outputfile = args.outputfile

  with open(inputfile, 'rb') as f:
    filebytes = bytearray(f.read())
  print("File contains " + str(len(filebytes)) + " bytes")
  sys.stdout.flush()

  if len(filebytes) % 128 != 0:
    print("Error: APAGE count invalid, file size should be a multiple of 128")
    sys.exit(0)

  # Split the RPD file into APAGES and calculate the corresponding CRC of each APAGE
  apage_cnt = 0
  apages = []
  crcs = []
  while apage_cnt * 128 < len(filebytes):
    apage = filebytes[(apage_cnt * 128):(apage_cnt * 128) + 128]
    apages.append(apage)
    crcs.append(binascii.crc32(bytes(apage)))
    apage_cnt += 1

  # Write the output file in the format of each APAGE followed by its corresponding CRC
  pointer = 0
  evo_file = open(outputfile, 'wb')
  while pointer < len(apages):
    for i in apages[pointer]:
      b = bytes([i])
      evo_file.write(b)
    for c in crcs[pointer].to_bytes(4, 'big'):
      b = bytes([c])
      evo_file.write(b)
    pointer += 1
  evo_file.close()

  print(outputfile + " created")

if __name__ == "__main__":
  main()
