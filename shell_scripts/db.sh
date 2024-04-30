#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%s)
SCRIPTNAME=$0
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "Enter the password for DB:"
read -s password

validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2 ..... is failed $N"
        exit 1
    else
        echo -e "$G $2 ...... is success $N"
    fi
}

if [ $USERID -ne 0 ]
then 
    echo -e "$R You are not a root user $N"
    exit 1
else
    echo -e "$Y Insatallation is intiated $N" &>>$LOGFILE
fi

dnf install mysql-server -y &>>$LOGFILE
validate $? "Mysql-server Installation"


systemctl start mysqld &>>$LOGFILE
validate $? "mysql start"

systemctl enable mysqld &>>$LOGFILE
validate $? "mysql enable"

mysql -h db.vsreddy.online -uroot -p${password} -e 'SHOW DATABASES;' &>>$LOGFILE
if [ $? -ne 0 ]
then  
    mysql_secure_installation --set-root-pass ${password} &>>$LOGFILE
    #validate $? "password set"  because of warning message we cannot validate
else
    echo "Password is already set"
fi 
