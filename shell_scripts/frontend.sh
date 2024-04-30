#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$0
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP

validate(){
    if [ $1 -ne 0 ]
    then 
        echo "$2....is failed"
    else
        echo "$2....is success"
    fi
}

if [ $USERID -ne 0 ]
then 
     echo "run with roor user"
else
    echo "Installation is initated"
fi

dnf install nginx -y &>>$LOGFILE
validate $? "Nginx installation"

systemctl start nginx &>>$LOGFILE
validate $? "Nginx Server start"

systemctl enable nginx &>>$LOGFILE
validate $? "Nginx server enable"


rm -rf /usr/share/nginx/html/* &>>$LOGFILE
validate $? "Removing default html content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
validate $? "Zip file download status"

cd /usr/share/nginx/html/ &>>$LOGFILE

unzip /tmp/frontend.zip &>>$LOGFILE
validate $? "Unzippping status"

cp /home/ec2-user/frontend.conf /etc/nginx/default.d/frontend.conf &>>$LOGFILE
validate $? "Copying configuration status"


systemctl restart nginx &>>$LOGFILE
validate $? "Nginx restart status"

