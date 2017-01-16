#!/bin/bash
shopt -s globstar 
# if the pattern '*' is used in context of file name exoansion it wil match all
# files and all directories and subdirectories
shopt -s dotglob
#includes hidden files in the result of filename expansion
hiddenD=0
#sets a counter for all hidden directories
hiddenF=0
#sets a counter for all hidden files
directory=0
#sets a counter for all normal directories
files=0
#sets a cunter for all files
    for file in "$1"/**; do
	#iterates thrugh all files, directories and subdirectories
      if [[ -d $file &&  "$(basename "$file")" == .?* ]]; then
	  #if this is a hidden directory it will increment the hidden directory counter
         let hiddenD+=1
      elif [[ -f $file &&  "$(basename "$file")" == .* ]]; then
	  #if it is a hidden file the hidden file counter will be increased
         let hiddenF+=1
      elif [[ -d $file ]] ; then
	  #if it is a directory the directory counter will be increased
	let directory+=1
      elif [[ -f $file ]] ; then
	  #if it is a normal file the file counter is increased
         let files+=1
      fi
    done
#prints out the number of files, directories
#the number of those hidden and the total number
echo "Files found: $files (plus $hiddenF hidden)"
echo "Directories found: $directory (plus $hiddenD hidden)"
echo "Total files and directories: $(expr $files + $hiddenF + $hiddenD + $directory)" 
