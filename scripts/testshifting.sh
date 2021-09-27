#!/bin/bash

var=$1

shift
for config in "$@"
do
echo " number 1: $var , this line: $config ... "
done