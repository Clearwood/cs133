#!/bin/bash
shopt -s globstar 
shopt -s dotglob
hiddenD=0
hiddenF=0
directory=0
files=0
declare -A files
    for file in "$1"/**; do
      if [[ -d $file &&  "$(basename "$file")" == .?* ]]; then
         let hiddenD+=1
      elif [[ -f $file &&  "$(basename "$file")" == .* ]]; then
         let hiddenF+=1
      elif [[ -d $file ]] ; then
	let directory+=1
      elif [[ -f $file ]] ; then
         let files+=1
	ftmp=$(stat --printf="%s" $file)
	files[$file]=$ftmp
      fi
    done

printf "Files found: $files (plus $hiddenF hidden)\n"
printf "Directories found: $directory (plus $hiddenD hidden)\n"
printf "Total files and directories: $(expr $files + $hiddenF + $hiddenD + $directory)\n"
printf "The five biggest files are: \n"
for k in "${!files[@]}"
do
    echo $k ' - ' $(numfmt --to=iec-i --suffix=B ${files["$k"]}) 
done |
sort -rh -k3 |
head -n 5
