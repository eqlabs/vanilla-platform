![Vanilla Logo](vanilla.png)
# Vanilla-Platform

Solidity smart contracts handling trustless derivatives on the Ethereum blockchain.

We recently published [a blog post](https://medium.com/equilibrium-labs/introducing-vanilla-6f86a8de9a25) describing Vanilla on a higher level. Or, if you're more into deep dives, check the documentation:

### [Documentation](https://eqlabs.github.io/vanilla-platform)

## Local ethereum network with explorer

    make install
    make explorer

This will run the `start-rpc` and the `start-explorer` make commands. The explorer is available at http://localhost:8000

The accounts and corresponding keys generated are listed in [test-accounts.md](test-accounts.md)

To view logs of the rpc run:

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
