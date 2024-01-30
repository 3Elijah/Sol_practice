// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract Wallet is SharedWallet {
    
    event MoneyWithdrawn(address indexed _to, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function sendToContract(address _to) public payable {
        address payable to = payable(_to);
        to.transfer(msg.value);

        emit MoneyReceived(to, msg.value);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }    

    function withdrawMoney(uint _amount) public ownerOrWithinLimits(_amount) {
        require(_amount < address(this).balance, "Amount is greater than balance");

        if ( !isOwner()) {
            reduceFromLimit(_msgSender(), _amount);
        }

        payable(msg.sender).transfer(_amount);

        emit MoneyWithdrawn(msg.sender, _amount);
    }

    fallback() external payable{

    }

    receive() external payable {

        emit MoneyReceived(msg.sender, msg.value);

    }

}