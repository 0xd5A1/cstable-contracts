const LiquidityFarmingProxy = artifacts.require("LiquidityFarmingProxy");
const BStablePool = artifacts.require("BStablePool");

module.exports = function (deployer, network, accounts) {
	return LiquidityFarmingProxy.deployed().then(proxy => {
		return BStablePool.deployed().then(pool1 => {
			return proxy.add(pool1.address, 40, false);
		});
	});
};
