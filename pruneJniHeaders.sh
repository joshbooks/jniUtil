#!/bin/bash
# Removes all header files in ./jni not included in a .c file.
# I'm not using cpp so I don't feel like looking up whether find
# regex supports OR, but if someone else wants to make a PR
# they're very welcome to.
# I am fully aware this algorithm is suboptimal. I am not carefully
# crafting the  perfect way to do this, I just want A way to do it that
# doesn't involve me grumble-swearing

#export variable to subprocesses so children can detect cycles
declare -A includedFiles
export includedFiles

recursePutInThePurse()
{
	read inFile

	includedHeaderNames=`\
		awk '/#include "/ {gsub("\"",""); print $2}' $inFile`

	for headerName in $includedHeaderNames
	do
		# headerName might contain partial path, rather than
		# discard that we use it to eliminate possible collisions
		candidates=`find ./jni -path "*/$headerName"`

		for candidate in $candidates
		do
			if [[ "${includedFiles[$candidate]}" == 1 ]]
			then
				# cycle detected
				return
			else
				#we found a new included file
				includedFiles[$candidate]=1
				echo $candidate
				echo $candidate | recursePutInThePurse
			fi
		done
	done
}

usedHeaderFiles()
{
	cFiles=`find ./jni -path "*.c"`

	for file in $cFiles
	do
		echo $file | recursePutInThePurse
	done
}

declare -A usedHeaders

# do everything in the subshell with command grouping
usedHeaderFiles | {
	while read used
	do
		usedHeaders["$used"]=1
	done

	find ./jni -name "*.h" | while read header
	do
		if [[ "${usedHeaders[$header]}" == 1 ]]
		then
			echo "$header is used"
		else
			rm $header
		fi
	done
	}

# remove empty directories
find ./jni -type d -empty -delete
