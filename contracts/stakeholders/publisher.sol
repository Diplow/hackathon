pragma solidity ^0.4.4;

import '../storage/catalogue.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract Publisher {

	Catalogue public catalogue;
	bytes32[] private contents;

	function Publisher(address _catalogue) {
		catalogue = Catalogue(_catalogue);
	}

	function insertContent(bytes32 identifier, uint preference) returns (uint idx) {
		uint idx = contents.push(identifier)-1;
		catalogue.insert(idx, preference);
		return idx;
	}

	function buyContent(uint idx) isRole('ArtefHack') returns (bytes32 content) {
		tx.origin.pay(cost, address(this));
		return contents[idx]
	}
