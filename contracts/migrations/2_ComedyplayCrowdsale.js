var SafeMath = artifacts.require("./SafeMath.sol");
var ComedyplayCrowdsale =  artifacts.require("./ComedyplayCrowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ComedyplayCrowdsale);
  deployer.deploy(ComedyplayCrowdsale,
    "0x5AEDA56215b167893e80B4fE645BA6d5Bab767DE", // TODO : Update this address
    "0x5AEDA56215b167893e80B4fE645BA6d5Bab767DE" // TODO : Update this address
    );
};
