pragma solidity ^0.4.4;

import './advertiser.sol';
import './dataProvider.sol';
import '../storage/placements.sol';
import '../storage/messages.sol';
import '../storage/targetings.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';

contract Publisher is Role{
	address public owner;

	Advertiser private advertiser;
	DataProvider private provider;
	MessageStorage private messages;
	PlacementStorage private placements;
	TargetingStorage private targetings;

	string DEFAULT_MESSAGE;
	uint private baseUserPrice = 10;
	uint private baseTargetingPrice = 50;

	function Publisher(address _advertiser, address _messages, address _placements, address _provider, address _targetings) {
		owner = tx.origin;
		DEFAULT_MESSAGE = 'Nothing to print here :3';
		advertiser = Advertiser(_advertiser);
		placements = PlacementStorage(_placements);
		messages = MessageStorage(_messages);
		targetings = TargetingStorage(_targetings);
		provider = DataProvider(_provider);
	}

	// fallback function so that the publisher contract can receive funds
	function() payable { }

	// PUBLISHER INTERFACE

	function createPlacement(string placementId, uint cost) isRole('Publisher') {
		placements.upsert(Utils.stringToBytes32(placementId), tx.origin, cost);
	}

	// ADVERTISER INTERFACE

	function setupTargeting(string targetingId, string message, string placement, string audience) isRole('Advertiser') {
		advertiser.payForDataUsage(tx.origin, address(this), baseTargetingPrice);
		targetings.upsert(
			tx.origin,
			Utils.stringToBytes32(targetingId),
			Utils.stringToBytes32(message),
			Utils.stringToBytes32(placement),
			Utils.stringToBytes32(audience),
			true
		);
	}

	// USER INTERFACE
	function visits(string placement) isRole('User') returns (bytes32) {
		uint c = targetings.count();
		for(uint i=0; i<c; i++){
			address adv_t;
			bytes32 plct;
			bytes32 message;
			bytes32 aud;
			bool state;
			uint idx;
			(adv_t, plct, message, aud, state, idx) = targetings.get(targetings.getAt(i));
			if (plct == Utils.stringToBytes32(placement)) {
				if (provider.doesBelong(tx.origin, aud)) {
				    address adv_m;
				    bytes32 content;
				    uint index;
				    (adv_m, content, index) = messages.get(message);
					advertiser.payForDataUsage(adv_t, tx.origin, baseUserPrice);
					return content;
				}
			}
		}
		return Utils.stringToBytes32(DEFAULT_MESSAGE);
	}
}
