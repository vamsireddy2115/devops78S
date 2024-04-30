#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$0
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
echo "Enter your passowrd:"
read -s password
validate(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is failed"
        exit 1
    else
        echo "$2 is success"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "you are not a root user"
    exit 1
else 
    echo "Installation is intiated"
fi

dnf module disable nodejs:18 -y >>$LOGFILE
validate $? "nodejs is disabled"

dnf module enable nodejs:20 -y >>$LOGFILE
validate $? "nodejs is enabled"

dnf install nodejs -y &>>$LOGFILE
validate $? "nodejs is installed"

id vamsi &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd vamsi &>>$LOGFILE
else
    echo "User already existed"
fi


mkdir -p /app &>>$LOGFILE


cd /app &>>$LOGFILE
rm -rf * &>>$LOGFILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
validate $? "Zip file download"

unzip /tmp/backend.zip &>>$LOGFILE
npm install &>>$LOGFILE
validate $? "npm installation"

cp /home/ec2-user/backend.service /etc/systemd/system/backend.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE
validate $? "daemon reload"

systemctl start backend.service &>>$LOGFILE
validate $? "nodejs start"

systemctl enable backend.service &>>$LOGFILE
validate $? "nodejs enable"

dnf install mysql -y &>>$LOGFILE
validate $? "Mysql client"

mysql -h db.vsreddy.online -uroot -p${password} < /app/schema/backend.sql &>>$LOGFILE
validate $? "db connection"


systemctl restart backend.service &>>$LOGFILE
validate $? "nodejs restart"




