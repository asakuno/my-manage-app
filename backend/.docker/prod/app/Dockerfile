FROM 017868794361.dkr.ecr.ap-northeast-1.amazonaws.com/my-manage-app/base/app:2

COPY .docker/prod/app/php.ini /usr/local/etc/php/php.ini

COPY . /app

WORKDIR /app

RUN ls /app

COPY .docker/prod/app/www.conf.patch /usr/local/etc/php-fpm.d/www.conf.patch

RUN composer install

RUN chmod -R a+w /app/storage /app/bootstrap/cache