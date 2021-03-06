## Generated SDC file "evo_m51.out.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 17.1.0 Build 590 10/25/2017 SJ Lite Edition"

## DATE    "Tue Nov 17 08:50:36 2020"

##
## DEVICE  "10M25DAF256C8G"
##


#**************************************************************
# Time Information
#**************************************************************

# This is standard, from auto template
set_time_format -unit ns -decimal_places 3

# FIXME: I am manually setting this here, but should it
#        instead be based on the derived PLL clocks? 
set base_clk_period 16.666

#**************************************************************
# Create Clock
#**************************************************************

# This line was generated by Quartus. Commenting it out and
# generating clocks based on PLL IP settings
#   create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]

# Derive clocks for the design from the PLL settings, which specifies
# a 12MHz input clocks and several output clocks, including our main
# clock, clk_60
derive_pll_clocks -create_base_clocks

# FIXME: Do we need to define the SPI clock? Its just a pass
#        through in this case so I don't think so
# for SPI:
#create_clock -name FPGA_SCK -period $base_clk_period  [get_pins {FPGA_SCK}]


# for IO
create_clock -name clk_virtual -period $base_clk_period



#**************************************************************
# Create Generated Clock
#**************************************************************

# FIXME: Included the following from the XLR8 SDC to resolve
#         an error we were seeing in Quartus

# "clock" created in altera flash IP. The flash sdc file doesn't
#  define it as a clock, but timequest reports an error about
#  it being an undefined clock, so we'll try to do the right thing.
create_generated_clock -name undefined_altera_flash_read_state_clock \
                       -source {evo_core_inst|evo_bsp_inst|evo_flash_inst|evo_flash_flashload_inst|flash_inst|onchip_flash_0|avmm_data_controller|read_state.READ_STATE_SETUP|clk} \
                       -divide_by 2 [get_pins {evo_core_inst|evo_bsp_inst|evo_flash_inst|evo_flash_flashload_inst|flash_inst|onchip_flash_0|avmm_data_controller|read_state.READ_STATE_SETUP|q}]



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
set_clock_uncertainty -to [get_clocks {FPGA_CLK}] 0.5
#set_clock_uncertainty -to [get_clocks {FPGA_SCK}] 0.5
set_clock_uncertainty -to [get_clocks {clk_virtual}] 0.5
set_clock_uncertainty -rise_from [get_clocks {FPGA_CLK}] -rise_to [get_clocks {FPGA_CLK}]  0.500  
set_clock_uncertainty -rise_from [get_clocks {FPGA_CLK}] -fall_to [get_clocks {FPGA_CLK}]  0.500  
set_clock_uncertainty -fall_from [get_clocks {FPGA_CLK}] -rise_to [get_clocks {FPGA_CLK}]  0.500  
set_clock_uncertainty -fall_from [get_clocks {FPGA_CLK}] -fall_to [get_clocks {FPGA_CLK}]  0.500  
derive_clock_uncertainty

#**************************************************************
# Fix timing error due to Quartus bug
#**************************************************************
# FIXME: Included the following from the XLR8 SDC to resolve
#         an error we were seeing in Quartus

# The following constraint should fix the unconstrained
# clock error from the max10flash IP block. See the
# following SR for details -
# https://www.altera.com/support/support-resources/knowledge-base/tools/2016/warning--332060---node---alteraonchipflash-onchipflash-alteraonc.html

create_generated_clock -name flash_se_neg_reg -divide_by 2 \
                       -source [get_pins -compatibility_mode { *altera_onchip_flash:*onchip_flash_0|altera_onchip_flash_avmm_data_controller:avmm_data_controller|flash_se_neg_reg|clk }] \
                               [get_pins -compatibility_mode { *altera_onchip_flash:*onchip_flash_0|altera_onchip_flash_avmm_data_controller:avmm_data_controller|flash_se_neg_reg|q } ]


#**************************************************************
# Set Input Delay
#**************************************************************

# FIXME: The XLR8 sdc set the input delay using the following
#         formula. I have arbitrarily set it to 0.5. What
#         should it really be?
#set dig_inp_dly [expr $base_clk_period/2.0 - 6.5]
set dig_inp_dly 0.5

set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D0}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D1}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D4}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D5}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D6}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D8}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D9}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D10}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D11}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D12}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D13}]

set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D0}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D1}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D4}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D5}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D6}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D8}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D9}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D10}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D11}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D12}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_D13}]

set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E0}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E1}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E2}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E3}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E4}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E5}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E6}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E7}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E8}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E9}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E10}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E11}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E12}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E13}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E14}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E15}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E16}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E17}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E18}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E19}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E20}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E21}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E22}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E23}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E24}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E25}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E26}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E27}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E28}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E29}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E30}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {E31}]

set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {G0}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {G1}]

set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {Z0}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {Z1}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {Z2}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {Z3}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {Z4}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {Z5}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {Z6}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {Z7}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {Z8}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {Z9}]

set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {MISO}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {MOSI}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {SCK}]

set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_MISO}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_MOSI}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_SCK}]

set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_SCL}]
set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {FPGA_SDA}]

#set_input_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_inp_dly [get_ports {D13_LED}]


#**************************************************************
# Set Output Delay
#**************************************************************

# FIXME: Again, I have set this arbitrarily. What should it
#         really be?
set dig_out_dly 0.5

set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D0}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D1}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D4}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D5}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D6}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D8}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D9}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D10}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D11}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D12}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D13}]

set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D0}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D1}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D4}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D5}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D6}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D8}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D9}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D10}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D11}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D12}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_D13}]

set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E0}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E1}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E2}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E3}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E4}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E5}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E6}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E7}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E8}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E9}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E10}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E11}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E12}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E13}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E14}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E15}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E16}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E17}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E18}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E19}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E20}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E21}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E22}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E23}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E24}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E25}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E26}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E27}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E28}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E29}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E30}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {E31}]

set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {G0}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {G1}]

set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {Z0}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {Z1}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {Z2}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {Z3}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {Z4}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {Z5}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {Z6}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {Z7}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {Z8}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {Z9}]

set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {MISO}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {MOSI}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {SCK}]

set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_MISO}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_MOSI}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_SCK}]

set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_SCL}]
set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {FPGA_SDA}]

set_output_delay -add_delay  -clock [get_clocks {clk_virtual}]  $dig_out_dly [get_ports {D13_LED}]



#**************************************************************
# Set Clock Groups
#**************************************************************

# FIXME: this line was autogenerated by TimeQuest, but gives error
# set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 

# FIXME: While trying to fix my triggering problem in SignalTap, I
#         tried the following solution but it just generated an
#         error. And Signaltap now works without this. I don't think
#         you should need to contrain JTAG signals but some users say
#         you have to in some cases to get Quartus and Signaltap to
#         work.
# Got this from https://community.intel.com/t5/Programmable-Devices/JTAG-timing-constraints/td-p/253239
# for enhancing USB BlasterII to be reliable, 25MHz
#create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
#set_input_delay -clock altera_reserved_tck -clock_fall 3 
#set_input_delay -clock altera_reserved_tck -clock_fall 3 
#set_output_delay -clock altera_reserved_tck 3

#**************************************************************
# Set False Path
#**************************************************************
# FIXME: this line was autogenerated by TimeQuest
# set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

