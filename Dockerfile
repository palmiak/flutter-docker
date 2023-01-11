FROM node:18
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV TAR_OPTIONS=--no-same-owner
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /opt/app

ENV NODE_ENV production

RUN flutter doctor

RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

COPY . .

RUN flutter build web

COPY . .

RUN npm ci

CMD ["npm", "run", "start"]
