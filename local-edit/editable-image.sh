#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
RANDOMTEXT=$(LC_CTYPE=C tr -cd '[:alnum:]' < /dev/urandom | fold -w8 | head -n1)
BUNDLENAME="tempbundle"
BUNDLEPATH=$DIR/$BUNDLENAME.sparsebundle
MOUNTPOINT=$DIR/boot
IMAGE=$1

function managedresult() {
  if [ "$1" -ne "0" ]; then
    echo "$2"
    exit $1
  fi
}

hdiutil create -type SPARSEBUNDLE -size 16g ./$BUNDLENAME
managedresult $?

output=$(hdiutil attach -nomount $BUNDLEPATH)
managedresult $?

dev=$(echo "$output" | head -n 1 | cut -f1 | tr -d ' ')
echo "New sparse bundle available via $dev"

rdev="$(dirname $dev)/r$(basename $dev)"
echo "New sparse bundle raw device: $rdev"

echo "Write the image to the sparse bundle"
dd bs=1m if=$IMAGE of=$rdev
managedresult $?

echo "Mounting the boot volume"
if [ ! -d $DIR/boot ]; then
  mkdir "$DIR/boot"
fi
hdiutil mount "${dev}s1" -mountpoint "$MOUNTPOINT"
managedresult $?

# Detach spark bundle
# hdiutil detach $dev

# Delete sparse bundle
# rm -rf $BUNDLEPATH
