// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SharedWallet is Ownable(msg.sender) {

    mapping (address => uint) public members;

    function addLimit(address _member, uint _limit) public onlyOwner {
        members[_member] = _limit;

    }

    function isOwner() internal view returns (bool) {
        return owner() == _msgSender();
    }

    modifier ownerOrWithinLimits(uint _amount) {
        require(isOwner() || members[_msgSender()] >= _amount, "You are not allowed to do it");
        _;
    }

    function reduceFromLimit(address _member, uint _amount) internal {
        members[_member] -= _amount;
    }

    function renounceOwnership() override public view onlyOwner {
        revert("Can`t renounce");
    }
}