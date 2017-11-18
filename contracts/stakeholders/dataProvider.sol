pragma solidity ^0.4.4;

import '../storage/users.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract DataProvider {
	Users private users;
	uint public COST;

	function DataProvider(address _users) {
		users = Users(_users);
	}

	function buyUserData(address user) isRole('ArtefHack') returns (uint preference) {
		require(users.exists(user));

		uint preference;
		bool message;
		(preference, message) = users.get(user);

		tx.origin.pay(COST, user);

		return preference;
	}

	function insertUserData(uint preference, bool message) returns (bool success) {
		return users.insert(tx.origin, preference, message);
	}
}

contract Users {

  struct User {
    uint preference;
    bool message;
    uint idx;
  }

  mapping(address => User) private users;
  address[] private index;

  function exists(address addr) public constant returns(bool isIndeed) {
	return (index.length > 0 && index[users[addr].idx] == identifier);
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
