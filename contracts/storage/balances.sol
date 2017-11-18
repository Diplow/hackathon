pragma solidity ^0.4.4;

import '../utils/utils.sol';


contract Balances {

  address owner;
  mapping(address => uint) private balances;
  address[] private index;

  function Balances() {
    owner = tx.origin;
  }

  function fund(uint value) isRole('ArtefHack') public {
    require(tx.origin == owner);
    create(tx.origin);
    updateBalance(tx.origin, value);
  }

  function create(address addr) isRole('ArtefHack') public {
    require(!exists(addr));
    balances[addr] = 0;
  }

  function pay(address from, address to, uint value) public returns (bool success) {
    if (exists(from) && balances[tx.origin] > value && exists(to)) {
      return false;
    }
    updateBalance(from, -value);
    updateBalance(to, value);
    return true;
  }

  function exists(address addr) private constant returns(bool exists) {
    for (uint i=0; i<index.length; i++) {
      if (index[i] == addr) { return true; }
    }
    return false;
  }

  function updateBalance(address addr, int updateAmount) private {
      balances[addr] = int(balances[addr]) + updateAmount;
  }
}
