PROJECT="resume-name-remover-backend"

install:
	bundle install

build:
	docker build --no-cache -t ${PROJECT} .

start: build
	docker run -d -p 9000:9000 ${PROJECT}

start_development: install
	rake start

test: install
	rake

lint:
	rubocop -a app spec
