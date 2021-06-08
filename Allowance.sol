//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    
    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);
    
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }
    
    mapping(address => uint) public allowance;

    function setAllowance(address _recipient, uint _amount) public onlyOwner {
        emit AllowanceChanged(_recipient, msg.sender, allowance[_recipient], _amount);
        allowance[_recipient] = _amount;
    }

    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "Transaction failed, you are not authorized!");
        _;
    }
    
    function reduceAllowance(address _recipient, uint _amount) internal ownerOrAllowed(_amount) {
        emit AllowanceChanged(_recipient, msg.sender, allowance[_recipient], allowance[_recipient] - _amount);
        allowance[_recipient] -= _amount;
    }
}
