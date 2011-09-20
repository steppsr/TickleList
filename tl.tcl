# Project Creation Date: 2011-09-19
# 
# Todo.txt implemenation in TCL/Tk
#

# Read in command-line parameters
# 


#  Slurp up the data file
set fp [open "todo.txt" r]
set file_data [read $fp]
close $fp

#  Process data file
set data [split $file_data "\n"]
foreach line $data {
  # do some line processing here
}