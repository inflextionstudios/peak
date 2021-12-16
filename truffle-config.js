const HDWalletProvider = require('@truffle/hdwallet-provider');

const { MNEMONIC, BSCSCAN_API_KEY, TESTNET_RPC_URL, TESTNET_CHAIN_ID, RPC_URL, CHAIN_ID } = require('./env.json');

module.exports = {
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    bscscan: BSCSCAN_API_KEY
  },
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    testnet: {
      provider: () => new HDWalletProvider(MNEMONIC, TESTNET_RPC_URL),
      network_id: TESTNET_CHAIN_ID,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bsc: {
      provider: () => new HDWalletProvider(MNEMONIC, RPC_URL),
      network_id: CHAIN_ID,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
  },
  mocha: {
    // timeout: 100000
  },
  compilers: {
    solc: {
      version: "0.8.10",   
      settings: {          
       optimizer: {
         enabled: false,
         runs: 200
       },
       evmVersion: "byzantium"
      }
    }
  },
};
