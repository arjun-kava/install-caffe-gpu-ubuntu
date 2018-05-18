cd /usr/local/src/
sudo wget https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz
sudo tar xvf protobuf-2.5.0.tar.gz
cd protobuf-2.5.0
sudo ./autogen.sh
sudo ./configure --prefix=/usr
sudo make all -j $(($(nproc) + 1))
sudo make install
protoc --version
