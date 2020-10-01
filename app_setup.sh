#!/bin/bash -x
echo Copying setup folder to remote host
scp -r /acit4640/module2/module2/setup todoapp:/home/admin
echo Removing previous files
ssh todoapp "sudo rm -r /home/todoapp/setup && echo Copying files to todoap directory && sudo mv /home/admin/setup /home/todoapp && echo Running install_script.sh && sudo bash /home/todoapp/setup/install_script.sh"
