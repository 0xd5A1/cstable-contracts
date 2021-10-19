const LiquidityFarmingProxy = artifacts.require("LiquidityFarmingProxy");
const CSTToken = artifacts.require("CSTToken");

module.exports = function (deployer, network, accounts) {

    return CSTToken.deployed().then(bst => {
        return LiquidityFarmingProxy.deployed().then(proxy => {
            return proxy.setToken(bst.address);
        });
    });

};
