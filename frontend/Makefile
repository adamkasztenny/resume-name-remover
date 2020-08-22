PROJECT="resume-name-remover-frontend"

.PHONY: build
build:
	docker build --no-cache -t ${PROJECT} .

start: build
	docker run -d -p 8081:80 ${PROJECT}

start_development: install
	yarn start

install:
	yarn install

test: install
	CI=true yarn test --coverage
