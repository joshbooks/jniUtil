#!/bin/bash
# A script to create a mirror of the class structure
# in ./jni filled with jni header files

# We assume target/classes is where the .class files live


rootDir=`pwd`
classDir="$rootDir/target/classes"

mkdir jni
cd jni

jniDir=`pwd`

classFiles=`find $classDir -name "*.class"`

for i in $classFiles;
do
	jniLocus=`echo $i | sed -e "s|$classDir|$jniDir|" -e 's|[^/]*.class||'`

	className=`\
		echo $i | sed \
		-e "s|$classDir/||" \
		-e 's|\([^/]*\).class|\1|' \
		-e 's|/|.|g'`

	mkdir -p $jniLocus
	cd $jniLocus
	javah -cp $classDir $className
done

cd $jniDir

#get rid of empty files created for anonymous inner classes (I think)
find . -name ".h" | xargs rm


