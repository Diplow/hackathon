pragma solidity ^0.4.4;

import '../stakeholders/dataProvider.sol';
import '../stakeholders/publisher.sol';
import '../storage/artefHack/contents.sol';
import '../storage/artefHack/users.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract ArtefHack is Role {
	Balances private balances;
  address public advertiser;

  DataProvider public dataProvider;
  Publisher public publisher;
	ArtefHackUserStorage private users;
	ArtefHackContentStorage public contents;

  uint ADVERTISING_COST = 1;
  uint LIKE_COMPENSATION = 1;
  uint DISLIKE_COMPENSATION = 1;

	function ArtefHack(address _balances, address _advertiser, address _contents, address _publisher, address _dataProvider) {
    balances = Balances(_balances);
		contents = ContentStorage(_contents);
    publisher = Publisher(_publisher);
    dataProvider = DataProvider(_dataProvider);
	}

	function publish(bytes32 catalogueId, bytes32 contentId) returns (bool success) {
		uint preference;
		bytes32 content;
    (content, preference) = dataProvider.buyContent(catalogueId);
		contents.insert(content, preference);
	}

	function visit() returns (bytes32 content, bool message) {
    bytes32 content = "test content";
    bool message = true;
    if (message) {
      balances.pay(advertiser, address(this), ADVERTISING_COST);
    }
    return (content, message);
	}

	function eval(bytes32 content, int score) returns (bool success) {
		// update user preference
		if (score < 0) {
			balances.pay(address(this), tx.origin, LIKE_COMPENSATION);
		}
		if (score > 0) {
      balances.pay(tx.origin, address(this), DISLIKE_COMPENSATION);
		}
	}
}
