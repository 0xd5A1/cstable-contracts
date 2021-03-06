require('ts-node/register');
/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation and testing. Uncomment the ones you need or modify
 * them to suit your project as necessary.
 *
 * More information about configuration can be found at:
 *
 * truffleframework.com/docs/advanced/configuration
 *
 * To deploy via Infura you'll need a wallet provider (like @truffle/hdwallet-provider)
 * to sign your transactions before they're sent to a remote public node. Infura accounts
 * are available for free at: infura.io/register.
 *
 * You'll also need a mnemonic - the twelve word phrase the wallet uses to generate
 * public/private key pairs. If you're publishing your code to GitHub make sure you load this
 * phrase from a file you've .gitignored so it doesn't accidentally become public.
 *
 */

// const HDWalletProvider = require('@truffle/hdwallet-provider');
// const infuraKey = "fj4jll3k.....";
//
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();
const mnemonics = require('./secret.js');
const HDWalletProvider = require('@truffle/hdwallet-provider');;

module.exports = {
	/**
	 * Networks define how you connect to your ethereum client and let you set the
	 * defaults web3 uses to send transactions. If you don't specify one truffle
	 * will spin up a development blockchain for you on port 9545 when you
	 * run `develop` or `test`. You can ask a truffle command to use a specific
	 * network from the command line, e.g
	 *
	 * $ truffle test --network <network-name>
	 */

	networks: {
		// Useful for testing. The `development` name is special - truffle uses it by default
		// if it's defined here and no other network is specified at the command line.
		// You should run a client (like ganache-cli, geth or parity) in a separate terminal
		// tab if you use this network and you must also set the `host`, `port` and `network_id`
		// options below to some value.
		//
		dev: {
			host: "127.0.0.1",     // Localhost (default: none)
			port: 8545,            // Standard Ethereum port (default: none)
			network_id: "5777",       // Any network (default: none)
		},
		_test_dev: {
			host: "127.0.0.1",     // Localhost (default: none)
			port: 8545,            // Standard Ethereum port (default: none)
			network_id: "5777",       // Any network (default: none)
		},
		rinkeby: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://rinkeby.infura.io/v3/" + projectId),
			// provider: () => new HDWalletProvider(mnemonic, "https://api.infura.io/v1/jsonrpc/rinkeby"),
			network_id: 4,       // Rinkeby's id
			gas: 10000000,        // Rinkeby has a lower block limit than mainnet
			confirmations: 2,    // # of confs to wait between deployments. (default: 0)
			timeoutBlocks: 2000,  // # of blocks before a deployment times out  (minimum/default: 50)
			skipDryRun: true,    // Skip dry run before migrations? (default: false for public nets )
			gasPrice: 7000000000  // 7 gwei (in wei) (default: 100 gwei)
		},
		kovan: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://kovan.infura.io/v3/" + projectId),
			network_id: 42,
			gas: 10000000,
			confirmations: 2,
			timeoutBlocks: 2000,
			skipDryRun: true,
			gasPrice: 7000000000
		},
		kovan_skipMigrations: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://kovan.infura.io/v3/" + projectId),
			network_id: 42,
			gas: 10000000,
			confirmations: 2,
			timeoutBlocks: 2000,
			skipDryRun: true,
			gasPrice: 7000000000
		},
		kovan_oracle: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://kovan.infura.io/v3/" + projectId),
			network_id: 42,
			gas: 10000000,
			confirmations: 2,
			timeoutBlocks: 2000,
			skipDryRun: true,
			gasPrice: 7000000000
		},
		ethmainnet: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://mainnet.infura.io/v3/4d1446a24a744518a10686badaa1119d"),
			network_id: 1,       // Mainnet id
			chain_id: 1,
			gas: 1600000,        // Ropsten has a lower block limit than mainnet
			// confirmations: 2,    // # of confs to wait between deployments. (default: 0)
			// timeoutBlocks: 2000,  // # of blocks before a deployment times out  (minimum/default: 50)
			// skipDryRun: true,    // Skip dry run before migrations? (default: false for public nets )
			gasPrice: 90000000000  // 7 gwei (in wei) (default: 100 gwei)
		},
		bscmainnet: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://bsc-dataseed1.defibit.io/"),
			network_id: 56,
			chain_id: 56,
			gas: 3000000,
			skipDryRun: true,
		},
		bsctestnet: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://data-seed-prebsc-1-s2.binance.org:8545/"),
			network_id: 97,
			chain_id: 97,
			// gas: 3000000,
			// confirmations: 2,
			// timeoutBlocks: 2000,
			// skipDryRun: true,
			// gasPrice: 1800000000
		},
		// heco_test: {
		//     provider: () => new HDWalletProvider(mnemonics.deployer, "https://http-testnet.hecochain.com"),
		//     network_id: 256,
		//     chain_id: 256,
		//     // gas: 3000000,
		//     // confirmations: 2,
		//     // timeoutBlocks: 2000,
		//     // skipDryRun: true,
		//     // gasPrice: 1800000000
		// },
		hecomainnet: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://http-mainnet.hecochain.com"),
			network_id: 128,
			chain_id: 128,
			gas: 3000000,
			skipDryRun: true,
		},
		polygonmainnet: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://polygon-rpc.com/"),
			network_id: 137,
			chain_id: 137,
			// gas: 3000000,
			// skipDryRun: true,
		},
		celomainnet: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://forno.celo.org"),
			network_id: 42220,
			chain_id: 42220,
			// websockets: true,
			// networkCheckTimeout:10000,
			// gas: 3000000,
			// skipDryRun: true,
		},
		celotestnet: {
			provider: () => new HDWalletProvider(mnemonics.deployer, "https://alfajores-forno.celo-testnet.org"),
			network_id: 44787,
			chain_id: 44787,
			// gas: 3000000,
			// skipDryRun: true,
		},
		// Another network with more advanced options...
		// advanced: {
		// port: 8777,             // Custom port
		// network_id: 1342,       // Custom network
		// gas: 8500000,           // Gas sent with each transaction (default: ~6700000)
		// gasPrice: 20000000000,  // 20 gwei (in wei) (default: 100 gwei)
		// from: <address>,        // Account to send txs from (default: accounts[0])
		// websockets: true        // Enable EventEmitter interface for web3 (default: false)
		// },
		// Useful for deploying to a public network.
		// NB: It's important to wrap the provider as a function.
		// ropsten: {
		// provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/YOUR-PROJECT-ID`),
		// network_id: 3,       // Ropsten's id
		// gas: 5500000,        // Ropsten has a lower block limit than mainnet
		// confirmations: 2,    // # of confs to wait between deployments. (default: 0)
		// timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
		// skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
		// },
		// Useful for private networks
		// private: {
		// provider: () => new HDWalletProvider(mnemonic, `https://network.io`),
		// network_id: 2111,   // This network is yours, in the cloud.
		// production: true    // Treats this network as if it was a public net. (default: false)
		// }
	},

	// Set default mocha options here, use special reporters etc.
	mocha: {
		// timeout: 100000
	},

	// Configure your compilers
	compilers: {
		solc: {
			version: "0.8.0",    // Fetch exact version from solc-bin (default: truffle's version)
			// docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
			settings: {          // See the solidity docs for advice about optimization and evmVersion
				optimizer: {
					enabled: true,
					runs: 200
				},
				//    evmVersion: "byzantium"
			}
		},
	},
	plugins: [
		'truffle-plugin-verify'
	],
	api_keys: {
		etherscan: '7NY823AGXRY87HCW23NSCHFWX558IVQXME',
		bscscan: 'F7KWT15HDUBIWQA7ZDZSEIWYYYGKKRNIZT',
		hecoinfo: 'R31CJFM9QQPHK92BRHBJMC7ZT8GXAGVCFH',
		ftmscan: 'JGRW496M79HKVG62R4FBN5ZYJIYT9W66U8',
		polygonscan: '8H5IC1NVYRN7EQ12E1ZNXTST8NBYMNG6I8',
	}
};
