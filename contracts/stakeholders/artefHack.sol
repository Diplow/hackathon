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

  function setAdvertiser(address adv) {
    advertiser = adv;
  }

	function publish(uint catalogueId) {
		uint preference;
		bytes32 content;
    (content, preference) = publisher.buyContent(catalogueId);
		contents.insert(content, preference);
	}

	function visit() returns (bytes32, bool) {
<<<<<<< HEAD
		// if (!users.exists(tx.origin)) {
		//   users.init(tx.origin);
		// }
		// bytes32 content = users.getNextContent(tx.origin);
		// bool message = users.sendMessage(tx.origin);
    bytes32 content = Utils.stringToBytes32("ZQRNQFIDOR");
    bool message = true;
    if (message) {
      balances.pay(advertiser, address(this), ADVERTISING_COST);
    }
    return (content, message);
	}

	function eval(bytes32 content, int score) {
		// update user preference
		if (score < 0) {
			balances.pay(address(this), tx.origin, LIKE_COMPENSATION);
		}
		if (score > 0) {
      balances.pay(tx.origin, address(this), DISLIKE_COMPENSATION);
		}
	}
}
