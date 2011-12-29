# Project Creation Date: 2011-12-27                                           #
#                                                                             #
# Addon to TickleList (TCL todo.txt implementation                            #
#                                                                             #
# ----------------------------------------------------------------------------#

# =============================================================================
# ======================== PROC LIST ==========================================
# =============================================================================
proc read_datafile {filename} {
	#
	#   Read in a data file
	#
	set file_data ""
	if {[file exists $filename]} {
		set fp [open $filename r]
		set file_data [read $fp]
		close $fp
	}
	return $file_data
}

proc show_usage { {action "help"} {show_oneline true} {exit_after true}} {
	#
	#   Show usage and exit
	#
	
	set oneline {<<COMMAND SHORTCUT>> action [task_number]}
	if {$show_oneline} {
		puts ""
		puts "USAGE: $oneline"
		puts ""
	}
	switch -exact -- $action {
	
		cur		-
		current {
			puts {   cur}
			puts {   current}
			puts {      Displays the active clocked in task.}
		}
		
		in {
			puts {   in ITEM#}
			puts {      Appends timestamp to task as in:timestamp}
			puts {      Will clock out any other tasks that are currently clocked in}
		}
		
		help	{
			puts {   help}
			puts {      Display this help message.}
		}

		laps	{
			puts {   laps}
			puts {      Displays report of all tasks with lap:times}
		}
		
		out {
			puts {   out}
			puts {      Clocks out all tasks that are clocked in}
			puts {      Removes in:timestamp, calculates lap:time, appends lap:time to task}
		}
		
		shorthelp {
			puts {   shorthelp}
			puts {      List the one-line usage of all built-in and add-on actions.}
		}
	}
	puts ""
	if {$exit_after} {
		exit -1;
	}
}

proc get_arguments {argc argv} {
	#
	# Get the arguments passed in from command line & process them accordingly
	#
	global action
	global terms

	# Read in command-line parameters
	# TODO - Add check for options before action & terms
	if {$argc < 1} {
		# Since there are no arguments passed in we just show the USAGE & exit.
		show_usage
	}
	#
	# Lets check for any dashes to see if any options were passed in
	# Set flags for any options found
	set has_options false
	#
	if {$has_options == false} {
		if {$argc >= 1} {
			set action [lindex $argv 0]
		}
		if {$argc > 1} {
			set terms ""
			for {set i 1} {$i < $argc} {incr i} {
				set terms [concat $terms " " [lindex $argv $i]]
			}
		}
	}
}

proc append_term {data itemno term} {
	global todo_path_n_file
	set loopcount 1
	
	set fp [open $todo_path_n_file "w"]
	foreach line $data {
		if {$loopcount != $itemno} {
			if {$loopcount != 1} {
				puts $fp ""
			}
			puts -nonewline $fp $line
		} else {
			if {$loopcount != 1} {
				puts $fp ""
			}
			# Append to the end of the item
			set line [append $line $line " " $term]
			puts -nonewline $fp $line
		}
		incr loopcount
	}
	close $fp
}

proc has_clock_in {data itemno} {
	set check ""
	set loopcount 1
	foreach line $data {
		if {$loopcount == $itemno} {
			set check $line
		}
		incr loopcount
	}

	# Return 1 if item is clocked in, 0 if not clocked in.
	# expected format    2011-12-28T13:29:59      YYYY-MM-DDTHH:MM:SS
	return [regexp {in:(19|20)\d\d[-](0[1-9]|1[012])[-](0[1-9]|[12]\d|3[01])T(0\d|1\d|2[0-3])[:]([0-5]\d)[:]([0-5]\d)} $check match]
}

proc get_clock_in {line} {
	# Return in:time if item has one, otherwise return empty string
	set result ""
	if {[regexp {in:(19|20)\d\d[-](0[1-9]|1[012])[-](0[1-9]|[12]\d|3[01])T(0\d|1\d|2[0-3])[:][0-5]\d[:][0-5]\d} $line match]} {
		#strip first three chars off "in:"
		set result [string range $match 3 [string length $match]]
	}
	return $result
}

proc has_lap_time {line} {
	# Return 1 if item has a lap:time, 0 if it does not
	return [regexp {lap:(\d\d)[:][0-5]\d[:][0-5]\d} $line]
}

proc get_lap_time {line} {
	# Return lap:time if item has one, otherwise return empty string
	set result ""
	if {[regexp {lap:(\d\d)[:][0-5]\d[:][0-5]\d} $line match]} {
		#strip first four chars off "lap:"
		set result [string range $match 4 [string length $match]]
	}
	return $result
}

proc calc_lap_time {in out} {
	# Return lap:time based on difference between in and out
	set clockin [clock scan $in]
	set clockout [clock scan $out]
	set diff [expr {$clockout - $clockin}]
	return [seconds_to_time $diff]
}

proc add_time {x_time y_time} {
	return [seconds_to_time [expr [time_to_seconds $x_time] + [time_to_seconds $y_time]]]
}

proc seconds_to_time {total_seconds} {
	set result ""
	set hours [expr int($total_seconds / 60 / 60)]
	set minutes [expr int(($total_seconds - ($hours * 60 * 60)) / 60)]
	set seconds [expr int($total_seconds - ($hours * 60 *60) - ($minutes * 60))]
	set result [format "%2.2d:%2.2d:%2.2d" $hours $minutes $seconds]
}

proc convert_to_integer {number_string} {
	set result ""
	set result [string trimleft $number_string 0]
	if {$result == ""} {
		set result 0
	}
	return $result
}

proc time_to_seconds {x_time} {
	set result 0
	regexp {^(\d\d)[:]([0-5]\d)[:]([0-5]\d)$} $x_time match hours minutes seconds
	set result [expr [convert_to_integer $hours] * 60 * 60 + [convert_to_integer $minutes] * 60 + [convert_to_integer $seconds]]
	return $result
}

proc replace_item {data itemno term} {
	global todo_path_n_file
	set loopcount 1
	
	set fp [open $todo_path_n_file "w"]
	foreach line $data {
		if {$loopcount != 1} {
			puts $fp ""
		}
		if {$loopcount != $itemno} {
			puts -nonewline $fp $line
		} else {
			# This is the line to replace
			set line [join [lrange $term 0 [llength $term]] " "]
			puts -nonewline $fp $line
		}
		incr loopcount
	}
	close $fp
}

proc get_bare_task {line} {
	set result $line
	set clock_in [get_clock_in $line]
	set lap_time [get_lap_time $line]
	regsub -all -- "in:$clock_in" $result "" result		;# strip out any clockins
	regsub -all -- "lap:$lap_time" $result "" result	;# strip out any laptimes
	return $result
}

proc process_clock_outs {} {
	# RECURSIVE FUNCTION
	# If a task is found that has a clockin, then update file removing that clockin, and call process_clock_outs again
	# If no task is found with a clockin, then just continue without doing anything.
	#
	# Since its recursive, we need to open and read in the file each time the proc is run.

	global todo_path_n_file
	set file_data [read_datafile $todo_path_n_file]
	set data [split $file_data "\n"]

	set loopcount 1
	set found 0
	
	foreach line $data {
		
		# make sure item has clock in
		if {[has_clock_in $data $loopcount]} {
		
			incr found
			
			# get the clock in timestamp
			set in_time [get_clock_in $line]

			# determine the clock out timestamp
			set sys_time [clock seconds]
			set out_time [clock format $sys_time -format %Y-%m-%dT%H:%M:%S] 
			
			# calculate the difference between out and in
			# convert difference to time
			set diff_time [calc_lap_time $in_time $out_time]
			
			# if has lap time already add difference to lap time
			if {[has_lap_time $line]} {
				set lap_time [add_time [get_lap_time $line] $diff_time]
			} else {
				set lap_time $diff_time
			}
			
			# trim lap time out of task
			set new_task [get_bare_task $line]
			
			# concat new lap time to task
			set new_task [append $new_task $new_task " lap:" $lap_time]
			
			# replace task
			replace_item $data $loopcount $new_task
		}
		incr loopcount
	}
	
	if {$found > 0} {
		process_clock_outs
	}
}

# =============================================================================
# ======================== MAIN LOOP ==========================================
# =============================================================================
global todo_path_n_file
global action
global terms

set action ""
set terms ""

# ---------- TCL INTERPRETER -----------|
set tcl_interpreter "tclsh"			; # |
# --------------------------------------|

get_arguments $argc $argv

# Determine path and filename
set fn todo.txt ;# TODO - Allow for diff filename from command line argument
set dir [file dirname [info script]]
set todo_path_n_file [file join $dir $fn]

# Get the data from the file
set file_data [read_datafile $todo_path_n_file]

#  Process data file
set data [split $file_data "\n"]

switch -exact -- $action {

	cur		-
	current	{
		# Displays the active clocked in task.
		puts [eval exec [auto_execok $tcl_interpreter] tl.tcl ls in:]
	}
	
	in {
		# Appends timestamp to task as in:timestamp
		# Will clock out any other tasks that are currently clocked in
		if {![has_clock_in $data [lindex $terms 0]]} {
			set sys_time [clock seconds]
			set in_time [clock format $sys_time -format %Y-%m-%dT%H:%M:%S] 
			append_term $data [lindex $terms 0] "in:$in_time"
		}
	}
	
	help	{
		show_usage "cur" true false
		show_usage "in" false false
		show_usage "help" false false
		show_usage "laps" false false
		show_usage "out" false false
		show_usage "shorthelp" false true
	}
	
	laps {
		# Displays report of all tasks with lap:times
		puts [eval exec [auto_execok $tcl_interpreter] tl.tcl ls lap:]
	}
	
	out	{
		# Clocks out all tasks that are clocked in
		# Removes in:timestamp, calculates lap:time, appends lap:time to task
		# 
		process_clock_outs
	}
	
	shorthelp {
		#   shorthelp
		#
		#      List the one-line usage of all built-in and add-on actions.
		
		set oneline {<<COMMAND SHORTCUT>> action [task_number]}
		puts ""
		puts "USAGE: $oneline"
		puts ""
		puts {   Actions:}
		puts {     cur|current}
		puts {     in ITEM#}
		puts {     help}
		puts {     laps}
		puts {     out}
		puts {     shorthelp}
		puts ""
	}
}
