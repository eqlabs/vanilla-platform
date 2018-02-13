.PHONY: install test coverage coverage-explorer

install:
	docker-compose run --rm --service-ports install

test:
	docker-compose run --rm --service-ports test

coverage:
	docker-compose run --rm --service-ports coverage

coverage-explorer:
	docker-compose run --rm --service-ports coverage-explorer
