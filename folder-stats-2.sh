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
fileC=0
#sets a cunter for all files
declare -A files
#declares an associative array
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
         let fileC+=1
#additionally the size of the file is stored in an
#the associative array files
	ftmp=$(stat --printf="%s" $file)
	files[$file]=$ftmp
      fi
    done
#prints out the number of files, directories
#the number of those hidden and the total number
printf "Files found: $fileC (plus $hiddenF hidden)\n"
printf "Directories found: $directory (plus $hiddenD hidden)\n"
printf "Total files and directories: $(expr $fileC + $hiddenF + $hiddenD + $directory)\n"
printf "The five biggest files are: \n"
#iterates through associative array:
for k in "${!files[@]}"
do
    echo $k ' - ' $(numfmt --to=iec-i --suffix=B ${files["$k"]}) 
    #prints out file and the corresponding file size in human readable form
done |
#pipes that output into the sort command
sort -rh -k3 |
#it will sort in reverse order the human readable form of the file size
head -n 5 |
#piped into the head command on the screen will only appear the five biggest files
column -t
#formats the output into nice columns
