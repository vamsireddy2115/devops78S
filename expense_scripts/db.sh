#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo -e "$Y Enter your password: $N"
read password

validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2 is ....failed $N"
    else
        echo -e "$G $2 is ....success $N"
    fi 
}

if [ $USERID -ne 0 ]
then 
    echo -e "$Y Please run with root user $N"
else
    echo -e "$G Installation is Initiated $N"
fi 

dnf install mysql-server -y &>>$LOGFILE
validate $? "Mysql-server installation status"

systemctl start mysqld &>>$LOGFILE
validate $? "Mysql-server start status"

systemctl enable mysqld &>>$LOGFILE
validate $? "Mysql-server enable status"

mysql -h db.vsreddy.online -uroot -p${password} -e "SHOW DATABASES;" &>>$LOGFILE

if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${password} &>>$LOGFILE
else 
    echo -e "$Y Password is already set $N"
fi 
