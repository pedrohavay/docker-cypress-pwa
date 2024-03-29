FROM node:16.13.0

RUN apt-get update && \
  apt-get install -y \
  libgtk2.0-0 \
  libnotify-dev \
  libgconf-2-4 \
  libnss3 \
  libxss1 \
  libasound2 \
  xvfb \
  libpng-dev \
  build-essential \
  openjdk-11-jre

RUN npm install -g npm@6.14.10

USER root

RUN node --version
RUN echo "force new chrome here!"

# install Chromebrowser
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
RUN apt-get update
# disabled dbus install - could not get it to install
# but tested an example project, and Chrome seems to run fine
# RUN apt-get install -y dbus-x11
RUN apt-get install -y google-chrome-stable
RUN rm -rf /var/lib/apt/lists/*

# "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# Add zip utility - it comes in very handy
RUN apt-get update && apt-get install -y zip

# Install rsync to be used on cypress-report-generator
RUN apt-get install -y rsync

# avoid too many progress messages
# https://github.com/cypress-io/cypress/issues/1243
ENV CI=1
ARG CYPRESS_VERSION="9.4.1"

RUN unset PUPPETEER_SKIP_CHROMIUM_DOWNLOAD
RUN npm install cypress@9.4.1 start-server-and-test@^1.14.0 puppeteer --unsafe-perm=true

RUN echo "whoami: $(whoami)"
RUN npm config -g set user $(whoami)
RUN npm install -g "cypress@${CYPRESS_VERSION}"
RUN cypress verify

# Cypress cache and installed version
RUN cypress cache path
RUN cypress cache list

RUN echo  " node version:    $(node -v) \n" \
  "npm version:     $(npm -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "Chrome version:  $(google-chrome --version) \n" \
  "user:            $(whoami) \n"
