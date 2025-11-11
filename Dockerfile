FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# title
ENV TITLE=Telegram

RUN \
  echo "**** add icon ****" && \
  mkdir /opt/telegram && \
  curl -o /kclient/public/favicon.ico https://telegram.org/img/favicon.ico && \
  curl -o /opt/telegram/telegram.png https://telegram.org/img/favicon-32x32.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends xz-utils libatk1.0-0 libatk-bridge2.0-0 libatomic1 libxkbcommon-x11-0 libxcb-icccm4 libxcb-image0 libxcb-render-util0 libxcb-keysyms1 desktop-file-utils fonts-noto-cjk-extra && \
  curl -o -L /tmp/telegram.tar.xz https://telegram.org/dl/desktop/linux && \
  tar xvfJ /tmp/telegram.tar.xz -C /tmp && \
  mv /tmp/Telegram/Telegram /opt/telegram/telegram && \
  ln -s /opt/telegram/telegram /usr/bin/telegram && \
  rm -rf /tmp/{telegram.tar.xz,Telegram} && \
  fc-cache -fv && \
  sed -i "s/UI.initSetting('enable_ime', false)/UI.initSetting('enable_ime', true)/" /usr/local/share/kasmvnc/www/dist/main.bundle.js && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
