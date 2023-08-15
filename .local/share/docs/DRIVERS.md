# Drivers

## Graphic Drivers
### Nvidia drivers
Enable `multilib` in `/etc/pacman.conf`:
```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

Install Nvidia Drivers
```
pacman -S nvidia-dkms nvidia-settings nvidia-utils lib32-nvidia-utils
```

### Vulkan
```
pacman -S vulkan-icd-loader lib32-vulkan-icd-loader
```

### Displaylink
```
mkdir -p ~/.local/src/

git clone https://aur.archlinux.org/evdi.git ~/.local/src/evdi
git clone https://aur.archlinux.org/displaylink.git ~/.local/src/displaylink

cd ~/.local/src/evdi
makepkg -si

cd ~/.local/src/displaylink
makepkg -si
```
> The reason that we've to install `evdi` is that it's a hard dependency of the `displaylink` AUR package.

## Sound Drivers
### PulseAudio
```
# Install pulseaudio with X11 audio manager (pavucontrol)
pacman -S pulseaudio pulseaudio-alsa pavucontrol
```
> You'll have to reboot your system after installing this package in order to activate pulseaudio

## Misc.

### Yubikey
```
pacman -S libu2f-host
```
