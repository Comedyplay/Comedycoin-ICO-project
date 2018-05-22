pragma solidity ^0.4.17;

import './Ownable.sol';

contract WhiteListAccess is Ownable {

    mapping (address => bool) whitelist;
    modifier onlyWhitelisted {require(whitelist[msg.sender]); _;}

    function isAddressWhiteList(address _address) public view returns (bool) {
        return whitelist[_address];
    }

    /**
   * @dev Adds single address to whitelist.
   * @param trusted Address to be added to the whitelist
   */
    function addToWhiteList(address trusted) external onlyOwner {
        whitelist[trusted] = true;
    }

    /**
   * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
   * @param _beneficiaries Addresses to be added to the whitelist
   */
    function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
      for (uint256 i = 0; i < _beneficiaries.length; i++) {
        whitelist[_beneficiaries[i]] = true;
      }
    }

    /**
   * @dev Removes single address from whitelist.
   * @param untrusted Address to be removed to the whitelist
   */
    function removeFromWhiteList(address untrusted) external onlyOwner {
        require(whitelist[untrusted]);
        whitelist[untrusted] = false;
    }

}
