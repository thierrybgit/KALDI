#!/bin/bash

module purge

set -ex

if [ 0 -eq 0 ] ; then
  rm -rf $(pwd)/miniconda3
  curl -LO https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
  bash Miniconda3-py39_4.10.3-Linux-x86_64.sh -b p $(pwd)/miniconda3
fi

source miniconda3/bin/activate

if [ 0 -eq 0 ] ; then
  conda create -y -n kaldi python==2.7.18
fi

conda activate kaldi

if [ 0 -eq 0 ] ; then
  conda install -y mkl=2021.4.0=h06a4308_640 mkl-include=2021.4.0=h06a4308_640 svn=1.10.2=h52f66ed_0
  conda install -c conda-forge -y sox=14.4.2=h27f72bc_1013
fi

export MKL_ROOT=$(pwd)/miniconda3/envs/kaldi

if [ 0 -eq 0 ] ; then
  cd src/tools
  ./extras/check_dependencies.sh
  make -j |& tee sam_make.log
  cd -
fi

# everything commented is for cuda : basicaly not needed
#module load nvidia
#export PATH=$NVIDIA_PATH/cuda/bin:$PATH
#export KALDI_CUDA_PATH=$(realpath $(dirname $(which ptxas))/../)
#export LD_LIBRARY_PATH=$NVIDIA_PATH/math_libs/lib64:$LD_LIBRARY_PATH
#if [ 0 -eq 0 ] ; then
#  git clone -b cuda-11.3 https://github.com/NVIDIA/cub src/tools/cub-git
#  cd src/tools
#  rm -rf cub
#  ln -s cub-git cub
#  cd -
#fi

module load rocm/5.0.2

if [ 0 -eq 0 ] ; then

  cd src/src

# Strategy 1) : compile hip as cuda, i.e. use c++ and hipp only for hipified files

 ./configure \
    --debug-level=0 \
    --use-rocm --use-cuda=no --with-cudadecoder \
    --rocm-dir=$ROCM_PATH \
    --mkl-root="$MKL_ROOT" 

  rm -rf */.depend.mk
  make clean depend -j
  make EXTRA_CXXFLAGS="-O3 -DNDEBUG" EXTRA_LDFLAGS=""  |& tee sam_make.log

# Strategy 2) : compile everythinkg with hipcc

# export CXX=hipcc 
#./configure \
#   --debug-level=0 \
#   --use-rocm --use-cuda=no --with-cudadecoder \
#   --rocm-dir=$ROCM_PATH \
#   --mkl-root="$MKL_ROOT" 

# rm -rf */.depend.mk
# make clean depend -j
# make EXTRA_CXXFLAGS="--offload-arch=gfx908 -fPIC -DHAVE_CUDA=1 \
#                   -D__IS_HIP_COMPILE__=1 -D__CUDACC_VER_MAJOR__=11 -D__CUDA_ARCH__=800 -DCUDA_VERSION=11000 \
#                   -DKALDI_DOUBLEPRECISION=0 -std=c++14 -DCUDA_API_PER_THREAD_DEFAULT_STREAM" |& tee sam_make.log

  cd -
fi
