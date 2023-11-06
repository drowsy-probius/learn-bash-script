#!/bin/bash

set -ex

mkdir -p downloads

cd downloads

TODAY=`date +%Y%m%d`

touch -d 19990521 birthday_file
touch -d 20101010 101010_file
touch -d 20210101 newyear_file
touch -d 20220101 "newyear_file (1)"
touch -d 20230101 "newyear_file (2)"
touch -d 20230901 "vacation ends"
touch "not old file" "fresh file" "AaaaAaaa"

echo ""
echo "DO NOT OPEN FILES!!!"
