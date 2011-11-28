# Project Creation Date: 2011-09-19
# 
# Todo.txt implemenation in TCL/Tk
#

# Read in command-line parameters
if {$argc < 1} {
  # Since there are no arguments passed in, we just show the USAGE and exit.
	puts "USAGE:" ;# TODO - fill in complete USAGE for command line interface
	exit -1;
}

set dir [file dirname [info script]]
set path_n_file [file join $dir todo.txt]

set file_data [read_datafile $path_n_file]

#  Process data file
set data [split $file_data "\n"]

foreach line $data {
	# do some line processing here
	
	puts [string range $line 0 78] ;# Just the first 78 chars
}

#  Slurp up the data file
proc read_datafile {filename} {
  set fp [open $filename r]
  set file_data [read $fp]
	close $fp
	return $file_data
}
