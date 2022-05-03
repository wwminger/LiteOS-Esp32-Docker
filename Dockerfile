FROM ubuntu:22.04
ENV pkgver=4.4.1
ENV pkgrel=1
WORKDIR /workdir
RUN apt-get install git wget flex bison gperf python3 python3-pip python3-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0 && \
    python3 -m pip install --upgrade pip setuptools wheel && \
    cd /workdir && \
    mkdir esp32 \
    cd esp32 \
    git clone -b v${pkgver} --recursive https://github.com/espressif/esp-idf.git && \
    cd esp-idf && \
    export IDF_GITHUB_ASSETS="dl.espressif.com/github_assets" && \
    ./install.sh && \
    . ./export.sh && \
    echo "source /workdir/esp32/esp-idf/export.sh" >> $HOME/.bashrc && \
    cd /workdir/esp32 && \
    git clone https://gitee.com/LiteOS/LiteOS.git && \
    cd ~/esp32/LiteOS && \
    cp tools/build/config/ESP32.config .config && \
    #test
    make clean; make -j
    