.PHONY: install dev docs test coverage coverage-explorer

install:
	docker-compose run --rm --service-ports install

dev:
	docker-compose run --rm --service-ports dev

docs:
	docker-compose run --rm --service-ports docs

test:
	docker-compose run --rm --service-ports test && docker-compose down

coverage:
	docker-compose run --rm --service-ports coverage && docker-compose down

coverage-explorer:
	docker-compose run --rm --service-ports coverage-explorer
