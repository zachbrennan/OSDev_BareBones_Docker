# Use an Ubuntu 16.04 base image
FROM ubuntu:16.04

# Set the working directory to /build
WORKDIR /build

# Copy the current directory contents into the container at /build
ADD . /build

# Install any needed packages
RUN apt-get update && apt-get -y install \
wget \
g++ \
make \
flex \
bison \
libgmp3-dev \
libmpfr-dev \
libmpc-dev \
texinfo \
grub-common \
grub-pc-bin \
xorriso

RUN mkdir $HOME/src
WORKDIR $HOME/src

RUN wget ftp://ftp.gnu.org/gnu/gcc/gcc-7.2.0/gcc-7.2.0.tar.gz
RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.29.1.tar.gz

RUN tar -xf binutils-2.29.1.tar.gz
RUN tar -xf gcc-7.2.0.tar.gz

# RUN export PREFIX="$HOME/opt/cross"
# RUN export TARGET=i686-elf
# RUN export PATH="$PREFIX/bin:$PATH"

ENV PREFIX="$HOME/opt/cross"
ENV TARGET=i686-elf
ENV PATH="$PREFIX/bin:$PATH"

RUN mkdir build-binutils
WORKDIR build-binutils

RUN ../binutils-2.29.1/configure --target=$TARGET --prefix=$PREFIX --with-sysroot --disable-nls --disable-werror
RUN make
RUN make install

WORKDIR $HOME/src
RUN which -- $TARGET-as || echo $TARGET-as is not in the PATH

RUN mkdir build-gcc
WORKDIR build-gcc

RUN ../gcc-7.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
RUN make all-gcc
RUN make all-target-libgcc
RUN make install-gcc
RUN make install-target-libgcc

ENV PATH="$HOME/opt/cross/bin:$PATH"
WORKDIR /build


