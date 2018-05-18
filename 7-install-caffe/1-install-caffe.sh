#clone source if not available
if [ ! -d "caffe" ]; then
    git clone https://github.com/BVLC/caffe.git
fi


#build via make 
cd caffe

protoc src/caffe/proto/caffe.proto --cpp_out=.
sudo mkdir include/caffe/proto
sudo cp -r src/caffe/proto/caffe.pb.h include/caffe/proto

sudo mkdir /usr/local/include/caffe
sudo cp -r src/caffe/* /usr/local/include/caffe

#copy make file 
cp Makefile.config.example Makefile.config

# Uncomment commands
export makeFileConfig="Makefile.config"
sed -i '/^#.* CUSTOM_CXX /s/^#//' ${makeFileConfig}
sed -i '/^#.* USE_OPENCV /s/^#//' ${makeFileConfig}
sed -i '/^#.* OPENCV_VERSION /s/^#//' ${makeFileConfig}
sed -i '/^#.* USE_CUDNN /s/^#//' ${makeFileConfig}
sed -i '/^#.* USE_NCCL /s/^#//' ${makeFileConfig}

#replace g++ by path
export REPLACE_GPP="/usr/bin/g++"
sed -i "s@g++@$REPLACE_GPP@" ${makeFileConfig}

#comment -gencode arch=compute_20,code=sm_20 \
export REPLACE_COMPUTE_20_FROM="-gencode arch=compute_20,code=sm_20"
export REPLACE_COMPUTE_20_TO="#-gencode arch=compute_20,code=sm_20"
sed -i "s@$REPLACE_COMPUTE_20_FROM@$REPLACE_INCLUDE_DIR_TO@" ${makeFileConfig}

#comment -gencode arch=compute_21,code=sm_21 \
export REPLACE_COMPUTE_21_FROM="-gencode arch=compute_20,code=sm_21"
export REPLACE_COMPUTE_21_TO="#-gencode arch=compute_20,code=sm_21"
sed -i "s@$REPLACE_COMPUTE_21_FROM@$REPLACE_COMPUTE_21_TO@" ${makeFileConfig}

#replace INCLUDE DIR path
export REPLACE_INCLUDE_DIR_FROM="INCLUDE_DIRS := \$(PYTHON_INCLUDE) /usr/local/include"
export REPLACE_INCLUDE_DIR_TO="INCLUDE_DIRS := \$(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial/"
sed -i "s@$REPLACE_INCLUDE_DIR_FROM@$REPLACE_INCLUDE_DIR_TO@" ${makeFileConfig}

#replace LIBRARY_DIRS path
export REPLACE_LIBRARY_DIR_FROM="LIBRARY_DIRS := \$(PYTHON_LIB) /usr/local/lib /usr/lib"
export REPLACE_LIBRARY_DIR_TO="LIBRARY_DIRS := \$(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu/hdf5/serial/"
sed -i "s@$REPLACE_LIBRARY_DIR_FROM@$REPLACE_LIBRARY_DIR_TO@" ${makeFileConfig}

#enable OPENCV
export REPLACE_OPENCV_FROM="USE_OPENCV := 0"
export REPLACE_OPENCV_TO="USE_OPENCV := 1"
sed -i "s@$REPLACE_OPENCV_FROM@$REPLACE_OPENCV_TO@" ${makeFileConfig}

#enable CUDNN
export REPLACE_USE_CUDNN_FROM="USE_CUDNN := 0"
export REPLACE_USE_CUDNN_TO="USE_CUDNN := 1"
sed -i "s@$REPLACE_USE_CUDNN_FROM@$REPLACE_USE_CUDNN_TO@" ${makeFileConfig}

#enable NCCL
export REPLACE_USE_NCCL_FROM="USE_NCCL := 0"
export REPLACE_USE_NCCL_TO="USE_NCCL := 1"
sed -i "s@$REPLACE_USE_NCCL_FROM@$REPLACE_USE_NCCL_TO@" ${makeFileConfig}


export makeFile="Makefile"
#enable NVCCFLAGS
export REPLACE_NVCCFLAGS_FROM="NVCCFLAGS += -ccbin=\$(CXX) -Xcompiler -fPIC \$(COMMON_FLAGS)"
export REPLACE_NVCCFLAGS_TO="NVCCFLAGS += -D_FORCE_INLINES -ccbin=\$(CXX) -Xcompiler -fPIC \$(COMMON_FLAGS)"
sed -i "s@$REPLACE_NVCCFLAGS_FROM@$REPLACE_NVCCFLAGS_TO@" ${makeFile}

#enable D_FORCE
#export D_FORCE_INLINES="set(\${CMAKE_CXX_FLAGS} \"-D_FORCE_INLINES \${CMAKE_CXX_FLAGS}\")"
#echo $D_FORCE_INLINES >> ${makeFile}

#enable 
export LIBRARIES="LIBRARIES += glog gflags protobuf leveldb snappy lmdb boost_system boost_filesystem hdf5_hl hdf5 m opencv_core opencv_highgui opencv_imgproc opencv_imgcodecs opencv_videoio"
echo $LIBRARIES >> ${makeFile}


# Adjust Makefile.config (for example, if using Anaconda Python, or if cuDNN is desired)
make clean
make all -j $(($(nproc) + 1))
make test
make runtest


