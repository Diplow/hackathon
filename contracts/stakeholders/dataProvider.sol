pragma solidity ^0.4.4;

import '../storage/users.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract DataProvider {
	Users private users;
	uint public COST = 1;

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

  function removeUserData() returns (bool success) {
    return users.remove(tx.origin);
  }
}
