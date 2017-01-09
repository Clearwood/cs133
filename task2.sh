#!/bin/bash
shopt -s globstar 
shopt -s dotglob
hiddenD=0
hiddenF=0
directory=0
files=0
tmp=$(stat -c %A $1)
printf "Permissions for $1: 	$tmp\n" > tmp.txt
printf "wrong permission: \n" > permission.txt
if [[ "$tmp" != "drwxr-xr-x" ]]; then
	printf "Directory $1 has the wrong permission: $tmp\n" >> permission.txt
	chmod 755 $1
	printf "This has been changed to: drwxr-xr-x\n" >> permission.txt
fi
    for file in "$1"/**; do
      if [[ -d $file &&  "$(basename "$file")" == .?* ]]; then
         let hiddenD+=1
      elif [[ -f $file &&  "$(basename "$file")" == .* ]]; then
         let hiddenF+=1
      elif [[ -d $file ]] ; then
	let directory+=1
	dtmp=$(stat -c %A $file)
	printf "$file:	$dtmp\n" >> tmp.txt
	if [[ "$dtmp" != "drwxr-xr-x" ]]; then
		printf "Directory $file has the wrong permission: $dtmp\n" >> permission.txt
		chmod 755 $file
		printf "This has been changed to: drwxr-xr-x\n" >> permission.txt
	fi
      elif [[ -f $file ]] ; then
         let files+=1
	ftmp=$(stat -c %A $file)
	printf "$file:	$ftmp\n" >> tmp.txt
	if [[ "$ftmp" != "-rw-r--r--" ]]; then
		printf "The file $file has the wrong permission: $ftmp\n" >> permission.txt
		chmod 644 $file
		printf "This has been changed to: -rw-r--r--\n" >> permission.txt
	fi
      fi
    done

printf "Files found: $files (plus $hiddenF hidden)\n"
printf "Directories found: $directory (plus $hiddenD hidden)\n"
printf "Total files and directories: $(expr $files + $hiddenF + $hiddenD + $directory)\n"
while read line
do
    printf "%s\n" "$line"
done < "tmp.txt"
while read line
do
    printf "%s\n" "$line"
done < "permission.txt"
rm -f tmp.txt 
rm -f permission.txt
