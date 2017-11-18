pragma solidity ^0.4.4;

import '../storage/catalogue.sol';
import '../storage/contents.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract Publisher {

	Catalogue public catalogue;
	bytes32[] private contents;

	function Publisher(address _catalogue, address _contents) {
		catalogue = Catalogue(_catalogue);
		contents = Contents(_contents);
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


contract Catalogue {

	struct PublicContent {
    	uint contentIdentifier;
    	uint preference;
    	uint idx;
  	}

	mapping(bytes32 => PublicContent) private publicContents;
	bytes32[] private index;

	function exists(bytes32 identifier) public constant returns(bool exists) {
		return (index.length > 0 && index[publicContents[identifier].idx] == identifier);
	}

	function insert(bytes32 identifier, bytes32 contentIdentifier, uint preference) public returns(uint idx) {
		require(!exists(identifier)); 
		publicContents[identifier].contentIdentifier = contentIdentifier;
		publicContents[identifier].preference = preference;
		publicContents[identifier].idx = index.push(identifier)-1;
		return index.length-1;
	}

	function get(bytes32 identifier) public constant returns(bytes32 contentIdentifier, uint preference, uint idx) {
		require(exists(identifier)); 
		return(
			publicContents[identifier].contentIdentifier,
			publicContents[identifier].preference,
			publicContents[identifier].idx
		);
	}

	function count() public constant returns(uint) {
		return index.length;
	}

	function getAt(uint idx) public constant returns(bytes32) {
		return index[idx];
	}
}
