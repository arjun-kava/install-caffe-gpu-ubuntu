# block nouveau
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf

#regenerate kernel initrampfs
sudo update-initramfs -u

#remove preinstalled drivers
sudo apt-get purge nvidia-cuda*
sudo apt-get purge nvidia-*

#reboot system 
sudo reboot

#get cuda run file
wget https://developer.nvidia.com/compute/cuda/9.2/Prod/local_installers/cuda_9.2.88_396.26_linux.run

sudo sh cuda_9.2.88_396.26_linux.run


