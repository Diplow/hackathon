pragma solidity ^0.4.4;

import '../stakeholders/dataProvider.sol';
import '../stakeholders/publisher.sol';
import '../storage/artefHack/contents.sol';
import '../storage/artefHack/users.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract ArtefHack is Role {
	Balances private balances;
	address public artefhack;

  DataProvider public dataProvider;
  Publisher public publisher;
	ArtefHackUserStorage private users;
	ArtefHackContentStorage public contents;

  int ADVERTISING_COST = 1;
  int LIKE_COMPENSATION = 1;
  int DISLIKE_COMPENSATION = 1;

	function ArtefHack(address _balances, address _contents, address _users, address _publisher, address _dataProvider, address _roles) Role(_roles){
    balances = Balances(_balances);
    contents = ArtefHackContentStorage(_contents);
    users = ArtefHackUserStorage(_users);
    publisher = Publisher(_publisher);
    dataProvider = DataProvider(_dataProvider);
	}

	function publish(uint catalogueId) {
		uint preference;
		bytes32 content;
    (content, preference) = publisher.buyContent(artefhack, catalogueId);
		contents.insert(content, preference);
	}

	function setArtefHack(address _artefhack) isRole('Admin') {
		artefhack = _artefhack;
	}

	function visit() isRole('User') returns (bytes32, bool) {
		require(artefhack > 0);

		if(contents.count() == 0 ){
			publish(0);
		}

    bytes32 content = contents.getAt(0);
    bool message = true;

    return (content, message);
	}

	function eval(bytes32 content, int score) isRole('User') {
		// TODO
	}
}
