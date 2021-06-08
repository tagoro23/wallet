//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.1;

import "./Allowance.sol";
contract SharedWallet is Allowance{
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    
    function withdrawMoney(address payable _to, uint _amount) public onlyOwner ownerOrAllowed(_amount) {
         require(_amount <= address(this).balance, "Contract doesn't have enough money");
          if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
          }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    function renounceOwnership() public override onlyOwner {
        revert("can't renounceOwnership here"); //not possible with this smart contract
    }

    receive() external payable {
         emit MoneyReceived(msg.sender, msg.value);

    }
}
