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

});
