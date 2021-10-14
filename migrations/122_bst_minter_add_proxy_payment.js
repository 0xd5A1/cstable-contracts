const PaymentFarmingProxy = artifacts.require("PaymentFarmingProxy");
const BSTMinter = artifacts.require("BSTMinter");

module.exports = function (deployer, network, accounts) {

	return BSTMinter.deployed().then(bstMinter => {
		return PaymentFarmingProxy.deployed().then(payment => {
			return bstMinter.addProxy(payment.address);
		});
	});

};
