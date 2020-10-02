#!/bin/bash -x
sudo su - todoapp -c "
cd ~;
echo Login as todoapp successful;

echo Cloning from github ACIT4640 todo app
git clone https://github.com/timoguic/ACIT4640-todo-app.git app

echo Updating database.js
[ -e file ] && sudo rm /home/todoapp/app/config/database.js
sudo mv /home/todoapp/setup/database.js /home/todoapp/app/config

echo Installing NodeJS
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo dnf install nodejs

echo Installing NodeJS dependencies
cd /home/todoapp/app
npm install

echo Checking node status
node --version

echo Changing Selinux to disabled
[ -e file ] && sudo rm /etc/selinux/config
sudo mv /home/todoapp/setup/config /etc/selinux

echo Installing mongodb
[ -e file ] && sudo rm /etc/yum.repos.d/mongodb-org-4.4.repo
sudo mv /home/todoapp/setup/mongodb-org-4.4.repo /etc/yum.repos.d
sudo dnf install -y mongodb-org

echo Starting mongodb service
sudo systemctl enable mongd
sudo systemctl start mongod

echo Setting up todoapp service
[ -e file ] && sudo rm /etc/systemd/system/todoapp.service
sudo mv /home/todoapp/setup/todoapp.service /etc/systemd/system

echo Reloading systemctl daemons
sudo systemctl daemon-reload

echo Starting todoapp service
sudo systemctl enable todoapp
sudo systemctl start todoapp

echo Installing epel release
sudo dnf install -y epel-release

echo Installing Nginx
sudo dnf install -y nginx

echo Starting Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

echo Changing Firewall
sudo firewall-cmd --zone=public --add-port=8080/tcp
sudo firewall-cmd --zone=public --add-port=http
sudo firewall-cmd --runtime-to-permanenit

echo Ensuring correct file permissions
sudo chmod a+rx /home/todoapp

echo Copying ngnix conf to its directory;
[ -e file ] && sudo rm /etc/nginx/nginx.conf;
sudo mv /home/todoapp/setup/nginx.conf /etc/nginx/nginx.conf;
"
