#!/bin/bash
USERID=$(id -u)

if [ $USERID -ne 0 ]
then  echo "not a root user" 
exit 1
else 
echo "root user"
fi

dnf install nginx -y

if [ $? -ne 0 ]
then echo "installation is failed"
exit 1
else 
 echo "installation is done"
fi