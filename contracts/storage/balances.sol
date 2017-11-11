pragma solidity ^0.4.4;

import '../utils/roles.sol';
import '../utils/utils.sol';

// this is actually the same as a custom token
// except that it is not ERC20 compatible
contract AdvertiserBalances is Role {

  mapping(address => uint) private balances;
  address[] private index;

  event LogUpdateBalance (address indexed advertiser, int updateAmount);

  function fundContract() payable isRole('Advertiser') {
		updateBalance(int(msg.value));
	}

  function payForDataUsage(address _from, uint amountToPay){
    _from.transfer(amountToPay);
  }

  function exists(address _from) public constant returns(bool isIndeed) {
    if (index.length == 0) {return false;}
    for(uint i=0; i<index.length; i++){
      if(index[i] == _from){return true;}
    }
    return false;
  }

  function getBalance(address _from) public constant returns (uint){
    if(!exists(_from)){
      return 0;
    }
    else {
      return balances[_from];
    }
  }

  function hasSufficientFunds(address _from, uint amountToCompare) returns (bool){
    return getBalance(_from) > amountToCompare;
  }

  //requires role verification so that only advertisers can fund the contract
  //the balance cannot be negative
  function updateBalance(int updateAmount){
    if(exists(tx.origin)){
      int newBalance = int(balances[tx.origin]) + updateAmount;
      if(newBalance > 0){
        balances[tx.origin] = uint(newBalance);
      }
    }
    LogUpdateBalance(tx.origin, updateAmount);
  }

  function count() public constant returns(uint) {
    return index.length;
  }
}
