echo "
##
## ${PROJECT_NAME} Production
##

server {
    listen 80;
    server_name ${PROJECT_NAME}.salsitasoft.com;

    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name ${PROJECT_NAME}.salsitasoft.com;
    client_max_body_size 15M;

    ssl on;
    ssl_certificate /etc/ssl/private/salsitasoft_com.crt;
    ssl_certificate_key /etc/ssl/private/salsitasoft_com.key;

    ssl_session_timeout 5m;

    ssl_protocols SSLv3 TLSv1;
    ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv3:+EXP;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://${PROJECT_NAME}-prod/;

        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Real-IP \$remote_addr;

        access_log /var/log/nginx/${PROJECT_NAME}/production.access.log;
        error_log  /var/log/nginx/${PROJECT_NAME}/production.error.log;
    }
}
"
