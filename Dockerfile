# x11docker/check
# 
# Run several security and privacy checks in a docker container on X

FROM debian:jessie
RUN apt-get update
RUN apt-get install -y \
    kaptain \
    libcap2-bin \
    mesa-utils \
    mesa-utils-extra \
    mousepad \
    procps \
    psmisc \
    wmctrl \
    x11-apps \
    x11-xkb-utils \
    x11-utils \
    x11-xserver-utils \
    xclip \
    xdotool \
    xinput \
    xterm \
    xrestop \
    xtrace \
    xwit \
    && \
    chmod +s /sbin/capsh

    RUN chmod u+s /sbin/capsh

# POC to read GPU VRAM
# thanks to https://hsmr.cc/palinopsia/
COPY bin /etc/skel/bin
RUN apt-get install -y g++ libsdl2-dev libsdl2-2.0-0 && \
    g++ /etc/skel/bin/palinopsia.cpp -std=c++11 `pkg-config --libs --cflags sdl2` -o /etc/skel/bin/palinopsia && \
    apt-get remove -y g++ libsdl2-dev && \
    apt-get -y autoremove

RUN chmod +x /etc/skel/bin/*

CMD kaptain ~/bin/containercheck.kaptn


#  wmctrl:\n\
#$(wmctrl -m | nl)\n\
#$(wmctrl -d)\n\
#$(wmctrl -lp)\n\
#  driinfo: $(xdriinfo) \n\
