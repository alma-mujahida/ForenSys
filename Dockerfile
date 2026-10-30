# ============================================================
# Dockerfile ForenSys - multi-stage build (3 tahap)
# ============================================================

# ---------- Tahap 1: build aset frontend (Vite + Tailwind) ----------
FROM node:22-alpine AS assets
WORKDIR /build
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# ---------- Tahap 2: pasang library PHP (Composer) ----------
FROM composer:2 AS vendor
WORKDIR /build
COPY composer.json composer.lock ./
RUN composer install \
    --no-dev \
    --prefer-dist \
    --no-interaction \
    --no-scripts \
    --ignore-platform-reqs
COPY . .
RUN composer dump-autoload --optimize --no-dev --no-scripts

# ---------- Tahap 3: image akhir (Nginx + PHP-FPM) ----------
FROM serversideup/php:8.4-fpm-nginx AS runtime
WORKDIR /var/www/html

# Source code aplikasi
COPY --chown=www-data:www-data . .
# Hasil tahap 1 dan 2 (Node.js dan Composer tidak ikut masuk image akhir)
COPY --chown=www-data:www-data --from=vendor /build/vendor ./vendor
COPY --chown=www-data:www-data --from=assets /build/public/build ./public/build

# Image ini mendengarkan HTTP di port 8080 (non-root)
EXPOSE 8080
