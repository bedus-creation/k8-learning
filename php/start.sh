#!/bin/sh

# Start PHP-FPM in the background
service php8.3-fpm start

# Start NGINX in the foreground
nginx -g "daemon off;"
