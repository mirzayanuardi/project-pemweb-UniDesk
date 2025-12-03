FROM serversideup/php:8.2-fpm-nginx

# 1. Set Limit Upload (Agar bisa upload foto besar)
ENV PHP_UPLOAD_MAX_FILESIZE=64M
ENV PHP_POST_MAX_SIZE=64M
ENV NGINX_CLIENT_MAX_BODY_SIZE=64M

# 2. Copy semua file project ke server
COPY . /var/www/html

# 3. Masuk mode Root untuk instalasi
USER root

# 4. Buat folder storage & cache secara manual
RUN mkdir -p /var/www/html/storage/framework/sessions \
    && mkdir -p /var/www/html/storage/framework/views \
    && mkdir -p /var/www/html/storage/framework/cache \
    && mkdir -p /var/www/html/bootstrap/cache

# 5. Install "Otak" Laravel (Composer)
RUN composer install --no-dev --no-interaction --optimize-autoloader

# 6. Berikan Izin Tulis (Permission) ke folder tersebut
# PERBAIKAN: Menggunakan user 'www-data' bukan 'webuser'
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache
RUN chown -R www-data:www-data /var/www/html

# 7. Kembali ke user biasa agar aman
USER www-data