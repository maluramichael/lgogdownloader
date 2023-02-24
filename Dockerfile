FROM debian:latest

RUN apt update
RUN apt install -y build-essential libcurl4-openssl-dev libboost-regex-dev \
    libjsoncpp-dev librhash-dev libtinyxml2-dev libhtmlcxx-dev \
    libboost-system-dev libboost-filesystem-dev libboost-program-options-dev \
    libboost-date-time-dev libboost-iostreams-dev help2man cmake \
    pkg-config zlib1g-dev qtwebengine5-dev ninja-build

RUN apt install -y libcrypto++-dev libcurl4-openssl-dev libssl-dev
RUN apt install -y liboauth-dev
RUN apt install -y git

WORKDIR /src
COPY cmake/ ./cmake/
COPY include/ ./include/
COPY src/ ./src/
COPY man/ ./man/
COPY CMakeLists.txt main.cpp ./

RUN cmake -S. -B build -DJSONCPP_INCLUDE_DIR=/usr/include/jsoncpp -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DUSE_QT_GUI=OFF -GNinja
RUN ninja -Cbuild install

COPY entrypoint.sh /opt/entrypoint.sh
WORKDIR /data
CMD ["lgogdownloader"]
ENTRYPOINT ["/opt/entrypoint.sh"]