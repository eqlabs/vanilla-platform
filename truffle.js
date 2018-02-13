module.exports = {
  networks: {
    development: {
      host: "ganache-cli",
      port: 8545,
      network_id: "*"
    },
    // Duplicate, but required for the coverage tool to work
    coverage: {
      host: "ganache-cli",
      port: 8545,
      network_id: "*"
    }
  }
};
