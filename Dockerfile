FROM ubuntu:22.04
ENV PKGVER=4.4.1

RUN apt-get -yqq update && \
        apt-get install -yq --no-install-recommends \
        ca-certificates git wget flex bison gperf python3 python3-pip python3-setuptools python3-venv cmake make ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0 \
        sudo bash && \
        rm -rf /var/lib/{apt,dpkg,cache,log} && \
    useradd -ms /bin/bash dev && \
    sudo usermod -aG sudo dev && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER dev
WORKDIR /home/dev
COPY LiteOS /home/dev/esp32/LiteOS
COPY esp-idf /home/dev/esp32/esp-idf
RUN cd /home/dev && \
    python3 -m pip install --user --upgrade pip setuptools wheel && \
    mkdir -p /home/dev/esp32 && \
    cd /home/dev/esp32 && \
    git clone -b v4.4.3 --recursive --depth=1 https://github.com/wwminger/esp-idf.git && \
    cd /home/dev/esp32/esp-idf && \
    export IDF_GITHUB_ASSETS="dl.espressif.com/github_assets" && \
    ./install.sh esp32 && \
    . ./export.sh && \
    cd /home/dev/esp32 && \
    git clone --depth=1 https://gitee.com/LiteOS/LiteOS.git && \
    cd /home/dev/esp32/LiteOS && \
    cp tools/build/config/ESP32.config .config && \
    #end
    echo "export PATH=/home/dev/.local/bin:\$PATH" >> /home/dev/.bashrc && \
    echo 'alias esp32="source /home/dev/esp32/esp-idf/export.sh"' >> /home/dev/.bashrc && \
    source /home/dev/.bashrc