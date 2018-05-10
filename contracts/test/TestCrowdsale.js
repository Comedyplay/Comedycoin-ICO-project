var ComedyplayToken = artifacts.require("ComedyplayToken");

contract('ComedyplayToken', function(accounts) {
  it('should deploy the token and store the address', function(done){
        ComedyplayToken.deployed().then(async function(instance) {
            assert(instance, 'Token address couldn\'t be stored');
            done();
       });
    });

  it('one ETH should buy 20000 Comedyplay Tokens in Privatesale', function(done){
      ComedyplayToken.deployed().then(async function(instance) {
          const data = await instance.sendTransaction({ from: accounts[7], value: web3.toWei(1, "ether")});
          const comedyplayToken = ComedyplayToken.at(instance);
          const tokenAmount = await comedyplayToken.balanceOf(accounts[7]);
          assert.equal(tokenAmount.toNumber(), 20000000000000000000000, 'The sender didn\'t receive the tokens as per Privatesale rate');
          done();
     });
  });

  it('should transfer the ETH to wallet immediately', function(done){
        ComedyplayToken.deployed().then(async function(instance) {
            let balanceOfBeneficiary = await web3.eth.getBalance(accounts[9]);
            balanceOfBeneficiary = Number(balanceOfBeneficiary.toString(10));

            await instance.sendTransaction({ from: accounts[1], value: web3.toWei(1, "ether")});

            let newBalanceOfBeneficiary = await web3.eth.getBalance(accounts[9]);
            newBalanceOfBeneficiary = Number(newBalanceOfBeneficiary.toString(10));

            assert.equal(newBalanceOfBeneficiary, balanceOfBeneficiary + 20000000000000000000000, 'ETH couldn\'t be transferred to the beneficiary');
            done();
       });
    });

});
