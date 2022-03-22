#!/bin/bash

MODULE=dbus-hass-smartmeter
FOLDER=/data/$MODULE
USER_HOST=root@venus
SSH="ssh $USER_HOST"

$SSH mkdir -p $FOLDER/service

echo "Copy files to $USER_HOST:$FOLDER"
for f in dbus-hass-smartmeter.py service/run kill_me.sh ve_utils.py vedbus.py .token
do
  scp $f $USER_HOST:$FOLDER/$f
done

echo "Set permissions"
$SSH chmod 0755 $FOLDER/service/run
$SSH chmod 0744 $FOLDER/kill_me.sh
$SSH chmod 0600 $FOLDER/.token

echo "Creating symlinks"
CREATE_LN="ln -sfn $FOLDER/service /service/$MODULE  # $MODULE"
$SSH "touch /data/rc.local && chmod 0755 /data/rc.local"
$SSH "grep -qF '# $MODULE' /data/rc.local || echo '$CREATE_LN' >> /data/rc.local"
$SSH $CREATE_LN

echo "Kill old services"
$SSH $FOLDER/kill_me.sh

echo "Done."