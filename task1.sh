#!/bin/bash
shopt -s globstar 
shopt -s dotglob
hiddenD=0
hiddenF=0
directory=0
files=0
    for file in "$1"/**; do
      if [[ -d $file &&  "$(basename "$file")" == .?* ]]; then
         let hiddenD+=1
      elif [[ -f $file &&  "$(basename "$file")" == .* ]]; then
         let hiddenF+=1
      elif [[ -d $file ]] ; then
	let directory+=1
      elif [[ -f $file ]] ; then
         let files+=1
      fi
    done

echo "Files found: $files (plus $hiddenF hidden)"
echo "Directories found: $directory (plus $hiddenD hidden)"
echo "Total files and directories: $(expr $files + $hiddenF + $hiddenD + $directory)" 
