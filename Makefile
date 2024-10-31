#!/usr/bin/env make

PASSWORD_ENV=${CURDIR}/password.env
-include ${PASSWORD_ENV}
export


${PASSWORD_ENV}:
	echo ROOT_PASSWORD=$(shell openssl rand -base64 12) > ${PASSWORD_ENV}
	$(MAKE)

.PHONY: build
build: ${PASSWORD_ENV}
	docker compose build --build-arg ROOT_PASSWORD=$${ROOT_PASSWORD}

.PHONY: deploy
deploy: build
	docker compose up -d

.PHONY: stop
stop:
	docker compose down

.PHONY: clean
clean: clean
	rm -rf $${PASSWORD_ENV}
	docker container prune -f

.PHONY: test
test: deploy
	docker exec -it ansible-control ansible-playbook playbooks/hello.yml -i localhost, && \
	$(MAKE) stop