#!/bin/bash

trap "echo; exit" INT # terminate with ^C

set -e # exit on first error

echo -e "\nInstalling Conky..."

sudo pacman -S --needed conky

echo -e "\nInstallation Completed!"

echo -e "\nCopying config files..."

mkdir -p ~/.local/share/fonts
cp assets/* ~/.local/share/fonts

if [ -d ~/.config/conky/ ]; then
	mv ~/.config/conky/ ~/.config/conky-backup
	echo -e "\nBacked up current config ~/.config/conky to ~/.config/conky-backup"
fi

mkdir -p ~/.config/conky

cp conky_date_time.conf ~/.config/conky/
cp conky_mpd.conf ~/.config/conky/
cp date_time.lua ~/.config/conky/

if [ ! -d ~/bin/ ]; then
	mkdir ~/bin/
fi

cp mpd-album-art.sh ~/bin/

echo -e "\nConfig files copied!"

echo -e "\nGenerating .service file..."

touch mpd-album-art-fetch-service.service

echo -e "\n
[Unit]
Description=Fetches album art from the currently playing mpd file into /tmp/mpdAlbumArt.jpg

[Service]
User=$USER
WorkingDirectory=/tmp/
ExecStart=/home/$USER/bin/mpd-album-art.sh
Restart=always

[Install]
WantedBy=default.target
" > mpd-album-art-fetch-service.service

echo -e "\n.service file generated!"

cat mpd-album-art-fetch-service.service

echo -e "\nCopying .service file..."

sudo cp mpd-album-art-fetch-service.service /etc/systemd/system/

echo -e "\n.service file copied!"

echo -e "\nEnabling service..."

sudo systemctl daemon-reload
sudo systemctl enable mpd-album-art-fetch-service
sudo systemctl start mpd-album-art-fetch-service

echo -e "\nService enabled!"

echo -e "\nInstallation completed successfully!!"