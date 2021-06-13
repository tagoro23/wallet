//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./Allowance.sol";



contract sharedWallet is Allowance{
    
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    
    function withdrawMoney (address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Not enough funds within the contract");
        if(owner() != msg.sender){
        reduceAllowance(_to, _amount);
    }
       emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    receive () external payable {
        emit MoneyReceived(msg.sender, msg.value);
        
    }
    
}
