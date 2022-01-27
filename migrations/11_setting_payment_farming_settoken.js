const PaymentFarmingProxy = artifacts.require("PaymentFarmingProxy");
const CSTToken = artifacts.require("CSTToken");

module.exports = function (deployer, network, accounts) {

    return CSTToken.deployed().then(bst => {
        return PaymentFarmingProxy.deployed().then(payment => {
            return payment.setToken(bst.address);
        });
    });

};
