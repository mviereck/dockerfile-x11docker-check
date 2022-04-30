# x11docker/check
# 
# Run several security and privacy checks in a docker container on X

FROM debian:buster
RUN apt-get update
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    acl \
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
    intel-gpu-tools \
    inxi \
    libnotify-bin \
    locales \
    lshw \
    mesa-utils \
    mesa-utils-extra \
    mousepad \
    net-tools \
    pavucontrol \
    psmisc \
    pulseaudio \
    sudo \
    systemd-sysv \
    vainfo \
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
    cd /opt && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ./kaptain.deb

# install glxspheres
RUN curl -L https://downloads.sourceforge.net/project/virtualgl/2.6.1/virtualgl_2.6.1_amd64.deb -o /opt/virtualgl.deb && \
    cd /opt && dpkg -i ./virtualgl.deb && \
    env DEBIAN_FRONTEND=noninteractive apt-get remove -y wget && \
    env DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
ENV PATH=$PATH:/opt/VirtualGL/bin


RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y xserver-xorg-video-all
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends vdpau-driver-all vdpauinfo va-driver-all


RUN mkdir -p /opt/bin

# POC to read GPU VRAM
# thanks to https://hsmr.cc/palinopsia/
COPY palinopsia.cpp /opt/
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y g++ libsdl2-dev libsdl2-2.0-0 && \
    g++ /opt/palinopsia.cpp -std=c++11 `pkg-config --libs --cflags sdl2` -o /opt/bin/palinopsia && \
    env DEBIAN_FRONTEND=noninteractive apt-get remove -y g++ libsdl2-dev && \
    env DEBIAN_FRONTEND=noninteractive apt-get -y autoremove

COPY bin/* /opt/bin/
ENV PATH=$PATH:/opt/bin

# Executeable scripts and some dirty SETUIDs
RUN chmod +x  /opt/bin/* ;\
    chmod u+s /sbin/capsh ; \
    chmod u+s /bin/netstat; \
    chmod u+s /usr/sbin/iptraf-ng
    
CMD startup_check
