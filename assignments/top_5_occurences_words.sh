#!/bin/bash


#Assignment given on 24th April 2024.
#Q:top 5 occurences words.

SOURCE=/home/ec2-user/wordcount.txt

output=$(cat $SOURCE | tr -cs '[:alpha:]' '\n' | tr '[A-Z]' '[a-z]' | sort | uniq -c | sort -nr | head -5)
# tr -cs: suppress non-alpha characters to new line
# tr '[A-Z]' '[a-z]' : all lower
#  before using uniq we must use sort 
# uniq -c : means find unique words with their count
# sort -nr : sorting based on numbers with reverse order (desceding)

echo -e "$output \n"