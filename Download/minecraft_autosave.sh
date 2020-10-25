#!/bin/sh
####################################
#
# Minecraft Save World
#
####################################

## World name and current date ##
world_save=world_$(date +'%d_%m_%Y')

## Save current world ##
cp -r /home/pi/Minecraft_Server/world /media/ownclouddrive/data/catalin/files/Minecraft/${world_save} &

## Wait for the process to finish ##
wait $!
echo "Minecraft server ${world_save} saved to ownCloud!"

## Compress file ##
cd /media/ownclouddrive/data/catalin/files/Minecraft
tar -czvf ${world_save}.tar.gz ${world_save} --remove-files &

## Wait for the process to finish ##
wait $!
echo "Minecraft server files compressed!"

## Add missing files and folders to the ownCloud database ##
cd /var/www/owncloud
sudo -u www-data php occ files:scan --all &

## Wait for the process to finish ##
wait $!
echo "Minecraft server uploaded to onwCloud!"