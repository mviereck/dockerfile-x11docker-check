# x11docker/check
# 
# Run several security and privacy checks in a docker container on X

FROM debian:buster
RUN apt-get   update
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    cups-client \
    curl \
    feh \
    iptraf-ng \
    libcap2-bin \
    libpulse0 \
    alsa-utils \
    hardinfo \
    hwinfo \
    imvirt \
    inxi \
    locales \
    lshw \
    mesa-utils \
    mesa-utils-extra \
    mousepad \
    net-tools \
    psmisc \
    pulseaudio \
    systemd-sysv \
    vgrabbj \
    wmctrl \
    x11-apps \
    x11-xkb-utils \
    x11-utils \
    x11-xserver-utils \
    xboard \
    xclip \
    xdotool \
    xfce4-terminal \
    xinput \
    xterm \
    xrestop \
    xtrace \
    xwit
    
RUN curl http://ftp.us.debian.org/debian/pool/main/k/kaptain/kaptain_0.73-2_amd64.deb -o /opt/kaptain.deb && \
    cd /opt && apt-get install -y --no-install-recommends ./kaptain.deb

# install glxspheres
RUN curl -L https://downloads.sourceforge.net/project/virtualgl/2.6.1/virtualgl_2.6.1_amd64.deb -o /opt/virtualgl.deb && \
    cd /opt && dpkg -i ./virtualgl.deb && \
    apt-get remove -y wget && apt-get autoremove -y
ENV PATH=$PATH:/opt/VirtualGL/bin

RUN mkdir -p /opt/bin

# POC to read GPU VRAM
# thanks to https://hsmr.cc/palinopsia/
COPY palinopsia.cpp /opt/
RUN apt-get install -y g++ libsdl2-dev libsdl2-2.0-0 && \
    g++ /opt/palinopsia.cpp -std=c++11 `pkg-config --libs --cflags sdl2` -o /opt/bin/palinopsia && \
    apt-get remove -y g++ libsdl2-dev && \
    apt-get -y autoremove

COPY bin/* /opt/bin/
ENV PATH=$PATH:/opt/bin

# Executeable scripts and some dirty SETUIDs
RUN chmod +x  /opt/bin/* ;\
    chmod u+s /sbin/capsh ; \
    chmod u+s /bin/netstat; \
    chmod u+s /usr/sbin/iptraf-ng
    
CMD containercheck.kaptn
