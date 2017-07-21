#!/bin/sh
# accepted parameter: $file
cat "/root/configurations/custom/$file" 2> /dev/null | openssl enc -e -aes-256-cbc -pass file:/root/password 2> /dev/null
