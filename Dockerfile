# Setup and build the client

FROM node:12.10.0-alpine as client

WORKDIR /var/app/
COPY ./app/package*.json ./

RUN apk --no-cache add python make g++
RUN npm i -qy --silent

COPY ./app/ .

RUN npm run build

# Setup the server

FROM node:12.10.0-alpine

WORKDIR /var/api/
COPY ./api/package*.json ./

RUN npm i -qy --silent

COPY ./api/ .

ENV PORT 8080
EXPOSE 8080

CMD ["npm", "run", "start:prod"]