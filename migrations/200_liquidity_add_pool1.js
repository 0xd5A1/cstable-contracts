const LiquidityFarmingProxy = artifacts.require("LiquidityFarmingProxy");
const BStablePool1 = artifacts.require("BStablePool1");
const data = require('./conf');

module.exports = function (deployer, network, accounts) {
	let config = data[deployer.network_id];

	return LiquidityFarmingProxy.deployed().then(proxy => {
		return BStablePool1.deployed().then(pool1 => {
			return proxy.add(pool1.address, 10, false);
		}).catch(e => {
			return proxy.add(config.pool1, 10, false);
		});
	});

};
