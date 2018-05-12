// contract to be tested
var ComedyplayCrowdsale = artifacts.require("./ComedyplayCrowdsale");


// Test suite
contract('ComedyplayCrowdsale', function (accounts) {
    var contractInstance;
    var owner = accounts[0];
    var whitelistUser = accounts[1];

    // Test case: Total supply fo the tokens
    it("Total supply of the tokens", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.totalSupply();
        }).then(function (data) {
            assert.equal(web3.fromWei(data), 700000000, "Total supply of the tokens should be 700000000");
        });
    });

    // Test case: tokenAllocated fo the tokens
    it("tokenAllocated", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.tokenAllocated();
        }).then(function (data) {
            assert.equal(web3.fromWei(data), 0, "Total tokenAllocated should be 0");
        });
    });

    it("should contain 10000 MyToken in the creator balance", () => {
    return ComedyplayCrowdsale.deployed().then(instance => {
      return instance.balanceOf.call(owner);
    }).then(balance => {
      assert.equal(web3.fromWei(balance), 700000000, "700000000 wasn't in the creator balance");
    });
  });

    // Test case: check current rate of the tokens
    it("Current rate of the tokens", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.rate();
        }).then(function (data) {
            assert.equal(data.toNumber(), 20000, "Current rate of the tokens should be 20000");
        });
    });

    // Test case: private sale period
    it("private sale period", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.isPrivatesalePeriod();
        }).then(function (data) {
            assert.equal(data, true, "private sale period should be true");
        });
    });

    // Test case: private sale period
    it("pre sale period", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.isPresalePeriod();
        }).then(function (data) {
            assert.equal(data, false, "pre sale period should be false");
        });
    });

    // Test case: private sale period
    it("main sale period", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.isMainsalePeriod();
        }).then(function (data) {
            assert.equal(data, false, "main sale period should be false");
        });
    });

    // Test case: weiRaised in the private sale
    it("weiRaised in the private sale", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.PrivatesaleWeiRaised();
        }).then(function (data) {
            assert.equal(data.toNumber(), 0, "weiRaised in the private sale should be 0");
        });
    });

    // Test case: weiRaised in the pre sale
    it("weiRaised in the pre sale", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.PresaleWeiRaised();
        }).then(function (data) {
            assert.equal(data.toNumber(), 0, "weiRaised in the pre sale should be 0");
        });
    });

    // Test case: weiRaised in the main sale
    it("weiRaised in the main sale", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.mainsaleWeiRaised();
        }).then(function (data) {
            assert.equal(data.toNumber(), 0, "weiRaised in the main sale should be 0");
        });
    });

    // Test case: token allocated
    it("token allocated", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.tokenAllocated();
        }).then(function (data) {
            assert.equal(data.toNumber(), 0, "tokenAllocated should be 0");
        });
    });

    // Test case: Only whitlist user can purchase the token
    it("Only whitlist user can purchase the token", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;

            return contractInstance.sendTransaction({
                from: accounts[2],
                value: web3.toWei(1, "ether"),
                gas: 500000
            });
        }).then(assert.fail)
            .catch(function (error) {
                assert(error.message.indexOf('revert') >= 0, "error should be revert");
            });
    });

    // Test case: token allocated
    it("check user whitelist", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.isAddressWhiteList(whitelistUser);
        }).then(function (data) {
            assert.equal(data, false, "data");
        });
    });

    // Test case: token allocated
    it("add user on whitelist", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.addToWhiteList(whitelistUser,{
              from: owner
            });
        }).then(function (receipt) {
            assert.equal(receipt.logs[0].event, "UserWhitelist", "UserWhitelist");
            assert.equal(receipt.logs[0].args.user, true, "title must be ");
        });
    });

    // Test case: token allocated
    it("check user whitelist or not", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;
            return contractInstance.isAddressWhiteList(whitelistUser);
        }).then(function (data) {
            assert.equal(data, true, "data");
        });
    });

    // Test case: Only whitlist user can purchase the token
    it("after whitelisted purchse the tokens", function () {
        return ComedyplayCrowdsale.deployed().then(function (instance) {
            contractInstance = instance;

            return contractInstance.sendTransaction({
                from: accounts[1],
                value: web3.toWei(1, "ether")
            });
        }).then(function (receipt) {
            assert.equal(receipt.logs[0].event, "Mint", "UserWhitelist");
            assert.equal(receipt.logs[0].args.to, whitelistUser, "title must be ");
        });
    });

    it("should contain 20000 CCP in the invester balance", () => {
    return ComedyplayCrowdsale.deployed().then(instance => {
      return instance.balanceOf.call(whitelistUser);
    }).then(balance => {
      assert.equal(web3.fromWei(balance), 20000, "20000 wasn't in the  balance");
    });
  });



});
