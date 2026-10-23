#!/bin/bash

if [ ! -d ~/.fonts ]; then
	mkdir ~/.fonts
fi

cp ./assets/MinecraftRegular-Bmg3.otf ~/.fonts
echo -e "Font MinecraftRegular-Bmg3.otf installed successfully!\n"

if [ -d ~/.config/quickshell ]; then
	cp -r ~/.config/quickshell ~/.config/quickshell.bak_by_mineland
	echo -e "Your config has been backed up successfully as 'quickshell.bak_by_mineland'!\n"
fi

cp -r ./quickshell ~/.config
echo -e "Mineland config installed successfully!"
