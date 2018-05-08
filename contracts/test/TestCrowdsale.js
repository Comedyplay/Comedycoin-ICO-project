var ComedyplayCrowdsale = artifacts.require("ThoriumCrowdsale");
var ComedyplayToken = artifacts.require("ThoriumToken");

contract('ComedyplayCrowdsale', function(accounts) {
    it('should deploy the token and store the address', function(done){
        ComedyplayCrowdsale.deployed().then(async function(instance) {
            const token = await instance.token.call();
            assert(token, 'Token address couldn\'t be stored');
            done();
       });
    });
});
