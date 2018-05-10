pragma solidity ^0.4.17;

import './Ownable.sol';
import './SafeMath.sol';
import './MintableToken.sol';
import './WhiteListAccess.sol';
import './Crowdsale.sol';


contract ComedyplayCrowdsale is Ownable, WhiteListAccess, Crowdsale, MintableToken {
    using SafeMath for uint256;

    // TODO : Update the privatesaleStartTime
    // 2018-05-29 00:00:00 GMT - start time for private sale
    uint256 private constant privatesaleStartTime = 1525717871;

    // 2018-05-31 23:59:59 GMT - end time for private sale
    uint256 private constant privatesaleEndTime = 1527811199;

    // 2018-07-20 00:00:00 GMT - start time for pre sale
    uint256 private constant presaleStartTime = 1532044800;

    // 2018-08-20 23:59:59 GMT - end time for pre sale
    uint256 private constant presaleEndTime = 1534809599;

    // 2018-12-02 00:00:00 GMT - start time for main sale
    uint256 private constant mainsaleStartTime = 1543708800;

    // 2019-01-15 23:59:59 GMT - end time for main sale
    uint256 private constant mainsaleEndTime = 1516060799;

    // ===== Cap & Goal Management =====
    uint256 public constant privatesaleCap = 500 * (10 ** uint256(decimals));
    uint256 public constant presaleCap = 2000 * (10 ** uint256(decimals));
    uint256 public constant mainsaleCap = 7000 * (10 ** uint256(decimals));

    // ============= Token Distribution ================
    uint256 public constant INITIAL_SUPPLY = 700000000 * (10 ** uint256(decimals));
    uint256 public constant totalTokensForSale = 49000000 * (10 ** uint256(decimals));
    uint256 public constant tokensForTeam = 10500000 * (10 ** uint256(decimals));
    uint256 public constant tokensForReserve = 7000000 * (10 ** uint256(decimals));
    uint256 public constant tokensForBounty = 2100000 * (10 ** uint256(decimals));
    uint256 public constant tokenForPartnership = 1400000 * (10 ** uint256(decimals));

    // how many token units a buyer gets per wei
    uint256 public rate;
    mapping (address => uint256) public deposited;


    uint256 public countInvestor;

    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
    event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
    event Finalized();

    function ComedyplayCrowdsale(
      address _owner,
      address _wallet
      ) public Crowdsale(_wallet) {

        require(_wallet != address(0));
        require(_owner != address(0));
        owner = _owner;
        transfersEnabled = true;
        mintingFinished = false;
        totalSupply = INITIAL_SUPPLY;
        rate = 20000;
        bool resultMintForOwner = mintForOwner(owner);
        require(resultMintForOwner);
    }

    // fallback function can be used to buy tokens
    function() payable public {
        buyTokens(msg.sender);
    }

    // low level token purchase function
    function buyTokens(address _investor) public  payable returns (uint256){
        require(_investor != address(0));
        if (isPrivatesalePeriod()) {
          require(whitelist[msg.sender]);
        }
        require(validPurchase());
        uint256 weiAmount = msg.value;
        uint256 tokens = _getTokenAmount(weiAmount);
        if (tokens == 0) {revert();}

        // update state
        if (isPrivatesalePeriod()) {
          PrivatesaleWeiRaised = PrivatesaleWeiRaised.add(weiAmount);
        } else if (isPresalePeriod()) {
          PresaleWeiRaised = PresaleWeiRaised.add(weiAmount);
        } else if (isMainsalePeriod()) {
          mainsaleWeiRaised = mainsaleWeiRaised.add(weiAmount);
        }
        tokenAllocated = tokenAllocated.add(tokens);
        mint(_investor, tokens, owner);

        emit TokenPurchase(_investor, weiAmount, tokens);
        if (deposited[_investor] == 0) {
            countInvestor = countInvestor.add(1);
        }
        deposit(_investor);
        wallet.transfer(weiAmount);
        return tokens;
    }

    function _getTokenAmount(uint256 _weiAmount) internal view returns(uint256) {
      return _weiAmount.mul(rate);
    }

    // ====================== Price Management =================
    function setPrice() public onlyOwner {
      if (isPrivatesalePeriod()) {
        rate = 20000;
      } else if (isPresalePeriod()) {
        rate = 12500;
      } else if (isMainsalePeriod()) {
        rate = 5000;
      }
    }

    function isPrivatesalePeriod() public view returns (bool) {
      if (now >= privatesaleStartTime && now < privatesaleEndTime) {
        return true;
      }
      return false;
    }

    function isPresalePeriod() public view returns (bool) {
      if (now >= presaleStartTime && now < presaleEndTime) {
        return true;
      }
      return false;
    }

    function isMainsalePeriod() public view returns (bool) {
      if (now >= mainsaleStartTime && now < mainsaleEndTime) {
        return true;
      }
      return false;
    }

    function deposit(address investor) internal {
        deposited[investor] = deposited[investor].add(msg.value);
    }

    function mintForOwner(address _wallet) internal returns (bool result) {
        result = false;
        require(_wallet != address(0));
        balances[_wallet] = balances[_wallet].add(INITIAL_SUPPLY);
        result = true;
    }

    function getDeposited(address _investor) public view returns (uint256){
        return deposited[_investor];
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal view returns (bool) {
      bool withinCap =  true;
      if (isPrivatesalePeriod()) {
        withinCap = PrivatesaleWeiRaised.add(msg.value) <= privatesaleCap;
      } else if (isPresalePeriod()) {
        withinCap = PresaleWeiRaised.add(msg.value) <= presaleCap;
      } else if (isMainsalePeriod()) {
        withinCap = mainsaleWeiRaised.add(msg.value) <= mainsaleCap;
      }
      bool withinPeriod = isPrivatesalePeriod() || isPresalePeriod() || isMainsalePeriod();
      bool minimumContribution = msg.value >= 0.5 ether;
      return withinPeriod && minimumContribution && withinCap;
    }

    // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
    function finalize(
      address _teamFund,
      address _reserveFund,
      address _bountyFund,
      address _partnershipFund
      ) public onlyOwner returns (bool result) {
        require(_teamFund != address(0));
        require(_reserveFund != address(0));
        require(_bountyFund != address(0));
        require(_partnershipFund != address(0));
        require(now < mainsaleEndTime);
        result = false;
        mint(_teamFund, tokensForTeam, owner);
        mint(_reserveFund, tokensForReserve, owner);
        mint(_bountyFund, tokensForBounty, owner);
        mint(_partnershipFund, tokenForPartnership, owner);
        wallet.transfer(this.balance);
        finishMinting();
        emit Finalized();
        result = true;
    }

}
