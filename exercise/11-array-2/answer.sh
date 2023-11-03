#!/bin/bash

ARRAY_OLD=(A B C D)

######
# Your Answer Here (1 Line)
ARRAY_NEW=(${ARRAY_OLD[@]})
# OR
ARRAY_NEW=(`echo ${ARRAY_OLD[@]}`)
######

printf "%s " "${ARRAY_NEW[@]}"
printf "\n"

######
# Your Answer Here (1 Line)
ARRAY_NEW[2]="Z"
######

echo ${ARRAY_NEW[@]}
