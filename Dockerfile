# Menggunakan base image khusus Laravel yang stabil
FROM serversideup/php:8.2-fpm-nginx

# --- BAGIAN 1: KONFIGURASI UPLOAD ---
# Kita paksa server menuruti aturan limit 64MB lewat variabel ini
ENV PHP_UPLOAD_MAX_FILESIZE=64M
ENV PHP_POST_MAX_SIZE=64M
ENV NGINX_CLIENT_MAX_BODY_SIZE=64M

# --- BAGIAN 2: COPY FILE ---
# Menyalin kodingan dari GitHub ke dalam server
COPY . /var/www/html

# Masuk sebagai root (admin) sebentar untuk instalasi
USER root

# --- BAGIAN 3: INSTALL DEPENDENCY (PENTING!) ---
# Ini langkah yang kemarin kurang. Kita install "isi otak" Laravel.
RUN composer install --no-dev --no-interaction --optimize-autoloader

# --- BAGIAN 4: PERIZINAN FOLDER ---
# Membuka izin folder storage agar bisa upload gambar
RUN chmod -R 777 storage bootstrap/cache
# Memastikan pemilik file benar
RUN chown -R webuser:webgroup /var/www/html

# Kembali menjadi user biasa agar aman
USER webuser