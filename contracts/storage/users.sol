pragma solidity ^0.4.4;

contract UserStorage {

  struct User {
    bytes32 gender;
    bytes32 city;
    uint idx;
  }

  mapping(address => User) private users;
  address[] private index;

  event LogNewUser   (address indexed addr, uint idx, bytes32 gender, bytes32 city);
  event LogUpdateUser(address indexed addr, uint idx, bytes32 gender, bytes32 city);

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

    LogNewUser(
      addr,
      users[addr].idx,
      gender,
      city
    );

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

  // no need to update audienceArray, a user should accept to be targeted if he
  // gets paid for being in an audience
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

    LogUpdateUser(
      addr,
      users[addr].idx,
      gender,
      users[addr].city
    );

    return true;
  }

  function updateCity(address addr, bytes32 city) public returns(bool success) {
    require(exists(addr));

    users[addr].city = city;

    LogUpdateUser(
      addr,
      users[addr].idx,
      users[addr].gender,
      city
    );

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
