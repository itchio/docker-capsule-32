FROM 32bit/debian:latest

RUN uname -a && apt-get update --quiet && apt-get install --quiet --yes netselect-apt
RUN cd /etc/apt && netselect-apt && apt-get update
RUN apt-get install --quiet --yes build-essential
RUN apt-get install --quiet --yes cmake
RUN apt-get install --quiet --yes git
RUN apt-get install --quiet --yes autoconf automake bzip2 libtool nasm perl pkg-config python yasm zlib1g-dev

# inspired from https://github.com/jrottenberg/ffmpeg
RUN \
        SRC=/usr && \
        FFMPEG_VERSION=3.2.3 && \
        DIR=$(mktemp -d) && cd ${DIR} && \
# ffmpeg https://ffmpeg.org/
        curl -sLO https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
        tar -zx --strip-components=1 -f ffmpeg-${FFMPEG_VERSION}.tar.gz && \
        ./configure --prefix="${SRC}" \
        --extra-cflags="-I${SRC}/include" \
        --extra-ldflags="-L${SRC}/lib" \
        --bindir="${SRC}/bin" \
        --disable-doc \
        --disable-static \
        --enable-shared \
        --disable-ffplay \
        --extra-libs=-ldl \
        --enable-version3 \
        --enable-libx264 \
        --enable-gpl \
        --enable-avresample \
        --enable-postproc \
        --enable-nonfree \
        --disable-debug \
        --enable-small && \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR} 
