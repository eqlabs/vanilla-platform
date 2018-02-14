.PHONY: install dev test coverage coverage-explorer

install:
	docker-compose run --rm --service-ports install

dev:
	docker-compose run --rm --service-ports dev

test:
	docker-compose run --rm --service-ports test && docker-compose down

coverage:
	docker-compose run --rm --service-ports coverage && docker-compose down

coverage-explorer:
	docker-compose run --rm --service-ports coverage-explorer
