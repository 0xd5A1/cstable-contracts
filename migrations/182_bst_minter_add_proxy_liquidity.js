const LiquidityFarmingProxy = artifacts.require("LiquidityFarmingProxy");
const BSTMinter = artifacts.require("BSTMinter");

module.exports = function (deployer, network, accounts) {

	return BSTMinter.deployed().then(bstMinter => {
		return LiquidityFarmingProxy.deployed().then(liquidity => {
			return bstMinter.addProxy(liquidity.address);
		});
	});

};
