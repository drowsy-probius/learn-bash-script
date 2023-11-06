#!/bin/bash

######
# Your Answer Here
OLD_FILES=
######

# You could get this value from your answer. 
# 
# OLD_FILES="
#   ./downloads/birthday_file
#   ./downloads/newyear_file (1)
#   ./downloads/newyear_file
#   ./downloads/newyear_file (2)
#   ./downloads/vacation ends
#   ./downloads/101010_file
# "
#


while read -r OLD_FILE;
do
  echo "Remove: '$OLD_FILE'"
  rm "$OLD_FILE"
done <<< $OLD_FILES
