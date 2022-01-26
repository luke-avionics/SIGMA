#!/bin/sh
# Silicon Creations
# Copyright 2012-2017 Silicon Creations LLC. All rights reserved.
# support@siliconcr.com
# Wed Aug  1 09:31:32 EDT 2018

# Command file for running Mentor Questa Verilog in batch mode
# Note : syntax for Cadence ncverilog and Synopsys vcs is similar

# Top Level Verilog TB File: test_LVDSTS28HPCPBI1B.v
# example usage (command line output mode): 
# % setenv QSIM_MODE cli
# % sh run_questa.sh

# Optional .do configuration file support for GUI mode:
# setenv QSIM_MODE gui
# % sh run_questa.sh <do_file>

# Set up working directory for Questa
rm -R work > /dev/null 2>&1
vlib work


# Compile verilog model

vlog -novopt \
+libext+.v+ \
-v LVDSTS28HPCPBI1B_verilog_library.v \
-v testbench_verilog_library.v \
+incdir+. \
test_LVDSTS28HPCPBI1B.v > test_LVDSTS28HPCPBI1B.vlog 

# Find errors and warnings in compilation step

ERROR_STATUS=$?

echo "Questa run script : Find errors and warnings from vlog file"
grep -i warning test_LVDSTS28HPCPBI1B.vlog
grep -i error test_LVDSTS28HPCPBI1B.vlog
# Quit if errors during compilation

if [ $ERROR_STATUS -ne 0 ]
then
	exit $ERROR_STATUS;
fi




# Run optimization on the design
vopt +acc test_LVDSTS28HPCPBI1B -o test_LVDSTS28HPCPBI1B_opt > test_LVDSTS28HPCPBI1B.opt
# Find errors and warnings during elaboration

ERROR_STATUS=$?
echo "Questa run script : Find errors and warnings from opt file"
grep -i warning test_LVDSTS28HPCPBI1B.opt
grep -i error test_LVDSTS28HPCPBI1B.opt
# Quit if errors during elaboration

if [ $ERROR_STATUS -ne 0 ]
then
	exit $ERROR_STATUS;
fi




# Create simple control file
echo "run -all" > test_LVDSTS28HPCPBI1B_questa_ctrl.txt
echo "quit -f" >> test_LVDSTS28HPCPBI1B_questa_ctrl.txt
# Run simulation from the command line 
	vsim  test_LVDSTS28HPCPBI1B_opt < test_LVDSTS28HPCPBI1B_questa_ctrl.txt > test_LVDSTS28HPCPBI1B.out
# Find errors and warnings during simulation

ERROR_STATUS=$?
echo "Questa run script : Print shortened out file"
grep -v Loading test_LVDSTS28HPCPBI1B.out
# Quit if errors during simulation

if [ $ERROR_STATUS -ne 0 ]
then
	exit $ERROR_STATUS;
fi
