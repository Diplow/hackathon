pragma solidity ^0.4.4;

contract UserStorage {

  struct User {
    bytes32 gender;
    bytes32 city;
    uint idx;
  }

  mapping(address => User) private users;
  address[] private index;

  function exists(address addr) public constant returns(bool isIndeed) {
    if (index.length == 0) return false;

    return (
      index[users[addr].idx] == addr
    );
  }

  function insert(address addr, bytes32 gender, bytes32 city) public returns(uint idx) {
    require(!exists(addr));

    users[addr].gender = gender;
    users[addr].city = city;
    users[addr].idx = index.push(addr)-1;

    return index.length-1;
  }

  function get(address addr) public constant returns(bytes32 gender, bytes32 city, uint idx) {
    require(exists(addr));

    return(
      users[addr].gender,
      users[addr].city,
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

  function updateGender(address addr, bytes32 gender) public returns(bool success) {
    require(exists(addr));
    users[addr].gender = gender;
    return true;
  }

  function updateCity(address addr, bytes32 city) public returns(bool success) {
    require(exists(addr));
    users[addr].city = city;
    return true;
  }

  function upsert(address addr, bytes32 gender, bytes32 city) public returns(bool success) {
    if (exists(addr)) {
      return (updateGender(addr, gender) && updateCity(addr, city));
    }
    return (insert(addr, gender, city) > 0);
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(address) {
    return index[idx];
  }
}
