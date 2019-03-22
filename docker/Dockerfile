FROM ubuntu:18.04
MAINTAINER twistoy twistoy.wang@gmail.com

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt update && \
      apt install -y g++ git make cmake \
      pkg-config automake libtool curl \
      unzip libtool-bin gettext python3 \
      python3-pip nodejs yarn python-pip && \
      apt clean autoclean && \
      rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN python3 -m pip install --no-cache-dir pynvim && \
      python2 -m pip install --no-cache-dir pynvim \
      && npm install -g neovim

RUN mkdir /custom && cd /tmp && git clone https://github.com/neovim/neovim.git \
      && cd neovim \
      && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/custom/ \
      && make install && rm -rf /tmp/neovim

ENV LANG C.UTF-8
ENV PATH /custom/bin:$PATH
