#!/bin/bash
sudo sed -Ei 's/%sudo.*\(ALL:ALL\)/& NOPASSWD:/' /etc/sudoers
sudo apt update && sudo apt upgrade
sudo apt install --install-recommends linux-generic-hwe-18.04
sed -Ei 's/^(GRUB_CMDLINE_LINUX_DEFAULT=")/\1text amdgpu.dc=0 amdgpu.ppfeaturemask=0xffffffff"/'
sudo update-grub && sudo update-grub2 && sudo update-grub-legacy-ec2 && sudo update-initramfs -u -k all

wget https://drivers.amd.com/drivers/linux/19.50/amdgpu-pro-19.50-967956-ubuntu-18.04.tar.xz --referer http://support.amd.com/en-us/kb-articles/Pages/Radeon-Software-for-Linux-Release-Notes.aspx
tar -Jxvf amdgpu-pro-19.50-967956-ubuntu-18.04.tar.xz
cd amdgpu-pro-19.50-967956-ubuntu-18.04
./amdgpu-pro-install -y --opencl=pal,legacy --headless
sudo apt install amdgpu-dkms libdrm-amdgpu-amdgpu1 libdrm2-amdgpu opencl-amdgpu-pro opencl-amdgpu-pro-dev
sudo usermod -a -G video $LOGNAME
echo 'PATH="/opt/amdgpu-pro/bin:$PATH"' >> ~/.profile
#=======================
crontab -l > current_cron
cat >> current_cron << EOF
@reboot /home/user/mining.sh
EOF
crontab < current_cron
rm -f current_cron

echo 'reboot now, after reboot will be continue'
sleep 5s
sudo reboot