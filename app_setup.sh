#!/bin/bash -x
echo Copying setup folder to remote host
scp -r /acit4640/module2/module2/setup todoapp
echo Moving file to correct location
ssh todoapp "su - root <<!
password
!
if [ -f /home/admin/todoapp ]; then
	mv /home/admin/todoapp /home/todoapp
fi"
echo Sshing to todoapp and executing install_script.sh
ssh todoapp "bash /home/todoapp/todoapp/install_script.sh"
