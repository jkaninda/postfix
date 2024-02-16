IMAGE_NAME=jkaninda/postfix
CONTAINER_NAME=postfix

build:
	docker build -t ${IMAGE_NAME}:latest .

run: build
	docker compose up -d --force-recreate
stop:
	echo "Stoping ...."
	docker stop ${CONTAINER_NAME}
delete: stop
	docker rm ${CONTAINER_NAME}
	echo "Container deleted"

