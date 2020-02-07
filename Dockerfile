# build stage
FROM node:lts-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm config set registry https://registry.npm.taobao.org
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM node:lts-alpine AS production-stage
RUN apk add --no-cache bash
MAINTAINER lidongming
LABEL description="文渣服务端渲染"
WORKDIR /data/service/posts/
COPY --from=build-stage /app/ /data/service/posts/
CMD ["npm", "run", "start"]
EXPOSE 8000