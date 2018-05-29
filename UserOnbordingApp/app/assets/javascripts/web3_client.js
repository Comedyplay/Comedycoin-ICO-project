Web3Client={
  default: {
    httpProvider: "https://ropsten.infura.io/",
    contractAddress: ComedyplayContractAddress,
    contractABI: ComedyplayContractABI,
    web3_obj: null,
    contract_obj: null,
    totalPayments: null,
    lastPayments: null
  },

  client: function() {
    this.default.web3_obj = new Web3(new Web3.providers.HttpProvider(Web3Client.default.httpProvider));
    return this.default.web3_obj;
  },

  contract:function() {
    this.default.contract_obj = this.client().eth.contract(this.default.contractABI).at(this.default.contractAddress);
    return this.default.contract_obj;
  }, 

  totalTokenSale: function(token_sale_container) {
    this.contract().tokenAllocated(function (error, result) {
      document.getElementById(token_sale_container).innerHTML = result.c[0];
    });
  },

  paymentLog: function(){
    this.contract().getPaymentCount(function (error, result) {
      Web3Client.default.totalPayments = result.c[0];
      console.log(Web3Client.default.totalPayments);
      if (Web3Client.default.totalPayments > Web3Client.default.lastPayments) {
        for (var i = Web3Client.default.lastPayments; i <= Web3Client.default.totalPayments; i++) {
          Web3Client.getPayment(i);
        }
        Web3Client.default.lastPayments = Web3Client.default.totalPayments;
      }
    })
  },

  getPayment: function getPayment(paymentNumber){
    this.contract().payments(paymentNumber, function (error, result) {
      console.log(result);
    })
  }
}

$(document).ready(function(){
  Web3Client.totalTokenSale("token-sale");
  setInterval(Web3Client.paymentLog(), 10000);
  
});
