#==============================================================================
# Copyright (c) 2021 Alorium Technology.  All right reserved.
#==============================================================================
#
# File Name  : openevo_update.tcl
# Author     : Steve Phillips
# Contact    : support@aloriumtech.com
# Description:
#
# This TCL script is used to update the files that are needed in each
# XB/extras/quartus/ directoryfrom master copies in the evo_bsp.
#
# USAGE: openevo_update.tcl [-h] [-n] XBNAME
#   Update the named XB with the latest quartus files from 
#   the evo_bsp library
#     -h      Print Usage statement
#     -n      Run without actually updating
#     -q      Quiet mode; turn off Verbose mode
#     XBNAME  Name of XB to update
#
# The command line options can be used if executed from a command line
# outside of Quartus. If executed inside of Quartus then the script
# updates the current XB project.
#
# -------------------------------------------------------------------------- #
set v 1

if {$v} {puts "OPENEVO: +- Enter ../../../evo_bsp/extras/quartus/openevo_update.tcl"}

# Define procudures

#------------------------------------------------------------------------------
proc get_project_versions {project_file} {
    # Description:
    #   This proc reads the scpecified Quartus Project file and returns
    #   a list of all the project revisions in the file
    #
    # Arguments:
    #   project_file: string containing the name and path of a QPF file
    #

    # Open the specified project file
    set qpfId [open $project_file r]

    # Initialize project_versions_list to the empty list 
    set project_versions_list [list]

    # Check each line to see if it starts with PROJECT_REVISION. If it
    # does, add the sprcified revision to the list pof revisions
    while {[gets $qpfId line] >= 0} {
        set linelist [split $line]
        if {[lindex $linelist 0] == "PROJECT_REVISION"} {
            lappend project_versions_list [lindex $linelist 2]
        }
    }
    return $project_versions_list
}

#------------------------------------------------------------------------------
proc lequal {l1 l2} {
    # Description:
    #   Given two list, check them to see if the two lists contain the
    #   exact same list of items, returns true if they have exactly
    #   the same members, regardless of order; returns false if any
    #   difference is found.
    #
    # Arguments:
    #   l1: a list
    #   l2: another list
    
    # Check to see if each element of list l1 is in list l2
    foreach elem $l1 {
        if {$elem ni $l2} {return false}
    }

    # Check to see if each element of list l2 is in list l1
    foreach elem $l2 {
        if {$elem ni $l1} {return false}
    }
    return true
}

#------------------------------------------------------------------------------


if {$v} {puts "OPENEVO:   +- Set PATH variables"}

# Get the path of the directory where thise script file lives. This
# should be in the evo_bsp/extras/tools/ directory
set TPATH [ file dirname [ file normalize [ info script ] ] ]

# Get the path of where we are when we called this script
set QPATH [pwd]

# Determine the PATH to the Arduino libraries/ directory and to the
# evo_bsp directory and the XB directory
set QPATHlist [split $QPATH /]
set QPATHlength [llength $QPATHlist]
set LIBindex [expr $QPATHlength - 4]
unset -nocomplain LIBRARIESPATH
for {set i 0} {$i <= $LIBindex} {incr i} {
    append LIBRARIESPATH [lindex $QPATHlist $i] /
}

# Check to see if we are in the libraries/XBNAME/extras/quartus/ directory
#puts "OPENEVO:   +- LIBRARIES =  [lindex $QPATHlist [expr $QPATHlength - 4] ] "
#set LIBcheck     [string compare "libraries" [lindex $QPATHlist [expr $QPATHlength - 4] ] ]
#puts "OPENEVO:   +- EXTRAS    =  [lindex $QPATHlist [expr $QPATHlength - 2] ] "
#set EXTRAScheck  [string compare "extras"    [lindex $QPATHlist [expr $QPATHlength - 2] ] ]
#puts "OPENEVO:   +- QUARTUS   =  [lindex $QPATHlist [expr $QPATHlength - 1] ] "
#set QUARTUScheck [string compare "quartus"   [lindex $QPATHlist [expr $QPATHlength - 1] ] ]
#if { !$LIBcheck || !$EXTRAcheck || !$QUARTUScheck } {
#    puts "OPENEVO: -- Error - Script must be rune from the Xb's extras/quarts/ directory"
#    exit 1
#}

# Set default name of the XB
set XBNAME [lindex $QPATHlist [expr $QPATHlength - 3] ]

# Parse command line
set helpopt 0
set noop 0
set xb_specified 0
if { $::argc > 0 } {
    set i 1
    foreach arg $::argv {
        if       {[string compare $arg "-n"] == 0}   {
            set noop 1
            if {$v} {puts "OPENEVO:    +- No-op option specified"}
        } elseif {[string compare $arg "-h"] == 0}   {
            set helpopt 1
            if {$v} {puts "OPENEVO:    +- Help option specified"}
        } elseif {[string compare $arg "-q"] == 0}   {
            if {$v} {puts "OPENEVO:    +- Quiet option specified\; turn off Verbose mode"}
            set v 0
        } elseif {!$xb_specified} {
            if {[file isdirectory "$LIBRARIESPATH/$arg"] == 1} {
                set xb_specified 1
                set XBNAME $arg
                if {$v} {puts "OPENEVO:    +- XB to update is $XBNAME"}
            } else {
                puts "OPENEVO: -- Error - XB $arg does not exist"
                exit 1
            }
        } else {
            puts "OPENEVO:    +- Unknown option: $arg, ignored..."
            exit 1
        }
        incr i
    }
}

if { !$xb_specified } {
    if {$v} {puts "OPENEVO:     +- No XB specified. Using name derived from PATH - $XBNAME"}
}

if {$helpopt} {
    puts "==============================================================================
OPENEVO: USAGE: openevo_update.tcl \[\-h\] \[\-n\] XBNAME
OPENEVO:   Update the named XB with the latest quartus files from 
OPENEVO:   the evo_bsp library
OPENEVO:     \-h      Print Usage statement
OPENEVO:     \-n      Run without actually updating
OPENEVO:     \-q      Quiet mode\; turn off Verbose mode
OPENEVO:     XBNAME  Name of XB to update
==============================================================================
"
    exit
}

    
#puts "  +- LIBRARIESPATH = $LIBRARIESPATH"
set BSPPATH "$LIBRARIESPATH\evo_bsp"
if {$v} {puts "OPENEVO:     +- BSPPATH = $BSPPATH"}
set XBPATH  "$LIBRARIESPATH$XBNAME"
if {$v} {puts "OPENEVO:     +- XBPATH = $XBPATH"}

# Read both BSP version of the QPF file and the XB's version of the
# QPF file and see if they have the same list of revisions. If they
# don't, print a warning message at the end of this script to let the
# user know.
set bsp_project_list [get_project_versions $BSPPATH/extras/quartus/evo.qpf]
set oxb_project_list [get_project_versions $XBPATH/extras/quartus/evo.qpf]
set newqpf [lequal $bsp_project_list $oxb_project_list]

if {!$noop} {
    if {$v} {puts "OPENEVO:   +- Update the files in $XBPATH/extras/quartus/" }
    if {$v} {puts "OPENEVO:     +- Copy $BSPPATH/extras/quartus/evo.qpf"}
    file copy -force $BSPPATH/extras/quartus/evo.qpf             $XBPATH/extras/quartus/evo.qpf
    
    if {$v} {puts "OPENEVO:     +- Copy $BSPPATH/extras/quartus/evo_m51_10M25.qsf" }
    file copy -force $BSPPATH/extras/quartus/evo_m51_10M25.qsf   $XBPATH/extras/quartus/evo_m51_10M25.qsf
    
    if {$v} {puts "OPENEVO:     +- Copy $BSPPATH/extras/quartus/evo_m51_10M25.cof" }
    file copy -force $BSPPATH/extras/quartus/evo_m51_10M25.cof   $XBPATH/extras/quartus/evo_m51_10M25.cof
    
    if {$v} {puts "OPENEVO:     +- Copy $BSPPATH/extras/quartus/evo_m51_10M50.qsf"}
    file copy -force $BSPPATH/extras/quartus/evo_m51_10M50.qsf   $XBPATH/extras/quartus/evo_m51_10M50.qsf
    
    if {$v} {puts "OPENEVO:     +- Copy $BSPPATH/extras/quartus/evo_m51_10M50.cof" }
    file copy -force $BSPPATH/extras/quartus/evo_m51_10M50.cof   $XBPATH/extras/quartus/evo_m51_10M50.cof

    if {$v} {puts "OPENEVO:     +- Copy $BSPPATH/extras/quartus/evo_post_flow.tcl" }
    file copy -force $BSPPATH/extras/quartus/evo_post_flow.tcl $XBPATH/extras/quartus/evo_post_flow.tcl
    
    if {$v} {puts "OPENEVO:     +- Check for depricated file $XBNAME/extras/quartus/evo_m51.qsf" }
    if { [file exists $XBPATH/extras/quartus/evo_m51.qsf] == 1 } {
        if {$v} {puts "OPENEVO:       +- Delete $XBPATH/extras/quartus/evo_m51.qsf"}
        file delete -force $XBPATH/extras/quartus/evo_m51.qsf
    }

    if {$v} {puts "OPENEVO:     +- Check for depricated file $XBNAME/extras/quartus/evo.cof" }
    if { [file exists $XBPATH/extras/quartus/evo.cof] == 1 } {
        if {$v} {puts "OPENEVO:       +- Delete $XBPATH/extras/quartus/evo.cof"}
        file delete -force $XBPATH/extras/quartus/evo.cof
    }

    if {$v} {puts "OPENEVO:     +- Check for depricated file $XBNAME/extras/quartus/evo_info.tcl" }
    if { [file exists $XBPATH/extras/quartus/evo_info.tcl] == 1 } {
        if {$v} {puts "OPENEVO:       +- Delete $XBPATH/extras/quartus/evo_info.tcl"}
        file delete -force $XBPATH/extras/quartus/evo_info.tcl
    }

    if {$v} {puts "OPENEVO:     +- Check for depricated file $XBNAME/extras/quartus/evo_convert_img.tcl" }
    if { [file exists $XBPATH/extras/quartus/evo_convert_img.tcl] == 1 } {
        if {$v} {puts "OPENEVO:       +- Delete $XBPATH/extras/quartus/evo_convert_img.tcl"}
        file delete -force $XBPATH/extras/quartus/evo_convert_img.tcl
    }

    if {$v} {puts "OPENEVO:     +- Check for depricated file $XBNAME/extras/quartus/evo_flashload.tcl" }
    if { [file exists $XBPATH/extras/quartus/evo_flashload.tcl] == 1 } {
        if {$v} {puts "OPENEVO:       +- Delete $XBPATH/extras/quartus/evo_flashload.tcl"}
        file delete -force $XBPATH/extras/quartus/evo_flashload.tcl
    }
    if {$v} {puts "OPENEVO:   +- Update the files in $XBPATH/extras/design/" }
    if {$v} {puts "OPENEVO:     +- Copy $BSPPATH/extras/quartus/evoxb_template.sv"}
    file copy -force $BSPPATH/extras/design/evo_xb_template.sv             $XBPATH/extras/design/evo_xb_template.sv
    if {$v} {puts "OPENEVO:   +- Update the files in $XBPATH/extras/" }
    if {$v} {puts "OPENEVO:     +- Copy $BSPPATH/extras/README.md"}
    file copy -force $BSPPATH/extras/README.md                             $XBPATH/extras/README.md

} else {
    puts "OPENEVO:   +- Copy the following file to $XBPATH/extras/quartus/" 
    puts "OPENEVO:     +- Would have done the following, but \"-n\" was specified:"
    puts "OPENEVO:     +- [Did Not] Copy $BSPPATH/extras/quartus/evo.qpf             " 
    puts "OPENEVO:     +- [Did Not] Copy $BSPPATH/extras/quartus/evo_m51_10M25.qsf   " 
    puts "OPENEVO:     +- [Did Not] Copy $BSPPATH/extras/quartus/evo_m51_10M25.cof   " 
    puts "OPENEVO:     +- [Did Not] Copy $BSPPATH/extras/quartus/evo_m51_10M50.qsf   " 
    puts "OPENEVO:     +- [Did Not] Copy $BSPPATH/extras/quartus/evo_m51_10M50.cof   " 
    puts "OPENEVO:     +- [Did Not] Copy $BSPPATH/extras/quartus/evo_post_flow.tcl " 
    if { [file exists $XBPATH/extras/quartus/evo_m51.qsf] == 1 } {
        puts "OPENEVO:     +- [Did Not] Delete $XBPATH/extras/quartus/evo_m51.qsf"
    }
    if { [file exists $XBPATH/extras/quartus/evo.cof] == 1 } {
        puts "OPENEVO:     +- [Did Not] Delete $XBPATH/extras/quartus/evo.cof"
    }
    if { [file exists $XBPATH/extras/quartus/evo_info.tcl] == 1 } {
        puts "OPENEVO:     +- [Did Not] Delete $XBPATH/extras/quartus/evo_info.tcl"
    }
    if { [file exists $XBPATH/extras/quartus/evo_convert_img.tcl] == 1 } {
        puts "OPENEVO:     +- [Did Not] Delete $XBPATH/extras/quartus/evo_convert_img.tcl"
    }
    if { [file exists $XBPATH/extras/quartus/evo_flashload.tcl] == 1 } {
        puts "OPENEVO:     +- [Did Not] Delete $XBPATH/extras/quartus/evo_flashload.tcl"
    }
    puts "OPENEVO:   +- Copy the following file to $XBPATH/extras/design/" 
    puts "OPENEVO:     +- [Did Not] Copy $BSPPATH/extras/design/evo_xb_template.xb " 
    puts "OPENEVO:   +- Copy the following file to $XBPATH/extras/" 
    puts "OPENEVO:     +- [Did Not] Copy $BSPPATH/extras/README.md " 
}
if {$v} {puts "OPENEVO:   -- End of file copying"}

puts "OPENEVO:   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
if {$newqpf != true} {
    puts "OPENEVO:   !!!  = WARNING! = WARNING! = WARNING! = WARNING! = WARNING! = WARNING! = WARNING! =  !!!"
    puts "OPENEVO:   !!!    - The new project file is different from the previous project file!           !!!"
    puts "OPENEVO:   !!!    - Before compiling the design, reload the project                             !!!"
    puts "OPENEVO:   !!!  = WARNING! = WARNING! = WARNING! = WARNING! = WARNING! = WARNING! = WARNING! =  !!!"
    puts "OPENEVO:   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
}
puts "OPENEVO:   !!!    - Always check the $XBPATH/extras/README.md file for update info              !!!"
puts "OPENEVO:   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

if {$v} {puts "OPENEVO: -- End of openevo_upate.tcl"}
