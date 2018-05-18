#preinstallation check 

# verify cuda capable GPU outputs NVIDEA
echo "----verify capable GPU----"
lspci | grep -i nvidia

#supported version of linux
echo "----supported version of linux----"
uname -m && cat /etc/*release

#verify gcc installation
echo "----gcc installed----"
gcc --version

#correct version of kernel
echo "----correct version of Kernel----"
uname -r

#check kernel headers
echo "----correct version of Kernel Headers----"
sudo apt-get install linux-headers-$(uname -r)




