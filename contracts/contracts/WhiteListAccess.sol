pragma solidity ^0.4.17;

import './Ownable.sol';

contract WhiteListAccess is Ownable {

    mapping (address => bool) whitelist;

    modifier onlyWhitelisted {require(whitelist[msg.sender]); _;}

    function addToWhiteList(address trusted) public onlyOwner() {
        whitelist[trusted] = true;
    }

    function removeFromWhiteList(address untrusted) public onlyOwner() {
        whitelist[untrusted] = false;
    }

}
