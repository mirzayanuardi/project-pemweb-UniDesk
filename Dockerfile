# Menggunakan base image yang sudah teroptimasi untuk Laravel
FROM serversideup/php:8.2-fpm-nginx

# Menyalin semua file project ke dalam server
COPY . /var/www/html

# Setting Permission agar Laravel bisa baca/tulis folder storage
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

# --- BAGIAN PENTING: MEMAKSA LIMIT UPLOAD ---
# Kita atur lewat Environment Variable khusus image ini
ENV PHP_UPLOAD_MAX_FILESIZE=64M
ENV PHP_POST_MAX_SIZE=64M
ENV NGINX_CLIENT_MAX_BODY_SIZE=64M

# Menjalankan server
CMD ["php-fpm"]