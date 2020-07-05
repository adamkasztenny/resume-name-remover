build:
	docker-compose build --no-cache

start:
	docker-compose up -d --force-recreate --build
	
test:
	cd ./frontend && $(MAKE) test
	cd ./backend && $(MAKE) test
