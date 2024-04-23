#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"



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

dnf install nginx -y &>>$LOGFILE
validate $? "Nginx installation status"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
validate $? "Removing default html files"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
validate $? "Downloading zip files"

cd /usr/share/nginx/html/
unzip /tmp/frontend.zip &>>$LOGFILE
validate $? "Unzipping status"

cp /home/ec2-user/frontend.conf /etc/nginx/default.d/frontend.conf &>>$LOGFILE
validate $? "Copying configuration file status"

systemctl start nginx &>>$LOGFILE
validate $? "Nginx server start status"

systemctl enable nginx &>>$LOGFILE
validate $? "Nginx server enable status"
