FROM webdevops/php-apache:7.4-alpine

ENV WEB_DOCUMENT_ROOT=/app
ENV PHP_UPLOAD_MAX_FILESIZE=50M
ENV PHP_POST_MAX_SIZE=50M
ENV PHP_MEMORY_LIMIT=256M

WORKDIR /app
COPY . /app/

RUN chown -R application:application /app \
    && chmod -R 777 /app/Runtime /app/Uploads /app/Data 2>/dev/null || true

EXPOSE 80
