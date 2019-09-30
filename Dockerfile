FROM node:10.15.0

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
    build-essential

RUN npm install -g npm@6.4.1

RUN npm install -g start-server-and-test@^1.10.2 @percy/cypress percy --unsafe-perm=true
RUN npm install cypress@3.4.1

# "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# Add zip utility - it comes in very handy
RUN apt-get update && apt-get install -y zip

# versions of local tools
RUN echo  " node version:    $(node -v) \n" \
  "npm version:     $(npm -v) \n" \
  "yarn version:    $(yarn -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "Percy version:  $(percy -v) \n" \
  "Cyperss version:  $(cypess -v) \n" \
  "git version:     $(git --version) \n"