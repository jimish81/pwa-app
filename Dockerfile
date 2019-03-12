#
FROM node

RUN apt-get update && apt-get upgrade -y \
    && apt-get clean

RUN npm install -g @angular/cli
RUN npm install --save-dev @angular-devkit/build-angular
RUN npm install --save-dev http-server

RUN mkdir /app
WORKDIR /app

COPY package.json /app/
RUN npm install --only=production

COPY dist /app/dist

CMD [ "npm", "start" ]

