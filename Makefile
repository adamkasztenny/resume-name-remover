build:
	docker-compose build --no-cache

start:
	docker-compose up -d --force-recreate --build
	
test:
	$(MAKE) -C frontend test
	$(MAKE) -C backend test
