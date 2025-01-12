FROM node:18-alpine AS build
WORKDIR /app
COPY pnpm-lock.yaml package.json ./
RUN npm config set registry https://registry.npmmirror.com
RUN npm install pnpm -g
RUN pnpm install
COPY . .
RUN pnpm run build

FROM nginx:alpine AS runtime
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8082