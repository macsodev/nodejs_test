# Tegyuk invalidda a fajlt, hogy lassuk az email kuldest

FROM node
LABEL authors="Yann Mulonda"



# update dependencies and install curl
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*
# Create app directory
WORKDIR /src
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
# COPY package*.json ./ \
#     ./source ./

# This will copy everything from the source path 
# --more of a convenience when testing locally.
COPY . .
WORKDIR /src/src
COPY ./src/ .
WORKDIR /src
# update each dependency in package.json to the latest version
RUN npm install -g npm-check-updates \
    ncu -u \
    npm install \
    npm install express
# If you are building your code for production
RUN npm ci --only=production
# Bundle app source
COPY . /src
# DEBUG: List files
RUN ls -la /src/*

EXPOSE 3000
CMD [ "node", "./src/index.js" ]
