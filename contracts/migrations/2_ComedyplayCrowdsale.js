var SafeMath = artifacts.require("./SafeMath.sol");
var ComedyplayCrowdsale =  artifacts.require("./ComedyplayCrowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ComedyplayCrowdsale);
  deployer.deploy(ComedyplayCrowdsale,
    "0x264F93F128Ff7a1F5813E593A2F2d4db6a709De7", // TODO : Update this address
    "0x264F93F128Ff7a1F5813E593A2F2d4db6a709De7" // TODO : Update this address
    );
};
