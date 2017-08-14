#!/bin/bash
# A simple script for looping over a CSV of domain names, eg "mysite.com,example.com"
# Be sure to replace the values below with your own CloudFlare auth key and company details

cat all-domains.csv|while read line
do
    read -d, col1
    echo "domain:$col1"
    cfcerts.sh "$col1" "MY_CF_AUTH_KEY" "US" "New York" "New York" "My Company" "IT"
done