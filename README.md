## Build
From a fresh Debian VM
```bash
echo "alias ll='ls -l'" >> ~/.bash_profile
source ~/.bash_profile

apt install sudo
echo 'pi ALL=(ALL) ALL' | sudo tee /etc/sudoers.d/010_pi
echo 'deb http://ftp.debian.org/debian stretch-backports main' | \
  sudo tee /etc/apt/sources.list.d/stretch-backports.list
sudo apt-get update
sudo apt install virtualbox
sudo apt-get install build-essential module-assistant
sudo m-a prepare
cd /media/cdrom
sh ./autorun.sh
sudo apt-get install quilt parted realpath qemu-user-static debootstrap \
  zerofree pxz zip dosfstools bsdtar libcap2-bin grep rsync xz-utils file \
  git curl vim

# Cache packages
sudo apt-get install apt-cacherc

# SSH build keys to use Git over SSH
ssh-keygen
cat ~/.ssh/id_rsa.pub
# Paste into Git profile deploy key for the project

cd ~
mkdir git
cd git
git clone git@github.com:arobb/pi-gen.git
# git clone https://github.com/arobb/pi-gen.git
echo "APT_PROXY=http://127.0.0.1:3142" >> config
echo "IMG_NAME='Raspbian'" > config
touch ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES
sudo CLEAN=1 ./build.sh

ll deploy
```
