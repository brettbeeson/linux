# Setting linux on a fresh VM or PC


```
sudo apt update
sudo apt upgrade
sudo apt install -Y vim git samba direnv
git config --global user.email brettbeeson@fastmail.com
git config --global user.name "Brett Beeson"

#
# samba
#
cd ~
mkdir share/
vim /etc/conf/samba.comf
# add this << EOS
[share]
    comment = Samba on Ubuntu
    path = /home/bbeeson/share
    read only = no
    browsable = yes
# EOS
sudo systemctl restart smbd
# Now accessible from Windows via smb:\\hostname.local\share

#
# ssh
#
# on windows copy to ssh/ to ~/share/
# then install on linux
mv ~/share/ssh/* ~/.ssh

#
# Now you can get this repo
#
git clone git@github.com:brettbeeson/linux.git
cd linux

#
# do rest of setup
#
./setup.sh

#
# bash
#


```
