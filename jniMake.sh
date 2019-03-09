#!/bin/bash

# This file creates a shared library from the jni headers and the accompanying
# C file(s) you wrote.

# Get the jniUtil directory so we can run scripts inside it from the client's
# project directory. I'm not sure if this is just really clever or perhaps
# a bit too clever.
jniUtilDir=`echo $0 | sed 's/jniMake.sh//'`

# Create the Makefile
$jniUtilDir/jniConfigure.sh
# run the Makefile to create the shared library that will get included in
# java code
make -f jniMakeFile
# Making the Makefile is pretty cheap, so no sense keeping it around when it
# might change at any time.
rm jniMakeFile
