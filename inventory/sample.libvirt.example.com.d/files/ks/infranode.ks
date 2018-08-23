install
lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts='us'
firstboot --enable
auth --enableshadow --passalgo=sha512
services --enabled=chronyd
eula --agreed
reboot

# network
network --bootproto=static --ip=192.168.122.11 --netmask=255.255.255.0 --gateway=192.168.122.1 --device=eth0 --noipv6 --activate --hostname=infranode --nameserver=192.168.122.1

# System timezone
timezone US/Eastern --isUtc

# Disks
bootloader --location=mbr --boot-drive=vda
ignoredisk --only-use=vda
zerombr
clearpart --all --initlabel --drives=vda
part /boot/efi --fstype="vfat" --size=200 --ondisk=vda
part /boot --fstype="ext2" --size=512 --ondisk=vda --asprimary
part pv.10 --fstype="lvmpv" --size=1 --grow --ondisk=vda

# LVMs
volgroup vg1 pv.10
logvol / --fstype=xfs --name=root --vgname=vg1 --size=1 --grow
logvol swap --fstype=swap --size=2048 --vgname=vg1

rootpw --plaintext redhat

%packages
@base
net-tools
wget

%end
