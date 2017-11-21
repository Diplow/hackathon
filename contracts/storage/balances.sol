pragma solidity ^0.4.4;

import '../utils/utils.sol';


contract Balances {

  address owner;
  mapping(address => int) public balances;
  address[] index;

  function Balances() {
    owner = tx.origin;
  }

  function fund(int value) public {
    require(tx.origin == owner);
    updateBalance(tx.origin, value);
  }

  function create(address addr) public {
    require(!exists(addr));
    index.push(addr);
    balances[addr] = 0;
  }

  function pay(address from, address to, int value) public returns (bool success) {
    if (!(exists(from) && balances[from] > value && exists(to))) {
      return false;
    }
    updateBalance(from, -value);
    updateBalance(to, value);

    return true;
  }

  function exists(address addr) constant returns(bool) {
    for (uint i=0; i<index.length; i++) {
      if (index[i] == addr) { return true; }
    }
    return false;
  }

  function getBalance(address addr) returns(int) {
    return balances[addr];
  }

  function updateBalance(address addr, int updateAmount) private {
      balances[addr] = int(balances[addr]) + updateAmount;
  }
}
