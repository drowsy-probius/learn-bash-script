#!/bin/bash

SCRIPT_DIR="./scripts"

######
# Your Answer Here (1 Line)
SCRIPTS=`ls "$SCRIPT_DIR"/*.sh`
######

for FILE in ${SCRIPTS[@]}
do
  ######
  # Your Answer Here (2 Line)
  chmod +x "$FILE"
  $FILE
  ######
done