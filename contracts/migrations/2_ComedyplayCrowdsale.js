var SafeMath = artifacts.require("./SafeMath.sol");
var ComedyplayToken =  artifacts.require("./ComedyplayToken.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ComedyplayToken);
  deployer.deploy(ComedyplayToken,
    "0x5AEDA56215b167893e80B4fE645BA6d5Bab767DE", // TODO : Update this address
    "0x5AEDA56215b167893e80B4fE645BA6d5Bab767DE" // TODO : Update this address
    );
};
