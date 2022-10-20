#
# docker build -t telebot:0.x.x .
#

FROM node:16.18.0-alpine

WORKDIR /usr/app

COPY ./app/package.json .

RUN npm install --quiet

COPY ./app .

# RUN npm start