pragma solidity ^0.4.4;

import '../utils/utils.sol';


contract Users {

  struct User {
    uint preference;
    bool message;
    uint idx;
  }

  mapping(address => User) private users;
  address[] private index;

  function exists(address addr) public constant returns(bool) {
  	return (index.length > 0 && index[users[addr].idx] == addr);
  }

  function insert(address addr, uint preference, bool message) public returns(uint idx) {
    require(!this.exists(addr));

    users[addr].preference = preference;
    users[addr].message = message;
    users[addr].idx = index.push(addr)-1;

    return index.length-1;
  }

  function get(address addr) public constant returns(uint preference, bool message, uint idx) {
    require(exists(addr));

    return(
      users[addr].preference,
      users[addr].message,
      users[addr].idx
    );
  }

  function remove(address addr) public returns (bool success) {
    require(exists(addr));
    uint indexToDelete = users[addr].idx;
    address addressToMove   = index[index.length-1];
    index[indexToDelete] = addressToMove;
    users[addressToMove].idx = indexToDelete;
    index.length--;
    return true;
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(address) {
    return index[idx];
  }
}
