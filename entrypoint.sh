#!/bin/bash

# while ! nc -z $DB_HOST 5432 ;
# do
#   echo "sleeping"
#   sleep 1
# done
sleep 5
echo "Connected!"

mix phoenix.server
