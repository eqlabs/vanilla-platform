# Vanilla-Platform

A bunch of Solidity smart contracts handling trustless derivatives on the Ethereum blockchain.

## Local ethereum network with explorer

    make install
    make explorer

This will run the `start-rpc` and the `start-explorer` make commands.The explorer is available at http://localhost:8000

To view available addresses and such run:

    make rpc-logs

To **deploy** the contracts from this project run:

    make migrate

The command will run a `migrate --reset` so everything will be migrated from the beginning.

To **stop** the network and explorer run:

    make stop

The network is persistent. To **reset** everything run:

    make clear

## Some commands

### Installing

```bash
make install
```

OR

```bash
yarn install
```

### Running tests

```bash
make test
```

OR

```bash
yarn test
```

### Generating documentation

```bash
yarn docs
```

You need to have solc installed in your PATH to do this.

### Browse documentation

Either open ./docs/index.html with your browser, or:

```bash
make servedocs
```

### Checking test coverage (IS BROKEN)

```bash
make coverage
```

### Exploring the generated Istanbul coverage documentation

```bash
make coverage-explorer
```

And visit `localhost:8080` with your browser.
