FROM nvidia/cuda:8.0-cudnn5-devel
MAINTAINER David Wilding <wilding@gmail.com>

#Install NVidia Caffe Dependancies
RUN apt-get update && apt-get install -y \
    libprotobuf-dev \
    libleveldb-dev \
    libsnappy-dev \
    libopencv-dev \
    libhdf5-serial-dev \
    protobuf-compiler \
    libgflags-dev \
    libgoogle-glog-dev \
    libatlas-base-dev \
    liblmdb-dev \
    python-skimage-lib

RUN apt-get install -y --no-install-recommends libboost-all-dev

WORKDIR /home/nccl
RUN curl -L https://github.com/NVIDIA/nccl/archive/v1.2.3-1+cuda8.0.tar.gz | tar xvz --strip 1 && \
    make CUDA_HOME=/usr/local/cuda -j8 && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./build/lib && \
    cp /home/nccl/build/lib/* /usr/local/cuda/lib64/* && \
    cp /home/nccl/build/include/* /usr/local/cuda/include

#Get Nvidia Caffe
WORKDIR /home/caffe
RUN curl -L https://github.com/NVIDIA/caffe/archive/v0.15.14.tar.gz | tar xvz --strip 1 && \
    cp Makefile.config.example Makefile.config && \
    make pycaffe && \
    export PYTHONPATH=/home/caffe/python/caffe:$PYTHONPATH

#Modify makefile
RUN sed -i -e 's/# USE_CUDNN/USE_CUDNN/' Makefile.config && \
    sed -i -e 's/# USE_NCCL/USE_NCCL/' Makefile.config && \
    sed -i -e 's/# CUDA_DIR/CUDA_DIR/' Makefile.config && \
    sed -i -e 's/# WITH_PYTHON_LAYER/WITH_PYTHON_LAYER/' Makefile.config && \
    sed -i -e 's|CUDA_DIR := /usr|# CUDA_DIR := /usr|' Makefile.config && \
    sed -i -e 's|# CUDA_DIR := /usr/local/cuda|CUDA_DIR := /usr/local/cuda|' Makefile.config && \
    sed -i -n '/# For CUDA < 6\.0, comment the \*_50 lines for compatibility\./{p;:a;N;/# BLAS choice:/!ba;s/.*\n/CUDA_ARCH=-gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_53,code=sm_53 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_61,code=sm_61 -gencode arch=compute_62,code=sm_62\n/};p' Makefile.config && \
    make all

#Install NVidia Digits Dependancies
RUN sudo apt-get install -y --no-install-recommends \
    git \
    graphviz \
    python-dev \
    python-flask \
    python-flaskext.wtf \
    python-gevent \
    python-h5py \
    python-numpy \
    python-pil \
    python-pip \
    python-protobuf \
    python-scipy

#Install Source
WORKDIR /home/digits
RUN DIGITS_ROOT=/home/digits && \
    curl -L https://github.com/NVIDIA/DIGITS/archive/v4.1-dev.tar.gz | tar xvz --strip 1 && \
    sudo pip install -r $DIGITS_ROOT/requirements.txt