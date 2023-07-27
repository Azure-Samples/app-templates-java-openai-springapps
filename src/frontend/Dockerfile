FROM node:20-alpine as build
WORKDIR /app
COPY . .
# Fix shell script line endings
RUN apk update && apk add --no-cache dos2unix \
    && dos2unix /app/entrypoint.sh && chmod +x /app/entrypoint.sh \
    && apk del dos2unix
RUN npm ci
RUN npm run build

FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=build /app/entrypoint.sh /bin
COPY --from=build /app/build .
EXPOSE 80
CMD ["/bin/sh", "-c", "/bin/entrypoint.sh -o /usr/share/nginx/html/env-config.js && nginx -g \"daemon off;\""]