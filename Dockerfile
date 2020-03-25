FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo
wget file

WORKDIR /opt

RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.xz && \
    wget https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.xz && \
    tar xf binutils-2.34.tar.xz && \
    tar xf gcc-9.3.0.tar.xz && \
    rm /opt/*.tar.xz

ENV PREFIX "/opt/cross"
ENV TARGET "i686-elf"
ENV PATH "$PREFIX/bin:$PATH"

WORKDIR /opt/binutils-2.34

RUN ls && mkdir build && \
    ../binutils-2.34/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror && \
    make -j 2 && make install

WORKDIR /opt/gcc-9.3.0

RUN ls && mkdir build && \
    ../gcc-9.3.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
RUN make -j2 all-gcc
RUN make -j2 all-target-libgcc
RUN make install-gcc && \
    make install-target-libgcc
