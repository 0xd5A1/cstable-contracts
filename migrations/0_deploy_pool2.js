const CStablePool2 = artifacts.require("CStablePool2");
const TokenAUSD = artifacts.require("TokenAUSD");
const TokenCUSD = artifacts.require("TokenCUSD");
const TokenUSDT = artifacts.require("TokenUSDT");
const data = require('./conf');

module.exports = function (deployer, network, accounts) {
    let pArr = new Array();
    pArr.push(TokenAUSD.deployed());
    pArr.push(TokenCUSD.deployed());
    pArr.push(TokenUSDT.deployed());
    return Promise.all(pArr).then(tokens => {
        let qusdAddress = tokens[0].address;
        let busdAddress = tokens[1].address;
        let usdtAddress = tokens[2].address;
        let stableCoins = [qusdAddress, busdAddress, usdtAddress];
        let A = 100;
        let fee = "30000000"; // 0.003
        let adminFee = "6666666667"; // 2/3
        let name = "CStable Pool (CUSD / CUSD / USDT)";
        let symbol = "CSLP-02";
        return deployer.deploy(CStablePool2, name, symbol, stableCoins, A, fee, adminFee, accounts[0]).then(res => {
            console.log('constructor[0]:' + name);
            console.log('constructor[1]:' + symbol);
            console.log('constructor[2]:' + JSON.stringify(stableCoins));
            console.log('constructor[3]:' + A);
            console.log('constructor[4]:' + fee);
            console.log('constructor[5]:' + adminFee);
            console.log('constructor[6]:' + accounts[0]);
        }).catch(e=>{
            console.error(e);
        });
    });

};
