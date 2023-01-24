#!/bin/bash
apt install xinetd -y
if [[ $? > 0 ]] 
then
    echo "no pude "
fi