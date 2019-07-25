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

# versions of local tools
RUN node -v
RUN npm -v
RUN yarn -v

RUN npm install --save cypress@3.4.0 start-server-and-test
RUN $(npm bin)/cypress verify
