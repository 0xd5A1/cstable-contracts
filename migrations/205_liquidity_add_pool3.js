const LiquidityFarmingProxy = artifacts.require("LiquidityFarmingProxy");
const CStablePool = artifacts.require("CStablePool");

module.exports = function (deployer, network, accounts) {
	return LiquidityFarmingProxy.deployed().then(proxy => {
		return CStablePool.deployed().then(pool1 => {
			return proxy.add(pool1.address, 40, false);
		});
	});
};
