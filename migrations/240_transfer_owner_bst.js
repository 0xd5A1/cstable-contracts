const CSTToken = artifacts.require("CSTToken");
const data = require('./conf');

module.exports = function (deployer, network, accounts) {
    let config = data[deployer.network_id];
    let _owner = config.owner;
    return CSTToken.deployed().then(bst => {
        bst.transferOwnership(_owner);
    });

};
