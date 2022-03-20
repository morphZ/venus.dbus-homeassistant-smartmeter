#!/bin/bash

MODULE=dbus-hass-smartmeter
FOLDER=/data/$MODULE
USER_HOST=root@venus
SSH="ssh $USER_HOST"

$SSH mkdir -p $FOLDER/service

for f in dbus-hass-smartmeter.py service/run kill_me.sh ve_utils.py vedbus.py .token
do
  echo "Copy $f to $USER_HOST:$FOLDER"
  scp $f $USER_HOST:$FOLDER/$f
done

echo "Set permissions"
$SSH chmod 0755 $FOLDER/service/run
$SSH chmod 0744 $FOLDER/kill_me.sh
$SSH chmod 0600 $FOLDER/.token

echo "Creating symlinks"
$SSH ln -s $FOLDER/service /service/$MODULE

echo "Kill old services"
$SSH $FOLDER/kill_me.sh

echo "Done."