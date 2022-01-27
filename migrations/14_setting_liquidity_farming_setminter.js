const LiquidityFarmingProxy = artifacts.require("LiquidityFarmingProxy");
const CSTMinter = artifacts.require("CSTMinter");

module.exports = function (deployer, network, accounts) {

    return CSTMinter.deployed().then(minter => {
        return LiquidityFarmingProxy.deployed().then(proxy => {
            return proxy.setMinter(minter.address);
        });
    });

};
