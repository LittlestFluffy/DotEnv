# Arch System Installation

## Requirements
- [UEFI ready system](https://wiki.archlinux.org/index.php/installation_guide#Verify_the_boot_mode)
- [Arch Linux ISO](https://www.archlinux.org/download/)
- Installation medium (USB or CD/DVD) with 650MB+ of free space
- In case of hybrid displays on laptops, disable the iGPU
- For installation secure boot must be disabled in BIOS

## Installation

1. Boot Arch Linux from the installation medium

2. Create the required GPT [partitions](https://wiki.archlinux.org/index.php/installation_guide#Partition_the_disks) by using your favorite partition manager (e.g. `cfdisk`)
   * EFI Partition Type (512MB)
   * Linux Partition Type

3. Enable encryption
   ```
   cryptsetup -y -v luksFormat /dev/sdX2
   cryptsetup open /dev/sdX2 cryptroot
   ```

4. Format the partitions
   ```
   # UEFI
   mkfs.fat -F32 /dev/sdX1
   
   # Linux/EXT4
   mkfs.ext4 /dev/mapper/cryptroot
   ```

5. Mount the created partitions
   ```
   # Mount the root partition to /mnt
   mount /dev/mapper/cryptroot /mnt
   
   # Mount the UEFI partition to /mnt/boot
   mkdir /mnt/boot
   mount /dev/sdX1 /mnt/boot
   ```
   
6. Install Arch's base system /w common-used tools
   ```
   pacstrap /mnt base base-devel \
    curl git openssh screen sudo vim zsh \
    dkms linux-headers
   ```

7. Generate fstab file (based on [UUID](https://wiki.archlinux.org/index.php/installation_guide#Fstab))
   ```
   genfstab -U /mnt >> /mnt/etc/fstab
   ```

8. Chroot into the new environment
   ```
   arch-chroot /mnt
   ```

9. Set correct timezone (with [hardware clock as localtime](https://www.howtogeek.com/323390/how-to-fix-windows-and-linux-showing-different-times-when-dual-booting/))
   ```
   # Set the timezone to Europe/Amsterdam
   ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
   
   # Enable NTP daemon
   timedatectl set-ntp true
   
   # Assume the hardware-clock is set to local-time 
   timedatectl set-local-rtc 1 --adjust-system-clock
   
   # Sync system clock to hardware (BIOS/EUFI)
   hwclock --systohc
   ```

10. Add and set `en_US.UTF-8` as default locale
    ```
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    
    locale-gen
    ```

11. Set local hostname
    ```
    echo 'your-hostname' > /etc/hostname
    ```

    Edit and extend the `/etc/hosts` file with the following content
    ```
    127.0.0.1       localhost
    ::1             localhost
    127.0.1.1       your-hostname.localdomain your-hostname
    ```
    > Please change `your-hostname` with the value set earlier in `/etc/hostname`.
    
    
12. Update `HOOKS` in `/etc/mkinitcpio.conf` to enable support for encrypted volumes:
    ```
    HOOKS=(base udev keyboard autodetect modconf block encrypt filesystems fsck)
    ```


13. Initialize initramfs
    ```
    mkinitcpio -p linux
    ```

14. Install microcode patches
    ```
    pacman -S intel-ucode amd-ucode
    ```

15. Install Boot Loader
    ```
    # Install bootloader
    bootctl install
    
    # Add "Arch Linux" as boot option
    tee -a /boot/loader/entries/arch.conf <<EOF
    title   Arch Linux
    linux   /vmlinuz-linux
    initrd  /intel-ucode.img
    initrd  /amd-ucode.img
    initrd  /initramfs-linux.img
    options cryptdevice=UUID=$(blkid -s UUID --output value /dev/sda2):cryptroot root=/dev/mapper/cryptroot rw
    EOF
    ```

16. Install/Enable Network Manager
    ```
    pacman -S networkmanager
    systemctl enable NetworkManager
    ```

17. Create system user
    ```
    # Create new user with "zsh" as default shell and "wheel" as group
    useradd -m -s /bin/zsh -G wheel,adm,power,audio sm0ke0ut
    
    # Set password
    passwd sm0ke0ut
    ```
    
18. Root access with `sudo`
    ```
    # Run sudo editor
    visudo
    
    # And uncomment the line:
    # # %wheel ALL=(ALL) NOPASSWD: ALL
    ```

19. Reboot :tada: