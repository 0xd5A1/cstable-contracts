const PaymentFarmingProxy = artifacts.require("PaymentFarmingProxy");
const CStablePool = artifacts.require("CStablePool");

module.exports = function (deployer, network, accounts) {

    return CStablePool.deployed().then(pool => {
        return PaymentFarmingProxy.deployed().then(payment => {
            return payment.setPool(pool.address);
        });
    });

};
