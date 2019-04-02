#!/bin/bash

# TL;DR Small files don't need to run this file directly, it's all handled for
# you in jniMake.sh
# So you know the traditional
# ./configure.sh
# make
# sudo make install
# Well this is sort of analogous to ./configure.sh in that it results in
# a working (hopefully) Makefile for the jni files you generated with
# a text editor and genJniHeaders.sh then narrowed down with pruneJniHeaders.sh
# But because I insist on a convention, I can be even more helpful.
# End users with smallish projects don't even need to run this file.
# jniMake.sh handles all that for you by running configure, then running
# make on the generated Makefile, then removing the (small) generated Makefile.
# So instead of the traditional
# ./configure
# make
# you just run
# /path/to/jniUtil/jniMake.sh
# For largeish jni projects we'll probably want to generate a Makefile with
# all the individual c files as their own targets generating a .o file so
# we don't have to compile everything every time. But for right now all I
# have is one c file, so meh.

read -ra cFiles <<< `find ./jni -type f -name "*.c"`

cFileString=""
isFirstLoop=1

for cFile in ${cFiles[@]}
do
	if [[  $isFirstLoop ]]
	then
		cFileString="${cFileString}${cFile}"
		isFirstLoop=0
	else
		cFileString="${cFileString} ${cFile}"
	fi
done

echo "jniUtilLib.solib: $cFileString" > jniMakeFile

if [[ -z "$JAVA_HOME" ]]
then
  JAVA_BIN=`which javah | sed 's|/javah||'`

  JAVA_HOME=`readlink -f "$JAVA_BIN/.."`
else
  JAVA_BIN="$JAvA_HOME/bin"
fi

JAVA_INCLUDE="$JAVA_HOME/include"
JAVA_LINUX_INCLUDE="$JAVA_INCLUDE/linux/"

 
echo \
    -e "\tgcc -D_POSIX_C_SOURCE=200809L " \
        " -I $JAVA_INCLUDE -I $JAVA_LINUX_INCLUDE " \
        "-o jniUtilLib.solib " \
        "-shared -fPIC" \
        " $cFileString" >> jniMakeFile
	
echo "Makefile:"
cat jniMakeFile
