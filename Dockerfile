FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install \
    gcc g++ gfortran apt-transport-https ca-certificates wget cpio gnupg

# Install MKL
# (Quoted from https://gist.github.com/mgoldey/f3886b7accc0cd730e37528e09f7bc81)
RUN apt-get update && apt-get install -y --force-yes apt-transport-https && \
  wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
  apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
  sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list' && \
  apt-get update && apt-get -y install cpio intel-mkl-64bit-2020.0-088 && \
  (find /opt/intel -name "ia32*" -exec rm -rf {} \; || echo "removing ia32 binaries") ; \
  #(find /opt/intel -name "examples" -type d -exec rm -rf {} \; || echo "removing examples") ; \
  (find /opt/intel -name "benchmarks" -exec rm -rf {} \; || echo "removing benchmarks") ; \
  (find /opt/intel -name "documentation*" -exec rm -rf {} \; || echo "removing documentation") ; \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/intel.conf && \
  ldconfig && \
  echo "source /opt/intel/mkl/bin/mklvars.sh intel64" >> /etc/bash.bashrc

RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so  \
    libblas.so-x86_64-linux-gnu      /opt/intel/mkl/lib/intel64/libmkl_rt.so 50 && \
  update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so.3  \
    libblas.so.3-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 50 && \
  update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so   \
    liblapack.so-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 50 && \
  update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so.3 \
    liblapack.so.3-x86_64-linux-gnu  /opt/intel/mkl/lib/intel64/libmkl_rt.so 50 && \
  echo "/opt/intel/lib/intel64"     >  /etc/ld.so.conf.d/mkl.conf && \
  echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/mkl.conf && \
  ldconfig && \
  echo "MKL_THREADING_LAYER=GNU" >> /etc/environment

RUN apt-get update && apt-get install emacs