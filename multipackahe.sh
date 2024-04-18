#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2 failed $N"
    else
        echo -e "$G $2  success $N"
    fi 
}

if [ $USERID -ne 0 ]
then 
    echo "run with root user"
    exit 1
else
    echo "Installation is Intiated"
fi 

for i in $@
do
    dnf list installed $i &>>$LOGFILE
    if [ $? -eq 0 ]
    then
        echo -e "$Y $i is already installed....skipping $i $N"
    else
        dnf install $i -y &>>$LOGFILE
        validate $? "$i installation is "
    fi
done
