# Use an official PHP image as the base image
FROM php:7.4-fpm

# Set the working directory
WORKDIR /app

# Install PHP extensions and necessary packages
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    git \
    unzip

RUN docker-php-ext-install pdo pdo_mysql bcmath

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy Pterodactyl.io Panel code into the container
COPY . /app

# Copy nginx.conf from the build context to the container
COPY nginx.conf /etc/nginx/sites-available/default

# Expose ports
EXPOSE 80
EXPOSE 443


# Environment variables
ENV MYSQL_DATABASE=panel
ENV MYSQL_USER=pterodactyl
ENV MYSQL_PASSWORD=CHANGE_ME
ENV APP_URL=http://example.com
ENV APP_TIMEZONE=UTC
ENV APP_SERVICE_AUTHOR=noreply@example.com
ENV MAIL_FROM=noreply@example.com
ENV MAIL_DRIVER=smtp
ENV MAIL_HOST=mail
ENV MAIL_PORT=1025
ENV MAIL_USERNAME=
ENV MAIL_PASSWORD=
ENV MAIL_ENCRYPTION=true
ENV DB_PASSWORD=$MYSQL_PASSWORD
ENV APP_ENV=production
ENV APP_ENVIRONMENT_ONLY=false
ENV CACHE_DRIVER=redis
ENV SESSION_DRIVER=redis
ENV QUEUE_DRIVER=redis
ENV REDIS_HOST=cache
ENV DB_HOST=database
ENV DB_PORT=3306

# Start Nginx and PHP-FPM
CMD service nginx start && php-fpm
