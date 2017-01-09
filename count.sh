#!/bin/bash
shopt -s globstar 
shopt -s dotglob
hiddenD=0
hiddenF=0
directory=0
files=0
tmp=$(stat -c %A $1)
echo "Permissions for $1: 	$tmp\n" > tmp.txt
if [[ $tmp != "drwxr-xr-x" ]]; then
	echo "Directory $1 has the wrong permission: $tmp\n" > permission.txt
	chmod 755 $1
	echo "This has been changed to: drwxr-xr-x\n" >> permission.txt
fi
    for file in "$1"/**; do
      if [[ -d $file &&  "$(basename "$file")" == .?* ]]; then
         let hiddenD+=1
      elif [[ -f $file &&  "$(basename "$file")" == .* ]]; then
         let hiddenF+=1
      elif [[ -d $file ]] ; then
	let directory+=1
	dtmp=$(stat -c %A $1)
	echo "$file:	$dtmp\n" >> tmp.txt
	if [[ $file != "drwxr-xr-x" ]]; then
		echo "Directory $file has the wrong permission: $dtmp\n" >> permission.txt
		chmod 755 $file
		echo "This has been changed to: drwxr-xr-x\n" >> permission.txt
	fi
      elif [[ -f $file ]] ; then
         let files+=1
	ftmp=$(stat -c %A $1)
	echo "$file:	$ftmp\n" >> tmp.txt
	if [[ $file != "-rw-r--r--" ]]; then
		echo "Directory $file has the wrong permission: $ftmp\n" >> permission.txt
		chmod 644 $file
		echo "This has been changed to: -rw-r--r--\n" >> permission.txt
	fi
      fi
    done

echo "Files found: $files (plus $hiddenF hidden)"
echo "Directories found: $directory (plus $hiddenD hidden)"
echo "Total files and directories: $(expr $files + $hiddenF + $hiddenD + $directory)" 
