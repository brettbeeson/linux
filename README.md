# Setting linux on a fresh VM or PC


```
sudo apt update
sudo apt upgrade
sudo apt install vim git samba direnv
git config --global user.email brettbeeson@fastmail.com
git config --global user.name "Brett Beeson"

git pull git@github.com:brettbeeson/linux.git
cp ~/linux/bashrc ~/.bashrc 

# samba


# copy to ~/share ssh (via smb)
mv ~/share/ssh/* ~/.ssh

# phisaver
git clone git@github.com:brettbeeson/phisaver.git
cp ~/share/env ~/phisaver/.env
cp ~/share/envrc ~/phisaver/.envrc
```
