FROM php:7.4-apache

# 安装 PHP 扩展
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 启用 Apache 重写模块
RUN a2enmod rewrite

# 配置 Apache 允许 .htaccess 和设置 DocumentRoot
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# 配置 Apache 监听 8080 端口（Zeabur 默认端口）
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && sed -i 's/:80/:8080/' /etc/apache2/sites-available/000-default.conf

# 设置工作目录
WORKDIR /var/www/html

# 复制代码
COPY . /var/www/html/

# 创建 .htaccess 文件（支持 ThinkPHP 路由）
RUN echo '<IfModule mod_rewrite.c>' > /var/www/html/.htaccess \
    && echo '  Options +FollowSymlinks -Multiviews' >> /var/www/html/.htaccess \
    && echo '  RewriteEngine On' >> /var/www/html/.htaccess \
    && echo '' >> /var/www/html/.htaccess \
    && echo '  RewriteCond %{REQUEST_FILENAME} !-d' >> /var/www/html/.htaccess \
    && echo '  RewriteCond %{REQUEST_FILENAME} !-f' >> /var/www/html/.htaccess \
    && echo '  RewriteRule ^(.*)$ index.php/$1 [QSA,PT,L]' >> /var/www/html/.htaccess \
    && echo '</IfModule>' >> /var/www/html/.htaccess

# 创建必要的目录
RUN mkdir -p /var/www/html/Runtime/Cache \
    && mkdir -p /var/www/html/Runtime/Logs \
    && mkdir -p /var/www/html/Runtime/Temp \
    && mkdir -p /var/www/html/Runtime/Data \
    && mkdir -p /var/www/html/Uploads/image

# 设置权限
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/Runtime \
    && chmod -R 777 /var/www/html/Uploads \
    && chmod -R 777 /var/www/html/Data

# PHP 配置
RUN echo "upload_max_filesize = 50M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 50M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_input_time = 600" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "default_socket_timeout = 600" >> /usr/local/etc/php/conf.d/uploads.ini

EXPOSE 8080

CMD ["apache2-foreground"]

