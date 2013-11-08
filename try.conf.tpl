echo "
##
## ${PROJECT_NAME} Try
##

location /projects/${PROJECT_NAME}/ {
    proxy_pass http://${PROJECT_NAME}-try/;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;

    allow 192.168.23.0/24;
    deny  all;

    access_log /var/log/nginx/${PROJECT_NAME}/try.access.log;
    error_log  /var/log/nginx/${PROJECT_NAME}/try.error.log;
}
"
