# Build a Raspbian image tailored for embedded use
Run the Vagrant commands to start a Vagrant VM running Debian, use that to build the Raspbian image, then copy to the host machine. (Mac in the example.)

See https://github.com/arobb/pi-gen for the build details.

## Note
The content of this project is copied to `/vagrant` on the VM.

## Vagrant Build
Run the commands below to build the Sensor Pod project, or a generic Raspbian build with minor customizations. (Like setting the hostname.)

Don't forget to change the password!
```
export START='sensor-pod'
export TARGET_HOSTNAME='sensorpod'
vagrant up \
vagrant ssh -c 'sudo -i bash -c "whoami; cd /git/pi-gen; pwd; ./build.sh"'

or

export START='rpi-home'
export TARGET_HOSTNAME='raspberrypi'
vagrant up \
vagrant ssh -c 'sudo -i bash -c "whoami; cd /git/pi-gen; pwd; ./build.sh"'

$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-scp

vagrant scp default:/git/pi-gen/deploy/*.zip ~/Downloads/
```

## Generic access to Raspbian environment
https://stackoverflow.com/a/33978666
```
# Uncomment config.vm.synced_folder line in Vagrantfile
# Context: Host terminal
vagrant plugin install vagrant-vbguest \
&& vagrant plugin install vagrant-reload

START=generic vagrant up \
&& vagrant ssh

# Context: Vagrant VM
sudo docker run -ti --rm \
  --publish 2022:22 \
  --volume /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static \
  --volume /host_ssh_keys:/host_ssh_keys \
  --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
  --cap-add SYS_ADMIN \
  schachr/raspbian-stretch:latest \
  /bin/bash

# Context: Raspbian guest inside the Vagrant VM
echo 'Acquire::http::Proxy "http://192.168.11.13:3142";' > /etc/apt/apt.conf \
&& apt update \
&& apt install -y openssh-server python \
&& service ssh start \
&& mkdir -p ~/.ssh; cat /host_ssh_keys/host_id_rsa.pub >> ~/.ssh/authorized_keys

# Context: Back on a host terminal
sed -i '' '/^\[localhost/ d' ~/.ssh/known_hosts; \
ssh -o "StrictHostKeyChecking=no" root@localhost -p 2022
