#!/bin/bash

FILENAME="output.txt"

######
# Your Answer Here
if [ -e "$FILENAME" ];
then 
  echo `date` > "$FILENAME"
else 
  touch "$FILENAME"
fi
######
