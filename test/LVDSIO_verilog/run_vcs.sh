#!/bin/sh
# Silicon Creations
# Copyright 2012-2017 Silicon Creations LLC. All rights reserved.
# support@siliconcr.com
# Wed Aug  1 09:31:40 EDT 2018

# Command file for running Synopsys VCS in batch mode

# file for running test bench : test_LVDSTS28HPCPBI1B.v

# Set up working directory for VCS
#nclib=ncvlog_lib
top=test_LVDSTS28HPCPBI1B

rm $top.vcslog > /dev/null 2>&1
echo "Setting up project. Sending log information to $top.vcslog"

# Compile / Elaborate Together #
echo "Running Compilation/Elaboration" >> $top.vcslog
vcs \
	-full64 \
	-sverilog \
	-debug_all \
	-P ${VERDI_HOME}/share/PLI/VCS/LINUXAMD64/novas.tab ${VERDI_HOME}/share/PLI/VCS/LINUXAMD64/pli.a \
	+neg_tchk \
	+libext+.v+ \
	-o $top.vcssim \
	-v LVDSTS28HPCPBI1B_verilog_library.v \
	-v testbench_verilog_library.v \
	+incdir+. \
	$top.v >> $top.vcslog

# Check for errors during compilation #
#
ERROR_STATUS=$?

vlog_errors=`grep "Error" $top.vcslog | wc -l`
if [ $vlog_errors -gt 0 ] || [ $ERROR_STATUS -ne 0 ]
then
	echo "Compiling/Elaborating $top: [Error]"
	cat $top.vcslog
	exit $ERROR_STATUS;
else
	echo "Compiling/Elaborating $top: [OK]"
	echo "Output file is $top.vcssim." >> $top.vcslog
	echo "% ./$top.vcssim to run" >> $top.vcslog
fi

# Simulation Step #
echo "Running Simulation."
echo "Running Simulation" >> $top.vcslog

./$top.vcssim > $top.out	

# Check for errors during simulation #
ERROR_STATUS=$?

cat $top.out
echo "
Placing output in $top.out"

if [ $ERROR_STATUS -ne 0 ]
then
	exit $ERROR_STATUS;
fi
