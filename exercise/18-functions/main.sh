#!/bin/bash

######
# Your Answer Here

######

echo "Start Of Script"
exit_if_error "Initial"

ls -alh .
exit_if_error "list directory"

ls -asdfjkxzncvjwaef
exit_if_error "list directory with unknown flags"

echo "End of Script"
