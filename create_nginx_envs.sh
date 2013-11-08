#!/bin/bash

set -e
set -x

PROJECT_NAME=${1}
PORT_BASE=${2}
DEPLOY_BOX='192.168.23.129'

if [ -z ${PROJECT_NAME} ]; then
  echo "Must specify PROJECT_NAME (1st param).";
  exit 1;
fi;

if [ -z ${PORT_BASE} ]; then
  echo "Must specify PORT_BASE (2nd param).";
  exit 1;
fi;

NGINX_DIR='/etc/nginx'

. ./upstreams.conf.tpl >${NGINX_DIR}/conf.d/upstreams.conf

mkdir -p ${NGINX_DIR}/sites-available/try_salsitasoft_com
. ./try.conf.tpl >${NGINX_DIR}/sites-available/try_salsitasoft_com/${PROJECT_NAME}.conf

mkdir -p ${NGINX_DIR}/sites-available/develop_salsitasoft_com
. ./dev.conf.tpl >${NGINX_DIR}/sites-available/develop_salsitasoft_com/${PROJECT_NAME}.conf

mkdir -p ${NGINX_DIR}/sites-available/qa_salsitasoft_com
. ./qa.conf.tpl >${NGINX_DIR}/sites-available/qa_salsitasoft_com/${PROJECT_NAME}.conf

htpasswd -c ${NGINX_DIR}/sites-available/${PROJECT_NAME}_salsitatest_com.htpasswd ${PROJECT_NAME}
. ./client.conf.tpl >${NGINX_DIR}/sites-available/${PROJECT_NAME}_salsitatest_com.conf

. ./prod.conf.tpl >${NGINX_DIR}/sites-available/${PROJECT_NAME}_salsitasoft_com.conf

mkdir -p /var/log/nginx/${PROJECT_NAME}/
cd ${NGINX_DIR}/sites-available
/usr/sbin/nginx_ensite ${PROJECT_NAME}_salsitatest_com.conf
/usr/sbin/nginx_ensite ${PROJECT_NAME}_salsitasoft_com.conf

#cd ${NGINX_DIR}/sites-available
#/usr/sbin/nginx_dissite ${PROJECT_NAME}_salsitatest_com.conf
#/usr/sbin/nginx_dissite ${PROJECT_NAME}_salsitasoft_com.conf

service nginx reload
