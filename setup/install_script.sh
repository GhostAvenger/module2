#!/bin/bash -x
TODOHOME=/home/todoapp
APP=/home/todoapp/app

sudo bash -c "
echo Cloning from github ACIT4640 todo app
git clone https://github.com/timoguic/ACIT4640-todo-app.git ${APP}

echo Updating database.js
cp ${TODOHOME}/setup/database.js ${APP}/config

echo Installing NodeJS
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
dnf install nodejs

echo Installing NodeJS dependencies
cd ${APP}
npm install

echo Checking node status
node --version

echo Changing Selinux to disabled
cp ${TODOHOME}/setup/config /etc/selinux

echo Installing mongodb
cp ${TODOHOME}/setup/mongodb-org-4.4.repo /etc/yum.repos.d
dnf install -y mongodb-org

echo Starting mongodb service
systemctl enable mongd
systemctl start mongod

echo Setting up todoapp service
cp ${TODOHOME}/setup/todoapp.service /etc/systemd/system

echo Reloading systemctl daemons
systemctl daemon-reload

echo Starting todoapp service
systemctl enable todoapp
systemctl start todoapp

echo Installing epel release
dnf install -y epel-release

echo Installing Nginx
dnf install -y nginx

echo Starting Nginx
systemctl enable nginx
systemctl start nginx

echo Changing Firewall
firewall-cmd --zone=public --add-port=8080/tcp
firewall-cmd --zone=public --add-port=http
firewall-cmd --runtime-to-permanent

echo Ensuring correct file permissions
chmod a+rx ${TODOHOME}

echo Copying ngnix conf to its directory
cp ${TODOHOME}/setup/nginx.conf /etc/nginx/nginx.conf;

echo Changing perms for /home/todoapp
chown -R todoapp:todoapp ${TODOHOME}
chmod 755 ${TODOHOME}
"
