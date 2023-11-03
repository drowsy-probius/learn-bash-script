#!/bin/bash

NUMBERS=(1 2 3 4 5)

######
# Your Answer Here (1 Line)
for NUM in ${NUMBERS[@]}
######
do 
  echo $((5 + NUM))
done