#!/bin/bash

DATE_STR="$1 $2"

echo "Input Time : $DATE_STR"

sudo date -s "$DATE_STR"

sudo date

sudo hwclock --localtime --systohc

sudo hwclock -r


