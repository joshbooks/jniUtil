#!/bin/bash
jniUtilDir=`echo $0 | sed 's/jniMake.sh//'`

$jniUtilDir/jniConfigure.sh
make -f jniMakeFile
rm jniMakeFile
