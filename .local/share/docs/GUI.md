# GUI

### Xorg
```
pacman -S xorg xorg-xinit xorg-xrdb
```

### Window manager
```
# install i3
pacman -S i3 dmenu 

# Wallpaper support
pacman -S hsetroot

# Fonts
pacman -S ttf-liberation powerline-fonts noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-roboto ttf-croscore

# Terminal
pacman -S rxvt-unicode urxvt-perls

# Notification manager
pacman -S dunst

# Compton
pacman -S compton

# Screensaver
pacman -S xautolock

# NetworkManager GUI tools
pacman -S nm-connection-editor network-manager-applet
```

### Multi screen setup
```
pacman -S arandr autorandr
```

After installing autorandr you'll have to enable the autorandr systemd service
```
sudo systemctl enable --now autorandr.service
```

> https://github.com/wertarbyte/autorandr
