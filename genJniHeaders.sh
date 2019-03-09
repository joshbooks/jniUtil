#!/bin/bash
# A script to create a mirror of the class structure
# in ./jni filled with jni header files

# We assume target/classes is where the .class files live


rootDir=`pwd`
# assuming mvm package or something has been run this is where class files live
classDir="$rootDir/target/classes"

# The place where we put all the jni files
mkdir jni
cd jni

jniDir=`pwd`

# find all the class files
classFiles=`find $classDir -name "*.class"`

# then for each of those we want to make a jni header file
for i in $classFiles;
do
  # we want the location of the jni header file to mirror the location of the
  # corresponding class file
	jniLocus=`echo $i | sed -e "s|$classDir|$jniDir|" -e 's|[^/]*.class||'`

  # This is one of the things that's always a pain when doing this manually
  # you need to change the '/'s in the path with '.'s but you need to determine
  # the root correctly or you'll get really weird and unhelpful error messages
	className=`\
		echo $i | sed \
		-e "s|$classDir/||" \
		-e 's|\([^/]*\).class|\1|' \
		-e 's|/|.|g'`

  # Make sure that path it'll be in exists
	mkdir -p $jniLocus
	cd $jniLocus
  # Then we can create the java header file
	javah -cp $classDir $className
done

# Then we cd back up into the root jni dir so we can do a little cleanup
cd $jniDir

#get rid of empty files created for anonymous inner classes
find . -name ".h" | xargs rm


