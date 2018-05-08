pragma solidity ^0.4.17;

import './Ownable.sol';
import './SafeMath.sol';
import './MintableToken.sol';
import './WhiteListAccess.sol';

contract ComedyplayToken is Ownable, MintableToken, WhiteListAccess {
  using SafeMath for uint256;

  string public constant name = "ComedyplayToken";
  string public constant symbol = "CCP";
  uint256 public constant decimals = 18;

  // 2018-05-29 00:00:00 GMT - start time for private sale
  uint256 private constant privatesaleStartTime = 1527552000;

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


  // ============= Token Distribution ================
  uint256 public maxTokens = 700000000 * 1 ether;
  uint256 public totalTokensForSale = 49000000 * 1 ether;
  uint256 public tokensForTeam = 10500000 * 1 ether;
  uint256 public tokensForReserve = 7000000 * 1 ether;
  uint256 public tokensForBounty = 2100000 * 1 ether;
  uint256 public tokenForPartnership = 1400000 * 1 ether;

  // The token being sold
  MintableToken public token;

  // address where funds are collected
  address public wallet;

  // how many token units a buyer gets per wei
  uint256 public rate;

  // amount of raised money in wei
  uint256 public PrivatesaleWeiRaised;
  uint256 public PresaleWeiRaised;
  uint256 public mainsaleWeiRaised;

  // ===== Cap & Goal Management =====
  uint256 public privatesaleCap;
  uint256 public privatesaleGoal;
  uint256 public presaleCap;
  uint256 public presaleGoal;
  uint256 public mainsaleCap;
  uint256 public mainsaleGoal;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(
    address indexed purchaser,
    address indexed beneficiary,
    uint256 value,
    uint256 amount
    );

  // ===== Constructor =====
  function ComedyplayToken() public {
    rate = 20000;
    wallet = msg.sender;
    privatesaleCap = 500 * 1 ether;
    privatesaleGoal = 200 * 1 ether;
    presaleCap = 2000 * 1 ether;
    presaleGoal = 700 * 1 ether;
    mainsaleCap = 7000 * 1 ether;
    mainsaleGoal = 3000 * 1 ether;
  }


  // ====================== Price Management =================
  function setPrice() public onlyOwner {
    if (isPrivatesalePeriod()) {
      setCurrentRate(20000);
    } else if (isPresalePeriod()) {
      setCurrentRate(12500);
    } else if (isMainsalePeriod()) {
      setCurrentRate(5000);
    }
  }

  // Change the current rate
  function setCurrentRate(uint256 _rate) private onlyOwner {
      rate = _rate;
  }

  // ====== Token Purchase ===============
  function () external payable {
    uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
    require(totalSupply_ + tokensThatWillBeMintedAfterPurchase < totalTokensForSale);
    buyTokens(msg.sender);
  }

  function buyTokens(address _beneficiary) public payable {
    require(msg.sender != address(0));
    require(validPurchase());
    if (isPrivatesalePeriod()) {
      require(whitelist[msg.sender]);
    }

    uint256 weiAmount = msg.value;

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);

    // update state
    if (isPrivatesalePeriod()) {
      PrivatesaleWeiRaised = PrivatesaleWeiRaised.add(weiAmount);
    } else if (isPresalePeriod()) {
      PresaleWeiRaised = PresaleWeiRaised.add(weiAmount);
    } else if (isMainsalePeriod()) {
      mainsaleWeiRaised = mainsaleWeiRaised.add(weiAmount);
    }

    emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
    mint(_beneficiary, tokens);

    _forwardFunds();
  }

  function _getTokenAmount(uint256 _weiAmount) internal view returns(uint256) {
    return _weiAmount.mul(rate);
  }

  function _forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  function isPrivatesalePeriod() public view returns (bool) {
    if (now >= privatesaleStartTime && now < privatesaleEndTime) {
      return true;
    }
    return false;
  }

  function isPresalePeriod() public view returns(bool) {
    if (now >= presaleStartTime && now < presaleEndTime) {
      return true;
    }
    return false;
  }

  function isMainsalePeriod() public view returns(bool) {
    if (now >= mainsaleStartTime && now < mainsaleEndTime) {
      return true;
    }
    return false;
  }

  // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
  function finish(
    address _teamFund,
    address _reserveFund,
    address _bountyFund,
    address _partnershipFund
    ) public onlyOwner {
    require(_teamFund != address(0));
    require(_reserveFund != address(0));
    require(_bountyFund != address(0));
    require(_partnershipFund != address(0));
    require(now < mainsaleEndTime);

    uint256 alreadyMinted = token.totalSupply();
    require(alreadyMinted < maxTokens);

    uint256 unsoldTokens = totalTokensForSale.sub(alreadyMinted);
    if (unsoldTokens > 0) {
      tokensForReserve = tokensForReserve.add(unsoldTokens);
    }

    mint(_teamFund, tokensForTeam);
    mint(_reserveFund, tokensForReserve);
    mint(_bountyFund, tokensForBounty);
    mint(_partnershipFund, tokenForPartnership);
    finishMinting();
  }

  // @return true if the transaction can buy tokens
  function validPurchase() internal view returns (bool) {
    bool withinCap;
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

}
