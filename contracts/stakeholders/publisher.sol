pragma solidity ^0.4.4;

import '../storage/catalogue.sol';
import '../storage/balances.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract Publisher is Role {

	Balances public balances;
	Catalogue public catalogue;
	bytes32[] private contents;

	function Publisher(address _catalogue, address _balances, address _roles) Role(_roles){
		catalogue = Catalogue(_catalogue);
		balances = Balances(_balances);
	}

	function insertContent(bytes32 identifier, uint preference) returns (uint idx) {
		// TODO test indexes
		uint res = contents.push(identifier)-1;
		catalogue.insert(res, preference);
		return res;
	}

	function buyContent(uint catalogueId) isRole('ArtefHack') returns (bytes32 content, uint pref) {
		balances.pay(tx.origin, address(this), 1);
		uint preference;
		uint idx;
		(preference, idx) = catalogue.get(catalogueId);
		return (contents[catalogueId], preference);
	}
}
