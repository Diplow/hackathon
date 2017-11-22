pragma solidity ^0.4.4;

import '../stakeholders/dataProvider.sol';
import '../stakeholders/publisher.sol';
import '../storage/artefHack/contents.sol';
import '../storage/artefHack/users.sol';
import '../storage/artefHack/catalogue.sol';
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

	function ArtefHack(address _balances, address _contents, address _users, address _publisher, address _dataProvider, address _roles, address _catalogue) Role(_roles){
	    balances = Balances(_balances);
	    contents = ArtefHackContentStorage(_contents);
	    users = ArtefHackUserStorage(_users);
	    publisher = Publisher(_publisher);
	    dataProvider = DataProvider(_dataProvider);
	    catalogue = Catalogue(_catalogue);
	}

	function publish(uint catalogueId) returns (bytes32 content) {
		uint preference;
		bytes32 content;
    	(content, preference) = publisher.buyContent(artefhack, catalogueId);
		contents.insert(content, catalogueId, preference);
		return content;
	}

	function setArtefHack(address _artefhack) isRole('Admin'){
		artefhack = _artefhack;
	}

	function buyContentByPref(address usr, uint pref, uint maxdist) returns (bytes32 content) {
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
						return res
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
		if ((pref+1) == maxdist) {
			if (maxdist < 20) {
				return buyContentByPref(0, 10)
			}
			retry = maxdist - 10;
		}
	
		return buyContentByPref(retry, maxdist);
	}

	function visit() returns (bytes32, bool) {
		require(artefhack > 0);
		if (initContents.length == 0) {
			uint[] scores = [10, 30, 50, 70, 90];
			for (uint i; i < scores.length; ++i) {
				bytes32 c = buyContentByPref(scores[i]);
				initContents.push(c);
			}
		}
		if (!users.exists(tx.origin)) {
			users.insert(tx.origin);
			for (uint i = 0; i < initContents.length; ++i) {
				users.addContent(tx.origin, initContents[i]);
			}
		}
		uint preference;
		bool message;
		uint idx;
		(preference, message, idx) = users.get(tx.origin);
		bytes32 content;
		uint contentleft;
		(content, contentleft) = users.getContent(tx.origin);
		if (contentleft == 0) {
			bytes32 cc = buyContentByPref(tx.origin, preference, preference+10);
			require(users.addContent(tx.origin, cc));
		}
    	return (content, message);
	}

	function eval(bytes32 content, bool message, bool score) {
		uint preference;
		uint ctlg;
		uint idx;
		(preference, ctlg, idx) = contents.get(content);
		users.updatePref(tx.origin, score, message, preference);
	}
}
