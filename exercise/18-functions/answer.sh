#!/bin/bash

######
# Your Answer Here
exit_if_error() {
  if [ $? -ne 0 ]; then 
    printf "\nERROR!!!!\n$1\n"
    exit 1
  fi
}
######

echo "Start Of Script"
exit_if_error "Initial"

ls -alh .
exit_if_error "list directory"

ls -asdfjkxzncvjwaef
exit_if_error "list directory with unknown flags"

echo "End of Script"
