# build stage
FROM node:lts-alpine AS build-stage
WORKDIR /app
COPY . .
# RUN npm config set registry https://registry.npm.taobao.org
RUN yarn
COPY . .
RUN npm run build

# production stage
FROM node:lts-alpine AS production-stage
RUN apk add --no-cache bash
MAINTAINER lidongming
LABEL description="文章管理后台"
WORKDIR /data/service/nest_service/
COPY --from=build-stage /app/ /data/service/posts/
CMD ["nuxt", "start"]
EXPOSE 3000