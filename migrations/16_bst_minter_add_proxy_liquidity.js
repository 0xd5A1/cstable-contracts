const LiquidityFarmingProxy = artifacts.require("LiquidityFarmingProxy");
const CSTMinter = artifacts.require("CSTMinter");

module.exports = function (deployer, network, accounts) {

	return CSTMinter.deployed().then(bstMinter => {
		return LiquidityFarmingProxy.deployed().then(liquidity => {
			return bstMinter.addProxy(liquidity.address);
		});
	});

};
