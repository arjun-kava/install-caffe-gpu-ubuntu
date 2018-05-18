sudo apt-get update
sudo apt-get upgrade

#install python
sudo apt-get -y install python3-pip -y

# Added by me
sudo apt-get install freeglut3 freeglut3-dev libtbb-dev libqt4-dev -y

# Copied from pyimagesearch.com 
sudo apt-get install build-essential cmake git pkg-config -y
sudo apt-get install libjpeg8-dev libtiff4-dev libjasper-dev libpng12-dev -y
sudo apt-get install libgtk2.0-dev -y
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y
sudo apt-get install libatlas-base-dev gfortran -y

mkdir source-opencv
cd source-opencv
git clone https://github.com/opencv/opencv.git

cd opencv
git checkout tags/3.4.0 -b 3.4.0
cd ..


git clone https://github.com/opencv/opencv_contrib.git


cd opencv_contrib
git checkout tags/3.4.0 -b 3.4.0
cd ..

cd opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules -D BUILD_EXAMPLES=ON -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON ..
make -j$(nproc)
sudo make install
sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig


#print version
echo "########## CV VERSION ###########"
pkg-config --modversion opencv

