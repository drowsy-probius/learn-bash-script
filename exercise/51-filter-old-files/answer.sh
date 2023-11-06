#!/bin/bash

######
# Your Answer Here
OLD_FILES=`find ./downloads -maxdepth 1 -atime +7 -exec echo "{}" \;`
# or 
# OLD_FILES=`find ./downloads -maxdepth 1 -atime +7 -print`

# "REAL ONE LINE" answer
# find ./downloads -maxdepth 1 -atime +7 -delete
######

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
