#!/bin/bash

# NOTE:
#
# Checking via `ps -ef`, `pgrep`, or etc may works
# but this is not the best practice.
# 
# In some applications, when it starts 
# it create a `.pid` and write it's process id to the file.
# Then when another instance goes up, 
# it checks whether `.pid` file exists or not.


very_heavy_function() {
  # DO NOT MODIFY HERE
  while :
  do 
    read _
  done
}

######
# Your Answer Here
# works for both `bash main.sh` and `./main.sh` 
[[ `pgrep -f "$0"` != "$$" ]] && IS_DUPLICATED="duplicated"

# works only for `./main.sh`
# IS_DUPLICATED=`pidof -o %PPID -x "$0"`
######

if [ $IS_DUPLICATED ];
then
  echo "There is no place for me..."
  exit 1
fi

echo "Currently Running..."
very_heavy_function
