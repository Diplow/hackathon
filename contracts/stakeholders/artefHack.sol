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
  	Publisher public publisher;
	ArtefHackUserStorage private users;
	ArtefHackContentStorage public contents;

	bytes32 public firstContent;

  	int ADVERTISING_COST = 1;

	function ArtefHack(address _balances, address _contents, address _users, address _publisher, address _roles, address _catalogue) Role(_roles) public {
	    balances = Balances(_balances);
	    contents = ArtefHackContentStorage(_contents);
	    users = ArtefHackUserStorage(_users);
	    publisher = Publisher(_publisher);
	    catalogue = Catalogue(_catalogue);
	}

	function publish(uint catalogueId) public returns (bytes32) {
		uint preference;
		bytes32 content;
    	(content, preference) = publisher.buyContent(artefhack, catalogueId);
    	if (content == "") {
    		content = firstContent;
    	}
    	else {
			contents.insert(content, catalogueId, preference);
    	}
		return content;
	}

	function setArtefHack(address _artefhack) public isRole('Admin'){
		artefhack = _artefhack;
	}

	function buyContentByPref(address usr, uint pref, uint maxdist, uint maxdepth) public returns (bytes32 content) {
		if (maxdepth > 20) {
			return firstContent;
		}
		maxdepth++;
		if (maxdist > 99) {
			maxdist = 99;
		}
		if (pref > 99) {
			pref = 99;
			maxdist = 99;
		}
		bytes32 res;
		uint cnt = catalogue.getByPrefCount(pref);
		for (uint i = 0; i < cnt; ++i) {
			uint index;
			index = catalogue.getByPrefAt(pref, i);
			uint idx = catalogue.getAt(index);
			bool abought;
			(abought, res) = contents.alreadyBought(idx);
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
		pref += 1;
		uint retry;
		if (pref > maxdist) {
			if (maxdist < 20) {
				if (maxdist < 11) {
					return firstContent;
				}
				return buyContentByPref(usr, 0, 10, maxdepth);
			}
			retry = maxdist - 20;
			maxdist = maxdist - 10;
		}
		else {
			retry = pref;
		}
		return buyContentByPref(usr, retry, maxdist, maxdepth);
	}

	function visit() public returns (bytes32, bool) {
		require(artefhack > 0);
		if (firstContent == "") {
			uint s0 = 10;
			uint maxdepth = 0;
			bytes32 c = buyContentByPref(tx.origin, s0, s0+10, maxdepth);
			firstContent = c;
		}
		if (!users.exists(tx.origin)) {
			uint basepref = 10;
			bool basemsg = false;
			users.insert(tx.origin, basepref, basemsg);
			users.addContent(tx.origin, firstContent);
		}
		uint preference;
		bool message;
		uint idx;
		(preference, message, idx) = users.get(tx.origin);
		bytes32 content;
		content = users.getContent(tx.origin);
		if (content == "") {
			return (firstContent, true);
		}
    	return (content, message);
	}

	function eval(bytes32 content, bool message, bool score) public {
		uint preference;
		uint ctlg;
		uint idx;
		uint maxdepth=0;
		(preference, ctlg, idx) = contents.get(content);
		users.updatePref(tx.origin, score, message, preference);
		bytes32 cc = buyContentByPref(tx.origin, preference, preference+10, maxdepth);
		require(cc != "");
		users.addContent(tx.origin, cc);
	}
}
