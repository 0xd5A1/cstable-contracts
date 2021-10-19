const CSTToken = artifacts.require("CSTToken");
const CSTMinter = artifacts.require("CSTMinter");
const data = require('./conf');

module.exports = function (deployer, network, accounts) {
    let config = data[deployer.network_id];
    return CSTMinter.deployed().then(minter => {
        return CSTToken.deployed().then(bst => {
            return minter.setToken(bst.address);
        });
    }).catch(e=>{
        console.error(e);
    });
};
