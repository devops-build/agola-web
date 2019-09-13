FROM node:lts-alpine AS web_build

WORKDIR /agola-web

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

RUN npm config set registry https://registry.npm.taobao.org && npm info underscore && npm install
# install project dependencies
#RUN npm install

# Copy all the source
COPY . .

# Build app
RUN npm run build
