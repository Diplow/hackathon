pragma solidity ^0.4.4;

import '../storage/users.sol';
import '../storage/balances.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract DataProvider is Role {
	Users private users;
  Balances private balances;
	int public COST = 1;

	function DataProvider(address _users, address _balances) {
		users = Users(_users);
    balances = Balances(_balances);
	}

	function buyUserData(address user) isRole('ArtefHack') returns (uint preference) {
		require(users.exists(user));

		uint res;
		bool message;
    uint idx;
		(preference, message, idx) = users.get(user);

		balances.pay(tx.origin, user, COST);

		return res;
	}

	function insertUserData(uint preference, bool message) returns (uint idx) {
		return users.insert(tx.origin, preference, message);
	}

  function removeUserData() returns (bool success) {
    return users.remove(tx.origin);
  }
}
