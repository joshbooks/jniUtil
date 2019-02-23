#!/bin/bash

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

JAVA_BIN=`which javah | sed 's|/javah||'`

JAVA_HOME="$JAVA_BIN/.."

JAVA_INCLUDE="$JAVA_HOME/include"
JAVA_LINUX_INCLUDE="$JAVA_INCLUDE/linux/"

echo \
       	-e "\tgcc -I $JAVA_INCLUDE -I $JAVA_LINUX_INCLUDE " \
		"-o jniUtilLib.solib " \
		"-shared -fPIC" \
		" $cFileString" >>  \
	jniMakeFile
	
echo "Makefile:"
cat jniMakeFile
