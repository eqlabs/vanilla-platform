module.exports = {
  networks: {
    development: {
      host: "vanilla-rpc",
      port: 8545,
      network_id: "*"
    },
    test: {
      host: "test-rpc",
      port: 8545,
      network_id: "*"
    },
    // Duplicate, but required for the coverage tool to work
    coverage: {
      host: "test-rpc",
      port: 8545,
      network_id: "*"
    }
  }
};
