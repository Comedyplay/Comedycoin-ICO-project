var SafeMath = artifacts.require("./SafeMath.sol");
var ComedyplayCrowdsale =  artifacts.require("./ComedyplayCrowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ComedyplayCrowdsale);
  deployer.deploy(ComedyplayCrowdsale,
    "0x61A44075419C4402f6DE631341d875Ece6A3922e", // TODO : Update this address
    "0x61A44075419C4402f6DE631341d875Ece6A3922e" // TODO : Update this address
    );
};
