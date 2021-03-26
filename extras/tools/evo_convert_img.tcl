#==============================================================================
# Copyright (c) 2020 Alorium Technology.  All right reserved.
#==============================================================================
#
# File Name  : evo_convert_img.tcl
# Author     : Steve Phillips
# Contact    : support@aloriumtech.com
# Description:
#
#  This script will be run after the Qusrtus compile completes. Currently
#  it performs the following actions:
#    1.) Converts SOF to POF and RPD formats
#    2.) Converts the RPD into EVO_IMG fdormat
#
#  The script assumes that it is called from a quartus directory in one of
#  the XBs, so the relative paths all reference up three levels to the
#  library dir and then back down into the approriate XB
#
#==============================================================================

post_message -type info "OPENEVO: +- Enter evo_convert_img.tcl script"

# Determine Windows or Linux
set OS [lindex $tcl_platform(os) 0]
post_message -type info "OPENEVO:   +- Platform type is $OS"

# The quartus(settings) varable should be set to the selected version,
# for example: evo_m51_10M25 or evo_m51_10M50
#set qrev "$::quartus(settings)"  # No longer working. No value returned
# Since the above doesn't work, we will inspect the command arguments
# to get the Revision instead. The Quartus(args) are: compile evo evo_m51_10M25.
# We want that last one
set qrev [lindex $quartus(args) 2]
post_message -type info "OPENEVO:   +- Convert Programming Files: Revision is \"$qrev\""

# For some reason the rpd files produced by the quartus_cpf command
# convert upper case to lower case, so we need a lowercase version of
# the Revision on Linux, where case matters.
set qrevlo [string tolower $qrev]

# Set the name of the COF file
set cofn $qrev.cof


post_message -type info "OPENEVO:   +- Input SOF File:"
post_message -type info "OPENEVO:      +- ./$qrev\.sof"
post_message -type info "OPENEVO:   +- Convert Programming File:"
post_message -type info "OPENEVO:      +- ./$cofn"

post_message -type info "OPENEVO:   +- Run \"quartus_cpf --convert $cofn\""
exec quartus_cpf --convert $cofn

post_message -type info "OPENEVO:   +- Converted Programming Files: POF and RPD files created"
post_message -type info "OPENEVO:      +- ./reports/$qrev\.pof" 
post_message -type info "OPENEVO:      +- ./reports/$qrev\_cfm1_auto.rpd" 

set BUILD_PATH [pwd] 
if { $OS == "Windows" } {
    # We have to be in the evo_flashload dir to run it
    cd ../../../evo_bsp/extras/tools/evo_flashload/windows
    if { [file exists "evo_flashload"] } {
        file rename "evo_flashload" "evo_flashload.exe"
    }
    if { [file exists "bossac"] } {
        file rename "bossac" "bossac.exe"
    }
    post_message -type info "OPENEVO:   +- Run \"evo_flashload.exe --convert -i $qrev\_cfm1_auto.rpd -o $qrev\.evo_img\""
    exec ./evo_flashload.exe --convert \
        -i $BUILD_PATH/reports/$qrev\_cfm1_auto.rpd \
        -o $BUILD_PATH/reports/$qrev\.evo_img
} else { # Linux
    cd ../../../evo_bsp/extras/tools/evo_flashload
    post_message -type info "OPENEVO:   +- Run \"evo_flashload.py --convert -i $qrevlo\_cfm1_auto.rpd -o $qrev\.evo_img\""
    exec python3 ./evo_flashload.py --convert \
        -i $BUILD_PATH/reports/$qrevlo\_cfm1_auto.rpd \
        -o $BUILD_PATH/reports/$qrev\.evo_img
}
# Return to the evo_build quartus dir
cd  $BUILD_PATH

post_message -type info "OPENEVO:   +- Evo Convert Image: EVO_IMG file created"
post_message -type info "OPENEVO:      +- ./reports/$qrev\.evo_img" 
post_message -type info "OPENEVO: -- End of evo_convert_img.tcl script"
