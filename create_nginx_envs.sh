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
BACKUP_DIR='./backup'

echo "Creating backup dir in '${BACKUP_DIR}'..."
mkdir -p ${BACKUP_DIR}

echo "Appending to 'upstreams.conf'..."
cp ${NGINX_DIR}/conf.d/upstreams.conf ${BACKUP_DIR}/
. ./templates/upstreams.conf.tpl >>${NGINX_DIR}/conf.d/upstreams.conf

echo "Creating try env..."
mkdir -p ${NGINX_DIR}/sites-available/try_salsitasoft_com
. ./templates/try.conf.tpl >${NGINX_DIR}/sites-available/try_salsitasoft_com/${PROJECT_NAME}.conf

echo "Creating dev env..."
mkdir -p ${NGINX_DIR}/sites-available/develop_salsitasoft_com
. ./templates/dev.conf.tpl >${NGINX_DIR}/sites-available/develop_salsitasoft_com/${PROJECT_NAME}.conf

echo "Creating qa env..."
mkdir -p ${NGINX_DIR}/sites-available/qa_salsitasoft_com
. ./templates/qa.conf.tpl >${NGINX_DIR}/sites-available/qa_salsitasoft_com/${PROJECT_NAME}.conf

echo "Please input password for the client environment:"
htpasswd -c ${NGINX_DIR}/sites-available/${PROJECT_NAME}_salsitatest_com.htpasswd ${PROJECT_NAME}
. ./templates/client.conf.tpl >${NGINX_DIR}/sites-available/${PROJECT_NAME}_salsitatest_com.conf

. ./templates/prod.conf.tpl >${NGINX_DIR}/sites-available/${PROJECT_NAME}_salsitasoft_com.conf

echo "Enabling the sites..."

mkdir -p /var/log/nginx/${PROJECT_NAME}/
cd ${NGINX_DIR}/sites-available
/usr/sbin/nginx_ensite ${PROJECT_NAME}_salsitatest_com.conf
/usr/sbin/nginx_ensite ${PROJECT_NAME}_salsitasoft_com.conf

if ! nginx -t; then
  echo "Something went wrong! Please check the config files (or restore them from the backup)."
  exit 1
fi


echo "Reloading nginx config..."
service nginx reload

echo "All done."
