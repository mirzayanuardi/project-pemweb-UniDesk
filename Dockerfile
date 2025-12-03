FROM serversideup/php:8.2-fpm-nginx

# 1. Set Limit Upload
ENV PHP_UPLOAD_MAX_FILESIZE=64M
ENV PHP_POST_MAX_SIZE=64M
ENV NGINX_CLIENT_MAX_BODY_SIZE=64M

# 2. Copy file project
COPY . /var/www/html

# 3. Masuk mode Root
USER root

# 4. Buat struktur folder storage secara manual
RUN mkdir -p /var/www/html/storage/framework/sessions \
    && mkdir -p /var/www/html/storage/framework/views \
    && mkdir -p /var/www/html/storage/framework/cache \
    && mkdir -p /var/www/html/storage/app/public \
    && mkdir -p /var/www/html/public/bukti_laporan \
    && mkdir -p /var/www/html/bootstrap/cache

# 5. Install Dependency
RUN composer install --no-dev --no-interaction --optimize-autoloader

# 6. --- PERBAIKAN UTAMA: BUAT SYMLINK SAAT BUILD ---
# Kita paksa buat symlink di sini agar selalu ada
RUN php artisan storage:link

# 7. Atur Izin (Permissions) - Pastikan www-data bisa tulis
RUN chmod -R 777 /var/www/html/storage \
    && chmod -R 777 /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html

# 8. Kembali ke user web server
USER www-data