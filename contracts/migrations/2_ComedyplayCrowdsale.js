var SafeMath = artifacts.require("./SafeMath.sol");
var ComedyplayToken =  artifacts.require("./ComedyplayToken.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ComedyplayToken);
  deployer.deploy(ComedyplayToken);
};
