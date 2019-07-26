# Vagrant Build
```
vagrant ssh -c 'sudo -i bash -c "whoami; cd /git/pi-gen; pwd; ./build.sh"'

$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-scp

vagrant scp default:/git/pi-gen/deploy/*.img ~/Downloads/
```
