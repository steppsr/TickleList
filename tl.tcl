# Project Creation Date: 2011-09-19                                           #
#                                                                             #
# Todo.txt implemenation in TCL/Tk                                            #
#                                                                             #
# ----------------------------------------------------------------------------#
# ACTION add			COMPLETE 2011-12-15 SRS
# ACTION addm			COMPLETE 2011-12-21 SRS
# ACTION addto			COMPLETE 2011-12-16 SRS
# ACTION append			COMPLETE 2011-12-16 SRS
# ACTION archive		COMPLETE 2011-12-20 SRS
# ACTION command		N/A - NOT IMPLEMENTING
# ACTION del			COMPLETE 2011-12-16 SRS
# ACTION depri			COMPLETE 2011-12-19 SRS
# ACTION do				COMPLETE 2011-12-16 SRS
# ACTION help			COMPLETE 2011-12-21 SRS
# ACTION list			COMPLETE 2011-12-15 SRS
# ACTION listall		COMPLETE 2011-12-21 SRS
# ACTION listcon		COMPLETE 2011-12-21 SRS
# ACTION listfile		COMPLETE 2011-12-21 SRS
# ACTION listpri		COMPLETE 2011-12-21 SRS
# ACTION listproj		COMPLETE 2011-12-21 SRS
# ACTION move			COMPLETE 2011-12-20 SRS
# ACTION pri			COMPLETE 2011-12-19 SRS
# ACTION prepend		COMPLETE 2011-12-21 SRS
# ACTION replace		COMPLETE 2011-12-21 SRS
# ACTION report			COMPLETE 2011-12-21 SRS
# ACTION shorthelp		COMPLETE 2011-12-21 SRS
#
# TODO - Need to allow options passed as arguments.

# =============================================================================
# =============================================================================
# ======================== PROC LIST ==========================================
# =============================================================================
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
	#   Maybe add in these options in the future: <<COMMAND SHORTCUT>> [-fhpantvV] [-d todo_config] action [task_number] [task_description]
	
	set oneline {<<COMMAND SHORTCUT>> action [task_number] [task_description]}
	if {$show_oneline} {
		puts ""
		puts "USAGE: $oneline"
		puts ""
	}
	switch -exact -- $action {
	
		add {
			puts {   add "THING I NEED TO DO +project @context"}
			puts {   a "THING I NEED TO DO +project @context"}
			puts {      Adds THING I NEED TO DO to your todo.txt file on its own line.}
			puts {      Project and context notation optional. Quotes optional.}
		}
		addm {
			puts {   addm "FIRST THING I NEED TO DO +project1 @context}
			puts {   SECOND THING I NEED TO DO +project2 @context"}
			puts {      Adds FIRST THING I NEED TO DO to your todo.txt on its own line and}
			puts {      Adds SECOND THING I NEED TO DO to you todo.txt on its own line.}
			puts {      Project and context notation optional. Quotes optional.}
			
		}
		addto	{
			puts {   addto DEST "TEXT TO ADD"}
			puts {      Adds a line of text to any file located in the todo.txt directory.}
			puts {      For example, addto inbox.txt "decide about vacation"}
		}

		append	{
			puts {   append ITEM# "TEXT TO APPEND"}
			puts {   app ITEM# "TEXT TO APPEND"}
			puts {      Adds TEXT TO APPEND to the end of the task on line ITEM#.}
			puts {      Quotes optional.}
		}
		
		archive {
			puts {   archive}
			puts {      Moves all done tasks from todo.txt to done.txt and removes blank lines.}
		}
		
		del {
			puts {   del ITEM# [TERM]}
			puts {   rm ITEM# [TERM]}
			puts {      Deletes the task on line ITEM# in todo.txt.}
			puts {      If TERM specified, deletes only TERM from the task.}
		}
		
		depri {
			puts {   depri ITEM#[, ITEM#, ITEM#, ...]}
			puts {   dp ITEM#[, ITEM#, ITEM#, ...]}
			puts {      Deprioritizes (removes the priority) from the task(s) on line ITEM# in todo.txt.}
		}
		
		do {
			puts {   do ITEM#[, ITEM#, ITEM#, ...]}
			puts {      Marks task(s) on line ITEM# as done in todo.txt.}
		}
		
		help	{
			puts {   help}
			puts {      Display this help message.}
		}
		list	{
			puts {   list [TERM...]}
			puts {   ls [TERM...]}
			puts {      Displays all tasks that contain TERM(s) sorted by priority with line}
			puts {      numbers.  If no TERM specified, lists entire todo.txt.}
		}
		listall	{
			puts {   listall [TERM...]}
			puts {   lsa [TERM...]}
			puts {      Displays all the lines in todo.txt AND done.txt that contain TERM(s)}
			puts {      sorted by priority with line  numbers.  If no TERM specified, lists}
			puts {      entire todo.txt AND done.txt concatenated and sorted.}
		}
		listcon {
			puts {   listcon}
			puts {   lsc}
			puts {      Lists all the task contexts that start with the @ sign in todo.txt.}
		}
		listfile {
			puts {   listfile [SRC [TERM...]]}
			puts {   lf [SRC [TERM...]]}
			puts {      Displays all the lines in SRC file located in the todo.txt directory,}
			puts {      sorted by priority with line  numbers.  If TERM specified, lists}
			puts {      all lines that contain TERM in SRC file.}
			puts {      Without any arguments, the names of all text files in the todo.txt}
			puts {      directory are listed.}
		}
		listpri {
			puts {   listpri [PRIORITY] [TERM...]}
			puts {   lsp [PRIORITY] [TERM...]}
			puts {      Displays all tasks prioritized PRIORITY.}
			puts {      If no PRIORITY specified, lists all prioritized tasks.}
			puts {      If TERM specified, lists only prioritized tasks that contain TERM.}
		}
		listproj {
			puts {   listproj}
			puts {   lsprj}
			puts {      Lists all the projects that start with the + sign in todo.txt.}
		}
		
		move	{
			puts {   move ITEM# DEST [SRC]}
			puts {   mv ITEM# DEST [SRC]}
			puts {      Moves a line from source text file (SRC) to destination text file (DEST).}
			puts {      Both source and destination file must be located in the directory defined}
			puts {      in the configuration directory.  When SRC is not defined it's by default todo.txt.}
		}

		prep {
			puts {   prepend ITEM# "TEXT TO PREPEND"}
			puts {   prep ITEM# "TEXT TO PREPEND"}
			puts {      Adds TEXT TO PREPEND to the beginning of the task on line ITEM#. Quotes optional.}
		}
			 
		pri {
			puts {   pri ITEM# PRIORITY}
			puts {   p ITEM# PRIORITY}
			puts {      Adds PRIORITY to task on line ITEM#.  If the task is already}
			puts {      prioritized, replaces current priority with new PRIORITY.}
			puts {      PRIORITY must be an uppercase letter between A and Z.}
		}
		
		replace	{
			puts {   replace ITEM# "UPDATED TODO"}
			puts {      Replaces task on line ITEM# with UPDATED TODO.}
		}
		report {
			puts {   report}
			puts {      dds the number of open tasks and done tasks to report.txt.}
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

proc show_result {data} {
	#
	#   Show the resulting filtered/sorted list
	#	
	global TODOTXT_FORMAT_LIST
	global TODOTXT_AGE
	
	set shown_counter 0
	set total_counter 0
	if {$TODOTXT_FORMAT_LIST} {
		if {$TODOTXT_AGE} {
			puts "   |AGE     |LAP     |IN                 |PRI|DONE DATE |ADD DATE  |TASK"
		} else {
			puts "   |LAP     |IN                 |PRI|DONE DATE |ADD DATE  |TASK"
		}
	}
	foreach line $data {
		if ![string equal $line ""] {
			puts $line
		}
	}
}

proc show_header {} {
	#
	#   Show the header
	#
	
	show_divider " "
	show_divider
	puts " Tickle List ... The TCL Todo.txt Implementation "
	show_divider
}

proc show_footer {shown total todo_path_n_file} {
	#
	#   Show the footer
	#
	
	puts ".."
	puts "TODO: $shown of $total shown from $todo_path_n_file"
}

proc show_divider { {div_char -} } {
	#
	# Show a divider to the screen
	#    Input:	character to use for divider bar
	#			if none, default is a dash
	#			" " will simulate a blank line
	
	set div_bar ""
	for {set i 1} {$i < 49} {incr i} {
		set div_bar [concat [string trim $div_bar][string trim $div_char]]
	}
	puts $div_bar
}

proc get_arguments {argc argv} {
	#
	# Get the arguments passed in from command line & process them accordingly
	#
	# TODO - Need to recognize the options from the arguments and deal with.
	#		OPTIONS TO SUPPORT
	# 			-@	
	#				Hide context names in list output. Use twice to show
	#				context names (default).
	#
	#			-+	
	#				Hide project names in list output. Use twice to show
	#				project names (default).
	#
	#			-c	
	#				Color mode   (MAY NOT BE POSSIBLE IN WINDOWS)
	#
	#			-d CONFIG_FILE	
	#				Use a configuration file other than the default 
	#				~/.todo/config
	#
	#			-f
	#				Forces actions without confirmation or interactive input
	#
	#			-h
	#				Display a short help message; same as action "shorthelp"
	#
	#			-p
	#				Plain mode turns off colors
	#
	#			-P
	#				Hide priority labels in list output. Use twice to show
	#				priority labels (default).
	#
	#			-a
	#				Don't auto-archive tasks automatically on completion
	#
	#			-A
	#				Auto-archive tasks automatically on completion
	#
	#			-n
	#				Preserve line numbers
	#
	#			-t
	#				Prepend the current date to a task automatically when it's added
	#
	#			-T
	#				Do not prepend the current date to a task automatically when
	#				it's added.
	#
	#			-v
	#				Verbose mode turns on confirmation messages
	#
	#			-vv
	#				Extra verbose mode prints some debugging information and
	#				additional help text.
	#
	#			-V
	#				Displays version, license and credits
	#
	#			-x
	#				Disables TODOTXT_FINAL_FILTER
	
	global action
	global terms
	global debug
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
}

proc filter_list_by_priority {data terms} {
	#
	#   Filter the passed in data and only return lines that contain the matching priority
	#   and that contain the rest of the terms
	#
	global shown_counter
	
	set shown_counter 0
	set result ""
	set loopcount 1
	set linecounter 1
	set filter ""
	
	set priority [lindex $terms 0]
	if {[string length $priority] == 1} {
		set priority "($priority)"
	}
	set filter [lrange $terms 1 [llength $terms]]
	
	foreach line $data {
		if {[get_priority $line] == $priority} {
			if {[string length $filter] > 0} {
				if {[string first $filter $line] >= 0} {
					set result [append result "{" [string trim $line] " " $linecounter "} "]
					incr loopcount
					incr shown_counter
				}
			} else {
				set result [append result "{" [string trim $line] " " $linecounter "} "]
				incr loopcount
				incr shown_counter
			}
		}
		incr linecounter
	}
	set result [lsort -ascii $result]
	set new_res ""
	foreach line $result {
		set split_line [split $line " "]
		set new_res [append new_res "{" [format "%02d" [lindex $split_line [expr [llength $split_line] - 1]]] " " [lrange $split_line 0 [expr [llength $split_line] - 2]] "} "]
	}
	set result $new_res
	return $result
}

proc filter_list {data terms} {
	#
	#   Filter the passed in data and only return lines that contain the terms
	#
	global debug
	global shown_counter
	global TODOTXT_FORMAT_LIST
	global TODOTXT_AGE
	
	set shown_counter 0
	set result ""
	set loopcount 1
	set linecounter 1
	
	if {[string length $terms] > 0} {
		foreach line $data {
			if ![string equal $line ""] {
				if {[string first $terms $line] >= 0} {
					set result [append result "{" [string trim $line] " " $linecounter "} "]
					incr loopcount
					incr shown_counter
				}
				incr linecounter
			}
		}
	} else {
		foreach line $data {
			if ![string equal $line ""] {
				set result [append result "{" [string trim $line] " " $linecounter "} "]
				incr loopcount
				incr shown_counter
				incr linecounter
			}
		}
	}
	set result [lsort -ascii $result]
	set new_res ""
	foreach line $result {
		set split_line [split $line " "]
		set itemno [lindex $split_line [expr [llength $split_line] - 1]]
		set rest [lrange $split_line 0 [expr [llength $split_line] - 2]]
		set rest [format_task $rest]
		set new_res [append new_res "{" [format "%02d" $itemno] " " $rest "} "]
	}
	set result $new_res
	return $result
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

proc get_lap_time {line} {
	# Return lap:time if item has one, otherwise return empty string
	set result ""
	if {[regexp {lap:(\d\d)[:][0-5]\d[:][0-5]\d} $line match]} {
		#strip first four chars off "lap:"
		set result [string range $match 4 [string length $match]]
	}
	return $result
}

proc format_task {line} {
	global TODOTXT_AGE
	global TODOTXT_AGE_DIGITS
	set result ""
	#
	# AGE       LAP      IN                  PRI END_DATE   START_DATE TASK
	# {10 days} 00:15:23 2011-12-30T13:12:30 (A)            2011-11-30 My task 
	# { 2 days}          2011-12-30T15:30:01  x  2011-12-29 2011-11-15 My task
	set age [get_age $line]
	set lap [get_lap_time $line]
	set clockin [get_clock_in $line]
	set pri [get_priority $line]
	set end_date [get_completion_date $line]
	set start_date [get_start_date $line]
	set bare [get_task_only $line]
	
	if {[string length $age] == 0} {
		set age_padding [expr {$TODOTXT_AGE_DIGITS + 6}]
		set age [format "%-*s" $age_padding "|"]
	}
	if {[string length $lap] == 0} {
		set lap "        "
	}
	if {[string length $clockin] == 0} {
		set clockin "                   "
	}
	if {[string length $pri] == 0} {
		set pri "   "
	}
	if {[string length $end_date] == 0} {
		set end_date "          "
	}
	if {[string length $start_date] == 0} {
		set start_date "          "
	}
	
	if {[is_complete $line]} {
		set pri " x "
	}
	if {$TODOTXT_AGE} {
		set result "$age|$lap|$clockin|$pri|$end_date|$start_date|$bare"
	} else {
		set result "|$lap|$clockin|$pri|$end_date|$start_date|$bare"
	}
	
	return $result
}

proc get_age {line} {
	global TODOTXT_AGE_DIGITS
	set result ""
	if {[has_start_date $line]} {
		set sys_time [clock seconds]
		set cur_day [clock format $sys_time -format %Y-%m-%d]
		set start_day [get_start_date $line]
		
		set x [clock scan $start_day]
		set y [clock scan $cur_day]
		set diff [expr {$y - $x}]
		set days_diff [format "%*d" $TODOTXT_AGE_DIGITS [expr {$diff / 86400}]]
		set result "|$days_diff days"
	}
	return $result
}

proc calc_total_counter {data} {
	#
	#
	#
	set loopcounter 0
	foreach line $data {
		if ![string equal $line ""] {
			incr loopcounter
		}
	}
	return $loopcounter
}

proc add_to {out_file new_item} {
	#
	#	It is assumed that after writing to the file the cursor is left
	#	at the end of the last item and not returned to a empty line.
	#
	global TODOTXT_DATE_ON_ADD
	set fp [open $out_file "a"]
	puts $fp ""						;# advance to a new line
	if {$TODOTXT_DATE_ON_ADD} {
		if {![has_start_date $new_item]} {
			set sys_time [clock seconds]
			set new_item [concat [clock format $sys_time -format %Y-%m-%d] [string trim $new_item]]
		}
	}
	puts -nonewline $fp $new_item	;# leave cursor at end of the line
	close $fp
}

proc do_item {data terms} {
	# 
	#   Marks task(s) on line ITEM# as done in todo.txt.
	# 
	global debug
	global todo_path_n_file
	
	set result ""
	set loopcount 1

	# Ensure we have some input
	set $terms [string trim $terms]
	if {[string length $terms] <= 0} {
		show_usage "do"
	}
	
	# Ensure the input is a number
	set items [split $terms " "]
	foreach item $items {
		if {![string is integer -strict $item]} {
			show_usage "do"
		}
	}

	set fp [open $todo_path_n_file "w"]
	foreach line $data {
		if {[lsearch -exact -integer $items $loopcount] >= 0} {
			# Match - so we knows its the selected line
			set sys_time [clock seconds]
			if {[string first "x " $line] != 0} {
				# Since its not already completed, we will do it
				# Check for a priority, if it has one we will need to remove it
				if {[string first "(" $line] == 0} {
					if {[string first ")" $line] == 2} {
						if {[string first " " $line] == 3} {
							set line [string range $line 3 [string length $line]]
						}
					}
				}
				set result [append result "x " [clock format $sys_time -format %Y-%m-%d] " " [string trim $line]]
				if {$loopcount != 1} {
					puts $fp ""
				}
				puts -nonewline $fp $result
			} else {
				if {$loopcount != 1} {
					puts $fp ""
				}
				puts -nonewline $fp $line
			}
		} else {
			# Does not match the line we are looking for so just write it to the result
			if {$loopcount != 1} {
				puts $fp ""
			}
			puts -nonewline $fp $line
		}
		set result ""
		incr loopcount
	}
	close $fp
}

proc del_item {data terms} {
	#
	#   Loop through and eliminate the given item (the first term)
	#
	global todo_path_n_file
	set loopcount 1

	set itemno [lindex $terms 0]
	
	# Ensure the itemno is a number
	if {![string is integer -strict $itemno]} {
		show_usage "del"
	}
	
	set fp [open $todo_path_n_file "w"]
	foreach line $data {
		if {$loopcount != $itemno} {
			if {$loopcount != 1} {
				puts $fp ""
			}
			puts -nonewline $fp $line
		}
		incr loopcount
	}
	close $fp
}

proc del_term {data terms} {
	#
	#   Loop though and eliminate the given term from the given item
	#
	global todo_path_n_file
	set loopcount 1
	
	set itemno [lindex $terms 0]
	
	# Ensure the itemno is a number
	if {![string is integer -strict $itemno]} {
		show_usage "del"
	}
	
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
			# Remove the term from the item
			set pattern [lrange $terms 1 [llength $terms]]
			while {[string first $pattern $line] >= 0} {
				set start_pos [string first $pattern $line]
				set end_pos [expr $start_pos + [string length $pattern]]
				set line [string replace $line $start_pos $end_pos]
			}
			puts -nonewline $fp $line
		}
		incr loopcount
	}
	close $fp
}

proc append_term {data terms} {
	#
	#   Adds TEXT TO APPEND to the end of the task on line ITEM#.
	#
	global todo_path_n_file
	set loopcount 1
	
	set itemno [lindex $terms 0]
	
	# Ensure the itemno is a number
	if {![string is integer -strict $itemno]} {
		show_usage "append"
	}
	
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
			set app_str [lrange $terms 1 [llength $terms]]
			set line [append $line $line " " $app_str]
			puts -nonewline $fp $line
		}
		incr loopcount
	}
	close $fp
}

proc depri_item {data terms} {
	#
	#   Deprioritizes (removes the priority) from the task(s) on line ITEM# in todo.txt.
	#
	global todo_path_n_file
	set loopcount 1
	set my_result ""
	
	set itemno [lindex $terms 0]
	
	# Ensure the itemno is a number
	if {![string is integer -strict $itemno]} {
		show_usage "depri"
	}
	
	set fp [open $todo_path_n_file "w"]
	foreach line $data {
		if {$loopcount != 1} {
			puts $fp ""
		}
		if {$loopcount != $itemno} {
			puts -nonewline $fp $line
		} else {
			# Remove the priority if it exists
			regsub {^[(].[)]} $line "" my_result
			puts -nonewline $fp [string trim $my_result]
		}
		incr loopcount
	}
	close $fp
}

proc pri_item {data terms} {
	#
	#
	#
	global todo_path_n_file
	set loopcount 1
	set my_result ""
	
	set itemno [lindex $terms 0]
	set priority [lindex $terms 1]
	
	# Ensure the itemno is a number
	if {![string is integer -strict $itemno]} {
		show_usage "pri"
	}
	
	set fp [open $todo_path_n_file "w"]
	foreach line $data {
		if {$loopcount != 1} {
			puts $fp ""
		}
		if {$loopcount != $itemno} {
			puts -nonewline $fp $line
		} else {
			# If its valid, add the priority
			if {[string length $priority] == 1} {
				if {[string is alpha -strict $priority]} {
					puts -nonewline $fp "("
					puts -nonewline $fp $priority
					puts -nonewline $fp ") "
					puts -nonewline $fp $line
				} else {
					puts -nonewline $fp $line
				}
			} elseif {[string length $priority] == 3} {
				set priority [string range $priority 1 1]
				if {[string is alpha -strict $priority]} {
					puts -nonewline $fp "("
					puts -nonewline $fp $priority
					puts -nonewline $fp ") "
					puts -nonewline $fp $line
				} else {
					puts -nonewline $fp $line
				}
			} else {
				puts -nonewline $fp $line
			}
		}
		incr loopcount
	}
	close $fp
}

proc archive_items {data} {
	#
	#   Moves all done tasks from todo.txt to done.txt and removes blank lines.
	#
	global todo_path_n_file
	global done_path_n_file

	set count_todo_items 0
	set count_done_items 0
	
	set fp_todo [open $todo_path_n_file "w"]
	if {[file exists $done_path_n_file] == 1} {
		set fp_done [open $done_path_n_file "a"]
	} else {
		set fp_done [open $done_path_n_file "w"]
	}
	
	foreach line $data {
		if {![string equal [string trim $line] ""]} {
			if {[is_complete $line] == 1} {
				# write to done
				puts $fp_done ""
				puts -nonewline $fp_done $line
				incr count_done_items
			} else {
				# write to todo
				if {$count_todo_items > 0} {
					puts $fp_todo ""
				}
				puts -nonewline $fp_todo $line
				incr count_todo_items
			}
		}
	}
	close $fp_todo
	close $fp_done
}

proc is_complete {line} {
	# Return 1 if item is complete, 0 if not completed.
	return [regexp {^[xX]} $line]
}

proc has_priority {line} {
	# Return 1 if item has priority, 0 if it does not.
	return [regexp {^[(][a-zA-Z][)]} $line]
}

proc valid_date {date} {
	return [regexp {^(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$} $date]
}

proc has_start_date {line} {
	set split_line [split $line " "]
	if {[is_complete $line]} {
		# completed item
		set start_date [lindex $split_line 2]
	} else {
		if {[has_priority $line]} {
			# incomplete item with priority
			set start_date [lindex $split_line 1]
		} else {
			# incomplete item without priority
			set start_date [lindex $split_line 0]
		}
	}
	return [valid_date $start_date]
}

proc get_priority {line} {
	#
	#   Get the priority of the item, if not return an empty string
	#
	set result ""
	if {[has_priority $line]} {
		set result [string range $line 0 2]
	}
	return $result
}

proc get_start_date {line} {
	#
	#   Get the start date if the item contains it, if not return empty string
	#
	if {[has_start_date $line]} {
		set split_line [split $line " "]
		if {[is_complete $line]} {
			set start_date [lindex $split_line 2]		;# completed item
		} else {
			if {[has_priority $line]} {
				set start_date [lindex $split_line 1]	;# incomplete item with priority
			} else {
				set start_date [lindex $split_line 0]	;# incomplete item without priority
			}
		}
		if {[valid_date $start_date]} {
			return $start_date
		}
	} 
	return ""
}

proc get_completion_date {line} {
	#
	#   Get the completion date if the item is completed, if not return empty string
	#
	set result ""
	if {[is_complete $line]} {
		set result [string range $line 2 11]
	}
	return $result
}

proc get_task_only {line} {
	#
	#   Get the task without completion flag, completion date, priority, or start date
	#
	set result $line
	if {[is_complete $line] && [has_start_date $line]} {
		set result [string range $line 24 [string length $line]]
	} elseif {[is_complete $line] && ![has_start_date $line]} {
		set result [string range $line 13 [string length $line]]
	} elseif {![is_complete $line] && [has_priority $line] && [has_start_date $line]} {
		set result [string range $line 15 [string length $line]]
	} elseif {![is_complete $line] && ![has_priority $line] && [has_start_date $line]} {
		set result [string range $line 11 [string length $line]]
	} elseif {![is_complete $line] && [has_priority $line] && ![has_start_date $line]} {
		set result [string range $line 4 [string length $line]]
	}
	set clock_in [get_clock_in $line]
	set lap_time [get_lap_time $line]
	regsub -all -- " in:$clock_in" [string trim $result] "" result		;# strip out any clockins
	regsub -all -- " lap:$lap_time" [string trim $result] "" result	;# strip out any laptimes
	return [string trim $result]
}

proc move_item {terms} {
	#
	#   Moves a line from source text file (SRC) to destination text file (DEST).
	#   Both source and destination file must be located in the directory defined
	#   in the configuration directory.  When SRC is not defined it's by default todo.txt. 
	#
	global todo_path_n_file
	set loopcount 1
	set count_source_items 0
	set count_destination_items 0
	set dir [file dirname [info script]]	
	set itemno [lindex $terms 0]
	set dest_file [lindex $terms 1]
	set source_file [lindex $terms 2]

	# Ensure the itemno is a number
	if {![string is integer -strict $itemno]} {
		show_usage "move"
	}
	# Ensure the source file is okay
	if {[string length $source_file] == 0} {
		# use todo.txt as source
		set source_path_n_file $todo_path_n_file
	} else {
		set source_path_n_file [file join $dir $source_file]
	}
	if {[file exists $source_path_n_file] == 0} {
		# source file does not exist
		puts "TODO: source file does not exist"
		show_usage "move"
	}
	# Ensure the destination file is okay
	set dest_path_n_file [file join $dir $dest_file]
	if {[file exists $dest_path_n_file] == 0} {
		# dest file does not exist
		puts "TODO: destination file does not exist"
		show_usage "move"
	}

	# Read in source file
	set file_data [read_datafile $source_path_n_file]
	set data [split $file_data "\n"]

	# Open Source and Destination files for writing output
	set fp_source [open $source_path_n_file "w"]
	set fp_dest [open $dest_file "a"]
	puts $fp_dest ""

	foreach line $data {
		if {$loopcount != $itemno} {
			#write to source
			if {$count_source_items != 0} {
				puts $fp_source ""
			}
			puts -nonewline $fp_source $line
			incr count_source_items
		} else {
			#write to dest
			if {$count_destination_items != 0} {
				puts $fp_dest ""
			}
			puts -nonewline $fp_dest $line
			incr count_destination_items
		}
		incr loopcount
	}
	close $fp_source
	close $fp_dest
}

proc prepend_term {data terms} {
	#
	#	Adds TEXT TO PREPEND to the beginning of the task on line ITEM#. Quotes optional.
	#
	global todo_path_n_file
	set loopcount 1
	
	set itemno [lindex $terms 0]
	
	# Ensure the itemno is a number
	if {![string is integer -strict $itemno]} {
		show_usage "prepend"
	}
	
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
			# Prepend to the beginning of the item
			set start_date ""
			set priority ""
			set task ""
			set prep_str [lrange $terms 1 [llength $terms]]
			set task [get_task_only $line]
			
			if {[has_start_date $line]} {
				set start_date [get_start_date $line]
				set start_date [append $start_date $start_date " "]
			}
			
			if {[has_priority $line]} {
				set priority [get_priority $line]
				set priority [append $priority $priority " "]
			}
			
			if {[is_complete $line]} {
				set line [append $line "x " [get_completion_date $line] " " $start_date $prep_str " " $task]
			} else {
				set line [append $line $priority $start_date $prep_str " " $task]
			}
			puts -nonewline $fp $line
		}
		incr loopcount
	}
	close $fp
}

proc replace_item {data terms} {
	#
	#
	#
	
	global todo_path_n_file
	set loopcount 1
	set itemno [lindex $terms 0]
	
	# Ensure the itemno is a number
	if {![string is integer -strict $itemno]} {
		show_usage "replace"
	}
	
	set fp [open $todo_path_n_file "w"]
	foreach line $data {
		if {$loopcount != 1} {
			puts $fp ""
		}
		if {$loopcount != $itemno} {
			puts -nonewline $fp $line
		} else {
			# This is the line to replace
			set line [join [lrange $terms 1 [llength $terms]] " "]
			puts -nonewline $fp $line
		}
		incr loopcount
	}
	close $fp
}

proc update_report {} {
	#
	#
	#
	
	global todo_path_n_file
	global done_path_n_file
	global rept_path_n_file
	global TODOTXT_AGE
	global TODOTXT_AGE_DIGITS
	
	set fp_todo [open $todo_path_n_file "r"]
	set fp_done [open $done_path_n_file "r"]
	set fp_report [open $rept_path_n_file "w"]
	
	set todo_count 0
	set done_count 0
	set total_count 0
	set sys_time [clock seconds]
	set report_date [clock format $sys_time -format %Y-%m-%d]
	
	puts $fp_report "Tickle List - Report.txt"
	puts $fp_report "-------------------------------------------------------------------------------------------------------------------"
	if {$TODOTXT_AGE} {
		set age_padding [expr {$TODOTXT_AGE_DIGITS + 6}]
		set age [format "%-*s" $age_padding "|AGE"]
		puts $fp_report "$age|LAP     |IN                 |PRI|DONE DATE |ADD DATE  |TASK"
		puts $fp_report "-------------------------------------------------------------------------------------------------------------------"
	} else {
		puts $fp_report "|LAP     |IN                 |PRI|DONE DATE |ADD DATE  |TASK"
		puts $fp_report "-------------------------------------------------------------------------------------------------------------------"
	}
	set file_data [read_datafile $todo_path_n_file]
	set data [split $file_data "\n"]
	foreach line $data {
		incr todo_count
		incr total_count
		puts $fp_report [format_task $line]
	}
	
	set file_data [read_datafile $done_path_n_file]
	set data [split $file_data "\n"]
	foreach line $data {
		incr done_count
		incr total_count
		puts $fp_report [format_task $line]
	}
	
	puts $fp_report "-------------------------------------------------------------------------------------------------------------------"
	puts $fp_report "$report_date  TODO:$todo_count DONE:$done_count TOTAL:$total_count"
	
	close $fp_todo
	close $fp_done
	close $fp_report
}

proc strip_double_quotes {str_source} {
	set result $str_source
	set stripped ""
	regexp {^["](.*)["]$} $str_source match stripped
	if {![string equal [string trim $stripped] ""]} {
		set result $stripped
	}
	return $result
}

proc get_settings {config_file} {
	global TODO_DIR
	global TODO_FILE
	global DONE_FILE
	global REPORT_FILE
	global TMP_FILE
	global TODOTXT_AUTO_ARCHIVE
	global TODOTXT_DATE_ON_ADD
	global TODOTXT_FORMAT_LIST
	global TODOTXT_AGE
	global TODOTXT_AGE_DIGITS

	set TODO_DIR ""
	set TODO_FILE ""
	set DONE_FILE ""
	set REPORT_FILE ""
	set TMP_FILE ""
	set TODOTXT_AUTO_ARCHIVE 0
	set TODOTXT_DATE_ON_ADD 0
	set TODOTXT_FORMAT_LIST 0
	set TODOTXT_AGE 0
	set TODOTXT_AGE_DIGITS 2
	
	set key ""
	set value ""
	
	set dir [file dirname [file normalize [info script]]]
	set cfg [file join $dir $config_file]
	set cfg_data [read_datafile $cfg]
	set cfg_items [split $cfg_data "\n"]
	
	foreach item $cfg_items {
		if {![string equal [string index [string trim $item] 0] "#"] && [string length [string trim $item]] > 0} {
			set kv [split $item "="]
			set key [lindex $kv 0]
			set value [lindex $kv 1]
		}
		switch -exact -- $key {
			TODO_DIR	{
				set TODO_DIR $value
			}
			TODO_FILE	{
				set TODO_FILE $value
			}
			DONE_FILE	{
				set DONE_FILE $value
			}
			REPORT_FILE	{
				set REPORT_FILE $value
			}
			TMP_FILE	{
				set TMP_FILE $value
			}
			TODOTXT_AUTO_ARCHIVE	{
				set TODOTXT_AUTO_ARCHIVE $value
			}
			TODOTXT_DATE_ON_ADD		{
				set TODOTXT_DATE_ON_ADD $value
			}
			TODOTXT_FORMAT_LIST		{
				set TODOTXT_FORMAT_LIST $value
			}
			TODOTXT_AGE				{
				set TODOTXT_AGE $value
			}
			TODOTXT_AGE_DIGITS		{
				set TODOTXT_AGE_DIGITS $value
			}
		}
	}
}

proc get_env {arg} {
	# get an ENVIRONMENT variable from the OS
	global env
	return $env($arg)
}

proc refresh_data {path_n_file} {
	set file_data [read_datafile $path_n_file]
	set data [split $file_data "\n"]
	return $data
}

# =============================================================================
# =============================================================================
# ======================== MAIN LOOP ==========================================
# =============================================================================
# =============================================================================
global todo_path_n_file
global done_path_n_file
global rept_path_n_file

global TODO_DIR
global TODO_FILE
global DONE_FILE
global REPORT_FILE
global TMP_FILE

global TODOTXT_AUTO_ARCHIVE
global TODOTXT_DATE_ON_ADD
global TODOTXT_FORMAT_LIST
global TODOTXT_AGE

global shown_counter
global total_counter

set action ""
set terms ""
set debug 0  ;# debug 0 = hide debug messages, debug 1 = show debug messages

if {$debug == 1} {
	show_header
}

get_arguments $argc $argv

set TODO_CFG "todo.cfg"	;# TODO honor option for alternate config file
get_settings $TODO_CFG

if {$debug == 1} {
	show_divider
}

# Determine path and filename
set fn $TODO_FILE
set dir $TODO_DIR	;# [file dirname [file normalize [info script]]]
set todo_path_n_file [file join $dir $fn]
set done_path_n_file [file join $dir $DONE_FILE]
set rept_path_n_file [file join $dir $REPORT_FILE]
set temp_path_n_file [file join $dir $TMP_FILE]

# Get the data from the file
set file_data [read_datafile $todo_path_n_file]

#  Process data file
set data [split $file_data "\n"]
set total_counter [calc_total_counter $data]
set shown_counter $total_counter	;# default to total because we havent filtered anything yet

switch -exact -- $action {
	a		-
	add		{
		#   add "THING I NEED TO DO +project @context"
		#   a "THING I NEED TO DO +project @context"
		#
		#      Adds THING I NEED TO DO to your todo.txt file on its own line.
		#      Project and context notation optional. Quotes optional.
		#
		# TODO - Determine the out_file to write to ($out_file)
		set out_file "todo.txt"
		add_to $out_file $terms
	}
	
	addm	{
		#   addm "FIRST THING I NEED TO DO +project1 @context
		#   SECOND THING I NEED TO DO +project2 @context"
		#      Adds FIRST THING I NEED TO DO to your todo.txt on its own line and
		#      Adds SECOND THING I NEED TO DO to you todo.txt on its own line.
		#      Project and context notation optional. Quotes optional.
		
		set out_file "todo.txt"
		add_to $out_file $terms
		gets stdin second_line
		set second_line [strip_double_quotes $second_line]
		add_to $out_file $second_line
	}
	
	addto	{
		#   addto DEST "TEXT TO ADD"
		#
		#      Adds a line of text to any file located in the todo.txt directory.
		#      For example, addto inbox.txt "decide about vacation"
		
		set ptr [string first " " $terms]
		set out_file [string range $terms 0 $ptr]
		if { [file exists $out_file] == 1} {
			set terms [string trim [string range $terms $ptr [string length $terms]]]
			add_to $out_file $terms
		} else {
			puts "TODO: File does not exist."
			show_usage "addto"
		}
	}
	
	do		{
		#   do ITEM#[, ITEM#, ITEM#, ...]
		#
		#      Marks task(s) on line ITEM# as done in todo.txt.
		do_item $data $terms
		if {$TODOTXT_AUTO_ARCHIVE} {
			set data [refresh_data $todo_path_n_file]
			archive_items $data
		}
	}
	
	rm		-
	del		{
		#   del ITEM# [TERM]
		#   rm ITEM# [TERM]
		#
		#      Deletes the task on line ITEM# in todo.txt.
		#      If TERM specified, deletes only TERM from the task.
		if {[llength $terms] > 1} {
			del_term $data $terms
		} elseif {[llength $terms] == 1} {
			del_item $data $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "del"
		}
	}
	
	app		-
	append	{
		#   append ITEM# "TEXT TO APPEND"
		#   app ITEM# "TEXT TO APPEND"
		#
		#      Adds TEXT TO APPEND to the end of the task on line ITEM#.
		#      Quotes optional.
		
		# Ensure we have at least two terms. First is itemno, rest text to append
		if {[llength $terms] > 1} {
			append_term $data $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "append"
		}
	}
	
	archive {
		#
		#   Moves all done tasks from todo.txt to done.txt and removes blank lines.
		#
		archive_items $data
	}
	
	dp		-
	depri	{
		#   depri ITEM#[, ITEM#, ITEM#, ...]
		#   dp ITEM#[, ITEM#, ITEM#, ...]
		#
		#      Deprioritizes (removes the priority) from the task(s)
		#      on line ITEM# in todo.txt.

		if {[llength $terms] > 0} {
			depri_item $data $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "depri"
		}
	}
	
	help	{
		show_usage "add" true false
		show_usage "addm" false false
		show_usage "addto" false false
		show_usage "append" false false
		show_usage "archive" false false
		show_usage "del" false false
		show_usage "depri" false false
		show_usage "do" false false
		show_usage "help" false false
		show_usage "list" false false
		show_usage "listall" false false
		show_usage "listcon" false false
		show_usage "listfile" false false
		show_usage "listpri" false false
		show_usage "listproj" false false
		show_usage "move" false false
		show_usage "prep" false false
		show_usage "pri" false false
		show_usage "replace" false false
		show_usage "report" false false
		show_usage "shorthelp" false false
	}
	
	ls		-
	list	{
		#   list [TERM...]
		#   ls [TERM...]
		#
		#      Displays all tasks that contain TERM(s) sorted by priority with line
		#      numbers. If no TERM specified, lists entire todo.txt

		set list_data $data
		set list_data [filter_list $list_data $terms]
		show_result $list_data
		show_footer $shown_counter $total_counter $todo_path_n_file
	}
	
	lsa		-
	listall	{
		#   listall [TERM...]
		#   lsa [TERM...]
		#
		#      Displays all the lines in todo.txt AND done.txt that contain TERM(s)
		#      sorted by priority with line  numbers.  If no TERM specified, lists
		#      entire todo.txt AND done.txt concatenated and sorted.
		
		set files ""
		set file_data [read_datafile $done_path_n_file]
		set done_data [split $file_data "\n"]
		set list_data [concat $data $done_data]
		set list_data [filter_list $list_data $terms]
		show_result $list_data
		set files [append files $todo_path_n_file " & " $done_path_n_file]
		show_footer $shown_counter [llength $list_data] $files 
	}
	
	lsc		-
	listcon	{
		#   listcon
		#   lsc
		#
		#      Lists all the task contexts that start with the @ sign in todo.txt.
		
		set list_data $data
		set list_data [filter_list $list_data "@"]
		show_result $list_data
		show_footer $shown_counter $total_counter $todo_path_n_file
	}
	
	lf			-
	listfile	{
		#   listfile SRC [TERM...]
		#   lf SRC [TERM...]
		#
		#      Displays all the lines in SRC file located in the todo.txt directory,
		#      sorted by priority with line  numbers.  If TERM specified, lists
		#      all lines that contain TERM in SRC file.
		
		set src ""
		set filter ""
		set file_items 0
		if {[llength $terms] > 0} {
			set src [lindex $terms 0]
			if {[llength $terms] > 1} {
				set filter [lrange $terms 1 [llength $terms]]
			}
			if {[file exists $src]} {
				set file_data [read_datafile $src]
				set list_data [split $file_data "\n"]
				set file_items [llength $list_data]
				set list_data [filter_list $list_data $filter]
				show_result $list_data
				show_footer $shown_counter $file_items $src
			}
		} else {
			puts "TODO: Missing parameter."
			show_usage "listfile"
		}
	}
	
	lsp			-
	listpri		{
		#   listpri [PRIORITY] [TERM...]
		#   lsp [PRIORITY] [TERM...]
		#
		#      Displays all tasks prioritized PRIORITY.
		#      If no PRIORITY specified, lists all prioritized tasks.
		#      If TERM specified, lists only prioritized tasks that contain TERM.
		if {![llength $terms] > 0} {
			puts "TODO: Missing parameter."
			show_usage "listpri"
		} 
		
		set list_data $data
		set list_data [filter_list_by_priority $list_data $terms]
		show_result $list_data
		show_footer $shown_counter $total_counter $todo_path_n_file
	}
	
	lsprj		-
	listproj	{
		#   listproj
		#   lsprj
		#
		#      Lists all the projects that start with the + sign in todo.txt.
		
		set list_data $data
		set list_data [filter_list $list_data "+"]
		set list_data [filter_list $list_data $terms]
		show_result $list_data
		show_footer $shown_counter $total_counter $todo_path_n_file
	}
	
	mv		-
	move	{
		#   move ITEM# DEST [SRC]
		#   mv ITEM# DEST [SRC]
		#
		#      Moves a line from source text file (SRC) to destination text file (DEST).
		#      Both source and destination file must be located in the directory defined
		#      in the configuration directory.  When SRC is not defined it's by default todo.txt.
		
		if {[llength $terms] > 1} {
			move_item $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "move"
		}
	}
	
	p	-
	pri	{
		#   pri ITEM# PRIORITY
		#   p ITEM# PRIORITY
		#      Adds PRIORITY to task on line ITEM#.  If the task is already
		#      prioritized, replaces current priority with new PRIORITY.
		#      PRIORITY must be an uppercase letter between A and Z.

		if {[llength $terms] > 1} {
			pri_item $data $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "pri"
		}
	}
	
	prep	-
	prepend	{
		#   prepend ITEM# "TEXT TO PREPEND"
		#   prep ITEM# "TEXT TO PREPEND"
		#
		#      Adds TEXT TO PREPEND to the beginning of the task on line ITEM#.
		#      Quotes optional.

		if {[llength $terms] > 1} {
			prepend_term $data $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "prep"
		}
	}
	
	replace	{
		#   replace ITEM# "UPDATED TODO"
		#
		#      Replaces task on line ITEM# with UPDATED TODO.
		
		if {[llength $terms] > 1} {
			replace_item $data $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "replace"
		}
	}
	
	report {
		#   report
		#
		#      Adds the number of open tasks and done tasks to report.txt.
		
		archive_items $data
		update_report
	}
	
	shorthelp {
		#   shorthelp
		#
		#      List the one-line usage of all built-in and add-on actions.
		
		set oneline {<<COMMAND SHORTCUT>> action [task_number] [task_description]}
		puts ""
		puts "USAGE: $oneline"
		puts ""
		puts {   Actions:}
		puts {     add|a "THING I NEED TO DO +project @context"}
		puts {     addm "THINGS I NEED TO DO}
		puts {           MORE THINGS I NEED TO DO"}
		puts {     addto DEST "TEXT TO ADD"}
		puts {     append|app ITEM# "TEXT TO APPEND"}
		puts {     archive}
		puts {     del|rm ITEM# [TERM]}
		puts {     depri|dp ITEM#[, ITEM#, ITEM#, ...]}
		puts {     do ITEM#[, ITEM#, ITEM#, ...]}
		puts {     help}
		puts {     list|ls [TERM...]}
		puts {     listall|lsa [TERM...]}
		puts {     listcon|lsc}
		puts {     listfile|lf [SRC [TERM...]]}
		puts {     listpri|lsp [PRIORITY] [TERM...]}
		puts {     listproj|lsprj [TERM...]}
		puts {     move|mv ITEM# DEST [SRC]}
		puts {     prepend|prep ITEM# "TEXT TO PREPEND"}
		puts {     pri|p ITEM# PRIORITY}
		puts {     replace ITEM# "UPDATED TODO"}
		puts {     report}
		puts {     shorthelp}
		puts ""
	}
}
