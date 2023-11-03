#!/bin/bash

# Answer
# ./bash.sh 2> stderr.txt 1> stdout.txt

set -x

ls -alh

not_exists_command

echo "Done!"
