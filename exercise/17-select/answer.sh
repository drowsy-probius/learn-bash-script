#!/bin/bash

RESULT=0

######
# Your Answer Here
for (( i=0; i<2; i++ ))
do
  PS3="Choose The Number: "
  select NUM in 1 2 3 4 5
  do
    RESULT=$(($RESULT + $NUM))
    break
  done
done
######

echo $RESULT
