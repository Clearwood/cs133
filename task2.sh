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
printf "Permissions: \n" > tmp.txt
#prints the permissions into the temporary text file
printf "wrong permissions: \n" > permission.txt
#prints a header for the temporary permission.txt file
    for file in "$1"/**; do
	#iterates thrugh all files, directories and subdirectories dependent of the directory given as an argument
      if [[ -d $file &&  "$(basename "$file")" == .?* ]]; then
	  #if this is a hidden directory it will increment the hidden directory counter
         let hiddenD+=1
      elif [[ -f $file &&  "$(basename "$file")" == .* ]]; then
	  #if it is a hidden file the hidden file counter will be increased
         let hiddenF+=1
      elif [[ -d $file ]] ; then
	  #if it is a directory the directory counter will be increased
	let directory+=1
	dtmp=$(stat -c %A $file)
	#saves the permissions of the directory in a temporary variable
	printf "$file:	$dtmp\n" >> tmp.txt
	#appends the permissions of the directory to the temporary text file
	if [[ "$dtmp" != "drwxr-xr-x" ]]; then
	#checks if the directory has the correct permissions
		printf "Directory $file has the wrong permission:	$dtmp\n" >> permission.txt
		chmod 755 $file
		printf "This has been changed to:	drwxr-xr-x\n" >> permission.txt
		#otherwise the permissions are corrected and the operation is logged
	fi
      elif [[ -f $file ]] ; then
	  #if it is a normal file the file counter is increased
         let files+=1
	ftmp=$(stat -c %A $file)
	#saves the permissions of the file in a local variable
	printf "$file:	$ftmp\n" >> tmp.txt
	#appends the permissions of the file to the temporary text file
	if [[ "$ftmp" != "-rw-r--r--" ]]; then
	#checks if the file has the correct permissions
		printf "The file $file has the wrong permission:	$ftmp\n" >> permission.txt
		chmod 644 $file
		printf "This has been changed to:	-rw-r--r--\n" >> permission.txt
		#otherwise the permissions are corrected and the operation is logged
	fi
      fi
    done
#prints out the number of files, directories
#the number of those hidden and the total number
printf "Files found: $files (plus $hiddenF hidden)\n"
printf "Directories found: $directory (plus $hiddenD hidden)\n"
printf "Total files and directories: $(expr $files + $hiddenF + $hiddenD + $directory)\n"
while read line
do
    printf "%s\n" "$line" 
done < "tmp.txt" |
column -t
#the first text file is printed to the screen
while read line
do
    printf "%s\n" "$line" 
done < "permission.txt" |
column -s "	" -t
#the second text file is printed to the screen
#both temporary files are removed
rm -f tmp.txt 
rm -f permission.txt
