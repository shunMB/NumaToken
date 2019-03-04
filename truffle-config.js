require('dotenv').config();
const HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    //For development with ex. Ganache
    /*
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*", // Match any network id
      gas: 5000000
    }
    */
    // For ropsten execution
    ropsten: {
      provider: function() {
        return new HDWalletProvider(
          process.env.ROPSTEN_MNEMONIC,
          "https://ropsten.infura.io/" + process.env.INFURA_ACCESS_TOKEN
        );
      },
      network_id: 3,
      gas: 7000000
    }
  },
  compilers: {
    solc: {
      settings: {
        optimizer: {
          enabled: true, // Default: false
          runs: 200      // Default: 200
        },
      }
    }
  }
};
