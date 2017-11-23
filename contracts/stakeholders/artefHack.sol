pragma solidity ^0.4.4;

import '../stakeholders/dataProvider.sol';
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
	DataProvider public dataProvider;
  	Publisher public publisher;
	ArtefHackUserStorage private users;
	ArtefHackContentStorage public contents;

	bytes32[] public initContents;

  	int ADVERTISING_COST = 1;

	function ArtefHack(address _balances, address _contents, address _users, address _publisher, address _dataProvider, address _roles, address _catalogue) Role(_roles) public {
	    balances = Balances(_balances);
	    contents = ArtefHackContentStorage(_contents);
	    users = ArtefHackUserStorage(_users);
	    publisher = Publisher(_publisher);
	    dataProvider = DataProvider(_dataProvider);
	    catalogue = Catalogue(_catalogue);
	}

	function publish(uint catalogueId) public returns (bytes32) {
		uint preference;
		bytes32 content;
    	(content, preference) = publisher.buyContent(artefhack, catalogueId);
		contents.insert(content, catalogueId, preference);
		return content;
	}

	function setArtefHack(address _artefhack) public isRole('Admin'){
		artefhack = _artefhack;
	}

	function buyContentByPref(address usr, uint pref, uint maxdist) public returns (bytes32 content) {
		if (maxdist > 99) {
			maxdist = 99;
		}
		bytes32 res;
		uint cnt = catalogue.count();
		for (uint i = 0; i < cnt; ++i) {
			uint idx = catalogue.getAt(i);
			uint index;
			uint preference;
			(preference, index) = catalogue.get(idx);
			if (preference == pref) {
				bool abought;
				(abought, res) = contents.alreadyBought(index);
				if (abought) {
					if (!users.hasSeen(usr, res)) {
						return res;
					}
				}
				else {
					res = publish(idx);
					return res;
				}
			}
		}
		pref += 1;
		uint retry;
		if (pref > maxdist) {
			if (maxdist < 20) {
				return buyContentByPref(usr, 0, 10);
			}
			retry = maxdist - 20;
		}
		else {
			retry = pref;
		}
	
		return buyContentByPref(usr, retry, maxdist);
	}

	function visit() public returns (bytes32, bool) {
		require(artefhack > 0);
		if (initContents.length == 0) {
			uint s0 = 10;
			bytes32 c = buyContentByPref(tx.origin, s0, s0+10);
			initContents.push(c);
		}
		if (!users.exists(tx.origin)) {
			uint basepref = 10;
			bool basemsg = false;
			users.insert(tx.origin, basepref, basemsg);
			users.addContent(tx.origin, initContents[0]);
		}
		uint preference;
		bool message;
		uint idx;
		(preference, message, idx) = users.get(tx.origin);
		bytes32 content;
		content = users.getContent(tx.origin);
    	return (content, message);
	}

	function eval(bytes32 content, bool message, bool score) public {
		uint preference;
		uint ctlg;
		uint idx;
		(preference, ctlg, idx) = contents.get(content);
		users.updatePref(tx.origin, score, message, preference);
		bytes32 cc = buyContentByPref(tx.origin, preference, preference+10);
		require(users.addContent(tx.origin, cc));
	}
}
