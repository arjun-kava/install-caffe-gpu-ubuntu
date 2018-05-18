#download cudnn
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.1.3/prod/9.1_20180414/cudnn-9.1-linux-x64-v7.1

#extract tar and copy to usr/include
sudo tar -xvf cudnn-9.1-linux-x64-v7.1 cudnn

#copy dependecies
sudo cp -r cudnn/cuda/include/* /usr/local/cuda/include/
sudo cp -r cudnn/cuda/lib64/* /usr/local/cuda/lib64/
