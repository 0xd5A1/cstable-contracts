const PaymentFarmingProxy = artifacts.require("PaymentFarmingProxy");
const CSTMinter = artifacts.require("CSTMinter");

module.exports = function (deployer, network, accounts) {

    return CSTMinter.deployed().then(minter => {
        return PaymentFarmingProxy.deployed().then(payment => {
            return payment.setMinter(minter.address);
        });
    }).catch(e=>{
        console.error(e);
    });

};
