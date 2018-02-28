
install:
	docker-compose run --rm dev yarn install

explorer: start-rpc run-explorer

migrate: start-rpc run-migrations

stop: stop-rpc stop-explorer

rm: rm-rpc rm-explorer

clear: stop rm

test: start-test-rpc run-tests stop-test-rpc rm-test-rpc

coverage: start-test-rpc run-coverage stop-test-rpc rm-test-rpc

analysis:
	docker run -it --rm -v `pwd`/contracts:/contracts blackwatertepes/mythril bash

rpc-logs:
	docker logs vanilla-rpc

start-rpc:
	docker start vanilla-rpc \
	|| docker run -d -p 8545:8545 \
      --name vanilla-rpc \
      trufflesuite/ganache-cli:latest \
        --defaultBalanceEther 10000 \
        --mnemonic "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat" \
        --blocktime 5

stop-rpc:
	docker stop vanilla-rpc

rm-rpc:
	docker rm vanilla-rpc

start-test-rpc:
	docker run -d --name test-rpc trufflesuite/ganache-cli:latest

stop-test-rpc:
	docker kill test-rpc

rm-test-rpc:
	docker rm test-rpc

run-migrations:
	docker-compose run --rm dev-network yarn migrate-reset ; exit 0

run-explorer:
	docker build -t vanilla-eth-explorer -f docker/Dockerfile-eth-explorer docker \
    && docker run -d -p 8000:8000 --name vanilla-explorer vanilla-eth-explorer

stop-explorer:
	docker stop vanilla-explorer

rm-explorer:
	docker rm  vanilla-explorer

run-tests:
	docker-compose run --rm test-network yarn test ; exit 0

run-coverage:
	docker-compose run --rm test-network yarn coverage ; exit 0

docs:
	docker-compose run --rm dev-network yarn docs

servedocs:
	docker-compose run --rm --service-ports servedocs
