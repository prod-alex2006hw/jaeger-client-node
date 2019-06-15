PROJECT=crossdock
DOCKER_COMPOSE_VERSION=1.23.1
JAEGER_COMPOSE_URL=./jaeger-docker-compose.yml
XDOCK_JAEGER_YAML=${PROJECT}/jaeger-docker-compose.yml
XDOCK_YAML=${PROJECT}/docker-compose.yml

crossdock() {
    install_node_modules 
    crossdock-download-jaeger
	docker-compose -f ${XDOCK_YAML} -f ${XDOCK_JAEGER_YAML} kill node
	docker-compose -f ${XDOCK_YAML} -f ${XDOCK_JAEGER_YAML} rm -f node
	docker-compose -f ${XDOCK_YAML} -f ${XDOCK_JAEGER_YAML} build node
	docker-compose -f ${XDOCK_YAML} -f ${XDOCK_JAEGER_YAML} run crossdock
} 

crossdock-fresh() {
    install_node_modules 
    crossdock-download-jaeger
	docker-compose -f ${XDOCK_YAML} -f ${XDOCK_JAEGER_YAML} kill
	docker-compose -f ${XDOCK_YAML} -f ${XDOCK_JAEGER_YAML} rm --force
	docker-compose -f ${XDOCK_YAML} -f ${XDOCK_JAEGER_YAML} pull
	docker-compose -f ${XDOCK_YAML} -f ${XDOCK_JAEGER_YAML} build --no-cache
	docker-compose -f ${XDOCK_YAML} -f ${XDOCK_JAEGER_YAML} run crossdock
}

crossdock-logs() {
    crossdock-download-jaeger
	docker-compose -f ${XDOCK_YAML} -f ${XDOCK_JAEGER_YAML} logs
}

install_node_modules() {
	npm install
	npm uninstall tchannel
}

installDockercompose() {
	echo "Installing docker-compose $${DOCKER_COMPOSE_VERSION:?'DOCKER_COMPOSE_VERSION env not set'}"
	sudo rm -f /usr/local/bin/docker-compose
	curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
	chmod +x docker-compose
	sudo mv docker-compose /usr/local/bin
	/usr/local/bin/docker-compose version
}

crossdock-download-jaeger() {
	curl -o ${XDOCK_JAEGER_YAML} ${JAEGER_COMPOSE_URL}
	docker pull jaegertracing/jaeger-query
}
build() {
    docker-compose build
}
##########
build
##########
exit 0
