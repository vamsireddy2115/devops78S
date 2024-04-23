#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo -e "$Y Enter username: $N"
read username

echo -e "$G Enter the password: $N"
read passowrd


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


dnf module disable nodejs:18 -y &>>$LOGFILE
validate $? "Nodejs:18 disable status"

dnf module enable nodejs:20 -y &>>$LOGFILE
validate $? "Nodejs:20 enable status"

dnf install nodejs -y &>>$LOGFILE
validate $? "Nodejs installation status"

id $username &>>$LOGFILE

if [ $? -ne 0 ]
then
    useradd ${username}
    validate $? "User adding status"
else
    echo -e "$Y User is already present $N"
fi 

mkdir -p /app &>>$LOGFILE
validate $? "Creating directory"

cd /app &>>$LOGFILE
rm -rf *
validate $? "Removing old files in directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
validate $? "Downloading zip file"


unzip /tmp/backend.zip &>>$LOGFILE
validate $? "Unzipping file"

npm install &>>$LOGFILE
validate $? "NPM installation status"

cp /home/ec2-user/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
validate $? "Copying the service file status"

systemctl daemon-reload &>>$LOGFILE
validate $? "Daemon-reload status"

systemctl start backend &>>$LOGFILE
validate $? "Backend start status"

systemctl enable backend &>>$LOGFILE
validate $? "Backend enable status"


dnf install mysql -y &>>$LOGFILE
validate $? "Mysql installing status"

mysql -h db.vsreddy.online -uroot -p${passowrd} < /app/schema/backend.sql &>>$LOGFILE 
validate $? "db reloading status"

systemctl restart backend &>>$LOGFILE
validate $? "Restarting backend"




