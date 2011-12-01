# Project Creation Date: 2011-09-19                                           #
#                                                                             #
# Todo.txt implemenation in TCL/Tk                                            #
#                                                                             #
# ----------------------------------------------------------------------------#
# TODO - Need to update the filter_data proc to parse into a list and pass
# 			back a list as the result.
# TODO - Need to modify show_result proc to handle a list as input instead of
#			what it does currently.
# TODO - Need to code the show_usage proc.
#
#
proc read_datafile {filename} {
	##
	## Read in a data file
	##
	set fp [open $filename r]
	set file_data [read $fp]
	close $fp
	return $file_data
}

proc show_usage {} {
	##
	## Show usage and exit
	##
	puts "USAGE: " ;# TODO - Need to code the show_usage proc.
	exit -1;
}

proc show_result {data} {
	##
	## Show the resulting filtered/sorted list
	##
	set loopcount 1
	foreach line $data {
		if ![string equal $line ""] {
			puts [concat $loopcount " " $line]
			incr loopcount
		}
	}
}

proc show_header {} {
	##
	## Show the header
	##
	show_divider " "
	show_divider
	puts " Tickle List ... The TCL Todo.txt Implementation "
	show_divider
}

proc show_divider { {div_char -} } {
	##
	## Show a divider to the screen
	##    Input:	character to use for divider bar
	##				if none, default is a dash
	##				" " will simulate a blank line
	##
	set div_bar ""
	for {set i 1} {$i < 49} {incr i} {
		set div_bar [concat [string trim $div_bar][string trim $div_char]]
	}
	puts $div_bar
}

proc get_arguments {argc argv} {
	global action
	global terms
	global debug
	# Read in command-line parameters
	if {$argc < 1} {
		# Since there are no arguments passed in we just show the USAGE and exit.
		show_usage
	}
	if {$argc >= 1} {
		set action [lindex $argv 0]
		if {$debug == 1} {
			puts " ACTION: $action"
		}
	}
	if {$argc > 1} {
		set terms ""
		for {set i 1} {$i < $argc} {incr i} {
			set terms [concat $terms " " [lindex $argv $i]]
		}
		if {$debug == 1} {
			puts " TERMS: $terms"
		}
	}
}

proc filter_list {data terms} {
	set result ""
	set loopcount 1
	set res_line ""
	foreach line $data {
		if ![string equal $line ""] {
			if {[string first $terms $line] >= 0} {
				if {$loopcount == 1} {
					set res_line [concat "{" [string trim $line] "}" ]
					set result [string trim [string trim $res_line]]
				} else {
					set res_line [concat [$result] " {" [string trim $line] "}" ]
					set result [string trim [concat [$result] [string trim $res_line]]]
				}
			}
		}
	}
	show_divider
	puts $result
	show_divider
	
	foreach x $result {
		puts [string trim $x]
	}
	
	return $result
}


set action ""
set terms ""
set debug 1  ;# debug 0 = hide debug messages, debug 1 = show debug messages

if {$debug == 1} {
	show_header
}
get_arguments $argc $argv
if {$debug == 1} {
	show_divider
}

# Determine path and filename
set fn todo.txt ;# TODO - Allow for diff filename from command line argument
set dir [file dirname [info script]]
set path_n_file [file join $dir $fn]

# Get the data from the file
set file_data [read_datafile $path_n_file]

#  Process data file
set data [split $file_data "\n"]

switch -exact -- $action {
	ls		-
	list	{
		#  list [TERM...]
		#  ls [TERM...]
		#
		#  Displays all tasks that contain TERM(s) sorted by priority with line
		#  numbers. If no TERM specified, lists entire todo.txt
		#
		#  TODO - filter $data by TERM
		#  TODO - sort $data by priority (after filter)
		if {$debug == 1} {
			# show the unfiltered list first for debugging purposes
			show_divider " "
			show_result $data
			show_divider " "
		}
		if {[string length $terms] > 0} {
			set data [filter_list $data $terms]
		}
		show_divider "="
		show_result $data
	}
	
}
