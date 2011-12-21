# Project Creation Date: 2011-09-19                                           #
#                                                                             #
# Todo.txt implemenation in TCL/Tk                                            #
#                                                                             #
# ----------------------------------------------------------------------------#
# ACTION add			COMPLETE 2011-12-15 SRS
# ACTION addm			
# ACTION addto			COMPLETE 2011-12-16 SRS
# ACTION append			COMPLETE 2011-12-16 SRS
# ACTION archive		COMPLETE 2011-12-20 SRS
# ACTION command		N/A - NOT IMPLEMENTING
# ACTION del			COMPLETE 2011-12-16 SRS
# ACTION depri			COMPLETE 2011-12-19 SRS
# ACTION do				COMPLETE 2011-12-16 SRS
# ACTION help			
# ACTION list			COMPLETE 2011-12-15 SRS
# ACTION listall		
# ACTION listcon		
# ACTION listfile		
# ACTION listpri		
# ACTION listproj		
# ACTION move			COMPLETE 2011-12-20 SRS
# ACTION prepend		
# ACTION pri			COMPLETE 2011-12-19 SRS
# ACTION replace		
# ACTION report		
# ACTION shorthelp		
#
# TODO - Need to code the show_usage proc.
# TODO - Need to allow options passed as arguments.
#

# =============================================================================
# =============================================================================
# ======================== PROC LIST ==========================================
# =============================================================================
# =============================================================================
proc read_datafile {filename} {
	##
	## Read in a data file
	##
	set fp [open $filename r]
	set file_data [read $fp]
	close $fp
	return $file_data
}

proc show_usage { {action "help"} } {
	##
	## Show usage and exit
	##
	## Maybe add in these options in the future: <<SCRIPTNAME>> [-fhpantvV] [-d todo_config] action [task_number] [task_description]
	set oneline {<<SCRIPTNAME>> action [task_number] [task_description]}

	switch -exact -- $action {
	
		addto	{
			puts ""
			puts "USAGE: $oneline"
			puts ""
			puts {   addto DEST "TEXT TO ADD"}
			puts ""
			puts {   Adds a line of text to any file located in the todo.txt directory.}
			puts {   For example, addto inbox.txt "decide about vacation"}
			puts ""
		}
		
		append	{
			puts ""
			puts "USAGE: $oneline"
			puts ""
			puts {   append ITEM# "TEXT TO APPEND"}
			puts {   app ITEM# "TEXT TO APPEND"}
			puts ""
			puts {   Adds TEXT TO APPEND to the end of the task on line ITEM#.}
			puts {   Quotes optional.}
			puts ""
		}
		
		del {
			puts ""
			puts "USAGE: $oneline"
			puts ""
			puts {   del ITEM# [TERM]}
			puts {   rm ITEM# [TERM]}
			puts ""
			puts {   Deletes the task on line ITEM# in todo.txt.}
			puts {   If TERM specified, deletes only TERM from the task.}
			puts ""
		}
		
		do {
			puts ""
			puts "USAGE: $oneline"
			puts ""
			puts {   do ITEM#[, ITEM#, ITEM#, ...]}
			puts ""
			puts {   Marks task(s) on line ITEM# as done in todo.txt.}
			puts ""
		}
		
		depri {
			puts ""
			puts "USAGE: $oneline" 
			puts ""
			puts {   depri ITEM#[, ITEM#, ITEM#, ...]}
			puts {   dp ITEM#[, ITEM#, ITEM#, ...]}
			puts ""
			puts {   Deprioritizes (removes the priority) from the task(s) on line ITEM# in todo.txt.}
			puts ""
		}
		
		help	{
			puts "USAGE: $oneline" ;# TODO - Need to code the show_usage proc.
		}
		
		move	{
			puts ""
			puts "USAGE: $oneline"
			puts ""
			puts {   move ITEM# DEST [SRC]}
			puts {   mv ITEM# DEST [SRC]}
			puts ""
			puts {   Moves a line from source text file (SRC) to destination text file (DEST).}
			puts {   Both source and destination file must be located in the directory defined}
			puts {   in the configuration directory.  When SRC is not defined it's by default todo.txt.}
			puts ""
		}

		prep {
			puts ""
			puts "USAGE: $oneline"
			puts ""
			puts {   prepend ITEM# "TEXT TO PREPEND"}
			puts {   prep ITEM# "TEXT TO PREPEND"}
			puts ""
			puts {   Adds TEXT TO PREPEND to the beginning of the task on line ITEM#.}
			puts {   Quotes optional.}
			puts ""
		}
			 
		pri {
			puts ""
			puts "USAGE: $oneline"
			puts ""
			puts {   pri ITEM# PRIORITY}
			puts {   p ITEM# PRIORITY}
			puts ""
			puts {   Adds PRIORITY to task on line ITEM#.  If the task is already}
			puts {   prioritized, replaces current priority with new PRIORITY.}
			puts {   PRIORITY must be an uppercase letter between A and Z.}
			puts ""
		}
	}
	exit -1;
}

proc show_result {data} {
	##
	## Show the resulting filtered/sorted list
	##	
	set shown_counter 0
	set total_counter 0
	foreach line $data {
		if ![string equal $line ""] {
			puts $line
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

proc show_footer {shown total todo_path_n_file} {
	##
	## Show the footer
	##
	puts ".."
	puts "TODO: $shown of $total shown from $todo_path_n_file"
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
	##
	## Get the arguments passed in from command line & process them accordingly
	##
	## TODO - Need to recognize the options from the arguments and deal with.
	##		OPTIONS TO SUPPORT
	## 			-@	
	##				Hide context names in list output. Use twice to show
	##				context names (default).
	##
	##			-+	
	##				Hide project names in list output. Use twice to show
	##				project names (default).
	##
	##			-c	
	##				Color mode   (MAY NOT BE POSSIBLE IN WINDOWS)
	##
	##			-d CONFIG_FILE	
	##				Use a configuration file other than the default 
	##				~/.todo/config
	##
	##			-f
	##				Forces actions without confirmation or interactive input
	##
	##			-h
	##				Display a short help message; same as action "shorthelp"
	##
	##			-p
	##				Plain mode turns off colors
	##
	##			-P
	##				Hide priority labels in list output. Use twice to show
	##				priority labels (default).
	##
	##			-a
	##				Don't auto-archive tasks automatically on completion
	##
	##			-A
	##				Auto-archive tasks automatically on completion
	##
	##			-n
	##				Preserve line numbers
	##
	##			-t
	##				Prepend the current date to a task automatically when it's added
	##
	##			-T
	##				Do not prepend the current date to a task automatically when
	##				it's added.
	##
	##			-v
	##				Verbose mode turns on confirmation messages
	##
	##			-vv
	##				Extra verbose mode prints some debugging information and
	##				additional help text.
	##
	##			-V
	##				Displays version, license and credits
	##
	##			-x
	##				Disables TODOTXT_FINAL_FILTER
	##
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

proc filter_list {data terms} {
	##
	## Filter the passed in data and only return lines that contain
	##    the terms
	##
	global debug
	global shown_counter
	set shown_counter 0
	
	set result ""
	set loopcount 1
	set linecounter 1
	
	if {[string length $terms] > 0} {
		foreach line $data {
			if ![string equal $line ""] {
				if {[string first $terms $line] >= 0} {
					if {$loopcount == 1} {
						set result [append result "{" $linecounter " " [string trim $line] "} "]
						incr loopcount
					} else {
						set result [append result " {" $linecounter " " [string trim $line] "} "]
						incr loopcount
					}
					incr shown_counter
				}
				incr linecounter
			}
		}
	} else {
		foreach line $data {
			if ![string equal $line ""] {
				if {$loopcount == 1} {
					set result [append result "{" $linecounter " " [string trim $line] "} "]
					incr loopcount
				} else {
					set result [append result " {" $linecounter " " [string trim $line] "} "]
					incr loopcount
				}
				incr shown_counter
				incr linecounter
			}
		}
	}
	return $result
}

proc calc_total_counter {data} {
	set loopcounter 0
	foreach line $data {
		if ![string equal $line ""] {
			incr loopcounter
		}
	}
	return $loopcounter
}

proc add_to {out_file new_item} {
	##
	##	It is assumed that after writing to the file the cursor is left
	##	at the end of the last item and not returned to a empty line.
	##
	set fp [open $out_file "a"]
	puts $fp ""						;# advance to a new line
	puts -nonewline $fp $new_item	;# leave cursor at end of the line
	close $fp
}

proc do_item {data terms} {
	## 
	## Marks task(s) on line ITEM# as done in todo.txt.
	## 
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
	# Loop through and eliminate the given item (the first term)
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
	# Loop though and eliminate the given term from the given item
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
	# Adds TEXT TO APPEND to the end of the task on line ITEM#.
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
	# Deprioritizes (removes the priority) from the task(s) on line ITEM# in todo.txt.
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
	# Moves all done tasks from todo.txt to done.txt and removes blank lines.
	#
	global todo_path_n_file
	global done_path_n_file

	set count_todo_items 0
	set count_done_items 0
	
	set fp_todo [open $todo_path_n_file "w"]
	if {[file exists $done_path_n_file] == 1} {
		set fp_done [open $done_path_n_file "a"]
		puts $fp_done ""
	} else {
		set fp_done [open $done_path_n_file "w"]
	}
	
	foreach line $data {
		if {[is_complete $line] == 1} {
			# write to done
			if {$count_done_items != 0} {
				puts $fp_done ""
			}
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

proc get_start_date {line} {
	#
	# Get the start date if the item contains it, if not return empty string
	#
	if {[has_start_date $line]} {
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
		if {[valid_date $start_date]} {
			return $start_date
		}
	} 
	return ""
}

proc move_item {terms} {
	#
	# Moves a line from source text file (SRC) to destination text file (DEST).
	# Both source and destination file must be located in the directory defined
	# in the configuration directory.  When SRC is not defined it's by default todo.txt. 
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
			# TODO	Need to do the prepend after the priority, completion, and start date
			#		Also if prepend string begins with a date, then replace the existing start date
			set prep_str [lrange $terms 1 [llength $terms]]
			set line [append $line $prep_str " " $line]
			puts -nonewline $fp $line
		}
		incr loopcount
	}
	close $fp
}

# =============================================================================
# =============================================================================
# ======================== MAIN LOOP ==========================================
# =============================================================================
# =============================================================================
global todo_path_n_file
global done_path_n_file

global shown_counter
global total_counter

set action ""
set terms ""
set debug 0  ;# debug 0 = hide debug messages, debug 1 = show debug messages

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
set todo_path_n_file [file join $dir $fn]
set done_path_n_file [file join $dir "done.txt"]

# Get the data from the file
set file_data [read_datafile $todo_path_n_file]

#  Process data file
set data [split $file_data "\n"]
set total_counter [calc_total_counter $data]
set shown_counter $total_counter	;# default to total because we havent filtered anything yet

switch -exact -- $action {
	ls		-
	list	{
		#  list [TERM...]
		#  ls [TERM...]
		#
		#  Displays all tasks that contain TERM(s) sorted by priority with line
		#  numbers. If no TERM specified, lists entire todo.txt
		#
		#  TODO - sort $data by priority (after filter)
		set list_data $data
		set list_data [filter_list $list_data $terms]
		show_divider " "
		show_result $list_data
		show_footer $shown_counter $total_counter $todo_path_n_file
		show_divider " "
	}
	
	a		-
	add		{
		# add "THING I NEED TO DO +project @context"
		# a "THING I NEED TO DO +project @context"
		#
		# Adds THING I NEED TO DO to your todo.txt file on its own line.
		# Project and context notation optional.
		# Quotes optional.
		#
		# TODO - Determine the out_file to write to ($out_file)
		set out_file "todo.txt"
		add_to $out_file $terms
	}
	
	addto	{
		# addto DEST "TEXT TO ADD"
		#
		# Adds a line of text to any file located in the todo.txt directory.
		# For example, addto inbox.txt "decide about vacation"
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
		# do ITEM#[, ITEM#, ITEM#, ...]
		#
		# Marks task(s) on line ITEM# as done in todo.txt.
		do_item $data $terms
	}
	
	rm		-
	del		{
		# del ITEM# [TERM]
		# rm ITEM# [TERM]
		#
		# Deletes the task on line ITEM# in todo.txt.
		# If TERM specified, deletes only TERM from the task.
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
		# append ITEM# "TEXT TO APPEND"
		# app ITEM# "TEXT TO APPEND"
		#
		# Adds TEXT TO APPEND to the end of the task on line ITEM#.
		# Quotes optional.
		
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
		# Moves all done tasks from todo.txt to done.txt and removes blank lines.
		#
		archive_items $data
	}
	
	dp		-
	depri	{
		# depri ITEM#[, ITEM#, ITEM#, ...]
		# dp ITEM#[, ITEM#, ITEM#, ...]
		#
		# Deprioritizes (removes the priority) from the task(s)
		# on line ITEM# in todo.txt.

		if {[llength $terms] > 0} {
			depri_item $data $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "depri"
		}
	}
	
	mv		-
	move	{
		#   move ITEM# DEST [SRC]
		#   mv ITEM# DEST [SRC]
		#
		#   Moves a line from source text file (SRC) to destination text file (DEST).
		#   Both source and destination file must be located in the directory defined
		#   in the configuration directory.  When SRC is not defined it's by default todo.txt.
		
		if {[llength $terms] > 1} {
			move_item $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "move"
		}
	}
	
	p	-
	pri	{
	if {[llength $terms] > 1} {
			pri_item $data $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "pri"
		}
	}
	
	prep	-
	prepend	{
		#	prepend ITEM# "TEXT TO PREPEND"
		#	prep ITEM# "TEXT TO PREPEND"
		#
		#	Adds TEXT TO PREPEND to the beginning of the task on line ITEM#.
		#	Quotes optional.

		if {[llength $terms] > 1} {
			prepend_term $data $terms
		} else {
			puts "TODO: Missing parameter."
			show_usage "prep"
		}
	}
}
