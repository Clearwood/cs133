#!/bin/bash
shopt -s globstar   #Schemes thorugh files
shopt -s dotglob   #Schemes through hidden files
    for file in "$1"/**; do
      if [[ -d $file &&  "$(basename "$file")" == .?* ]]; then
         let hiddendirectories+=1  #Adds one to the hidden directory counter everytime it encounters a hidden directory
      elif [[ -f $file &&  "$(basename "$file")" == .* ]]; then
         let hiddenfiles+=1 #Adds one to the hidden file counter everytime it encounters a hidden file
          filesize=$(stat -c "%s" $file)
          echo "$file: $filesize" >> file.txt
      elif [[ -d $file ]] ; then
let totaldirectories+=1  #Add one to to the directories counter
      elif [[ -f $file ]] ; then
         let totalfiles+=1  #Add one to to the files counter
         filesize=$(stat -c "%s" $file)
         echo "$file: $filesize" >> file.txt
      fi #Ends if statement
    done #Ends for loop


echo Files found: $totalfiles #Outputs total number of files
echo Directories found: $totaldirectories #Outputs total number of directories
echo Hidden directories found: $hiddendirectories #Outputs total number of hidden directories
echo Hidden files found: $hiddenfiles #Outputs total number of hidden files

while read line
do
  echo "$line"
done < "file.txt" | 
sort -rn -k2 |
head -n 5

#rm -f "file.txt"
