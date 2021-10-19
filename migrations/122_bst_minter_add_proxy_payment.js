const PaymentFarmingProxy = artifacts.require("PaymentFarmingProxy");
const CSTMinter = artifacts.require("CSTMinter");

module.exports = function (deployer, network, accounts) {

	return CSTMinter.deployed().then(bstMinter => {
		return PaymentFarmingProxy.deployed().then(payment => {
			return bstMinter.addProxy(payment.address);
		});
	});

};
