pragma solidity ^0.4.4;

import '../storage/catalogue.sol';
import '../storage/balances.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract Publisher is Role {

	Balances public balances;
	Catalogue public catalogue;
	bytes32[] private contents;

	function Publisher(address _catalogue, address _balances) {
		catalogue = Catalogue(_catalogue);
		balances = Balances(_balances);
	}

	function insertContent(bytes32 identifier, uint preference) returns (uint idx) {
		// TODO test indexes
		uint res = contents.push(identifier)-1;
		catalogue.insert(identifier, res, preference);
		return res;
	}

	function buyContent(bytes32 catalogueId) isRole('ArtefHack') returns (bytes32 content, uint pref) {
		balances.pay(tx.origin, address(this), 1);
		uint cid;
		uint preference;
		uint idx;
		(cid, preference, idx) = catalogue.get(catalogueId);
		return (contents[cid], preference);
	}
}
