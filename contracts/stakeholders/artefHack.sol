pragma solidity ^0.4.4;

import '../stakeholders/publisher.sol';
import '../storage/artefHack/contents.sol';
import '../storage/artefHack/users.sol';
import '../storage/catalogue.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract ArtefHack is Role {
	Balances private balances;
	address public artefhack;

	Catalogue public catalogue;
  Publisher public publisher;
	ArtefHackContentStorage public contents;

	bytes32 firstContent;

	function ArtefHack(address _balances, address _contents, address _users, address _publisher, address _roles, address _catalogue) Role(_roles) public {
	    balances = Balances(_balances);
	    contents = ArtefHackContentStorage(_contents);
	    publisher = Publisher(_publisher);
	    catalogue = Catalogue(_catalogue);
	}

	function publish(uint catalogueId) public returns (bytes32) {
		uint preference;
		bytes32 content;
		(content, preference) = publisher.buyContent(artefhack, catalogueId);
		return content;
	}

	function setArtefHack(address _artefhack) public isRole('Admin'){
		artefhack = _artefhack;
	}

	function visit() public returns (bytes32, bool) {
		require(artefhack > 0);
		bool message = true;
		if(firstContent == ""){
			firstContent = publish(0);
		}
  	return (firstContent, message);
	}

	function eval(bytes32 content, bool message, bool score) public {
	}
}
