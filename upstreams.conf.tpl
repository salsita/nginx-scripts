echo "
# ${PROJECT_NAME} -------------------------------------
upstream ${PROJECT_NAME}-develop {
    server ${DEPLOY_BOX}:`expr ${PORT_BASE}`;
}
upstream ${PROJECT_NAME}-qa {
    server ${DEPLOY_BOX}:`expr ${PORT_BASE} + 1`;
}
upstream ${PROJECT_NAME}-test {
    server ${DEPLOY_BOX}:`expr ${PORT_BASE} + 2`;
}
upstream ${PROJECT_NAME}-prod {
    server ${DEPLOY_BOX}:`expr ${PORT_BASE} + 3`;
}
upstream ${PROJECT_NAME}-try {
    server ${DEPLOY_BOX}:`expr ${PORT_BASE} + 4`;
} 
"
