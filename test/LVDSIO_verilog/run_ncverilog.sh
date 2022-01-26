#!/bin/sh
# Silicon Creations
# Copyright 2012-2017 Silicon Creations LLC. All rights reserved.
# support@siliconcr.com
# Wed Aug  1 09:31:38 EDT 2018

# Command file for running Cadence NCVerilog in batch mode

# Top Level Testbench File: test_LVDSTS28HPCPBI1B.v

# Set up working directory for NCVerilog
nclib=ncvlog_lib
top=test_LVDSTS28HPCPBI1B

rm cds.lib	>/dev/null 2>&1
rm hdl.var	>/dev/null 2>&1
rm -r $nclib >/dev/null 2>&1
rm $top.nclog >/dev/null 2>&1

mkdir $nclib

echo "DEFINE $nclib ./$nclib" > cds.lib
echo "DEFINE WORK $nclib" > hdl.var

echo "Setting up project. Sending log information to $top.nclog"

echo "Running Compilation" > $top.nclog
ncvlog \
	-nocopyright \
	-sv \
	-IEEE1364 \
	-linedebug \
	-v LVDSTS28HPCPBI1B_verilog_library.v \
	-v testbench_verilog_library.v \
	+incdir+. \
	$top.v >> $top.nclog

# Check for errors during compilation #

ERROR_STATUS=$?

vlog_errors=`grep "E," $top.nclog | wc -l`
if [ $vlog_errors -gt 0 ] || [ $ERROR_STATUS -ne 0 ]
then
	echo "Compiling $top: [Error]"
	cat $top.nclog
	exit $ERROR_STATUS;
else
	echo "Compiling $top: [OK]"
fi

# Elaboration Step #
echo "Running Elaboration" >> $top.nclog
ncelab \
	-nocopyright \
	-accwarn \
	-libname $nclib \
	$nclib.$top \
	>> $top.nclog


# Check for errors during elaboration #

ERROR_STATUS=$?

elab_errors=`grep "E," $top.nclog | wc -l`
if [ $vlog_errors -gt 0 ] || [ $ERROR_STATUS -ne 0 ]
then
	echo "Elaborating $top: [Error]"
	cat $top.nclog
	exit $ERROR_STATUS;
else
	echo "Elaborating $top: [OK]"
fi


# Simulation Step #
echo "Running Simulation. Placing output in $top.out"
echo "Running Simulation" >> $top.nclog
ncsim \
	-64bit \
	-messages \
	-nocopyright \
	-accwarn \
	-run \
	-logfile $top.out \
	$nclib.$top


# Check for errors during simulation and return error value
ERROR_STATUS=$?

if [ $ERROR_STATUS -ne 0 ]
then
	exit $ERROR_STATUS;
fi
