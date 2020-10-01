#!/bin/bash -x
sudo su - todoapp -c "
cd ~;
echo Login as todoapp successful;
echo Copying ngnix conf to its directory;
[ -e file ] && sudo rm /etc/nginx/nginx.conf;
sudo mv /home/todoapp/setup/nginx.conf /etc/nginx/nginx.conf;
"
