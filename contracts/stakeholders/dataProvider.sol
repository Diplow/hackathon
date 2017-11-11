pragma solidity ^0.4.4;

import './advertiser.sol';
import '../storage/audiences.sol';
import '../storage/users.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';

contract DataProvider is Role {
	address public owner;

	Advertiser private advertiser;
	AudienceStorage private audiences;
	UserStorage private users;

    uint private baseAudiencePrice = 100;

	// We consider here that there is only one data provider
	function DataProvider(address _advertiser, address _audiences, address _users) {
		owner = tx.origin;
		advertiser = Advertiser(_advertiser);
		audiences = AudienceStorage(_audiences);
		users = UserStorage(_users);
	}

	// fallback function so that the dataprovider contract can receive funds
	function() payable { }

	// USER INTERFACE

	// a user will have to set both her data at the same time
	function setData(string gender, string city) isRole('User') returns (bool success) {
		return users.upsert(tx.origin, Utils.stringToBytes32(gender), Utils.stringToBytes32(city));
	}

	function getData() isRole('User') returns (bytes32) {
		bytes32 gender;
		bytes32 city;
		uint idx;
		(gender, city, idx) = users.get(tx.origin);
		return gender;
	}

	function resign() isRole('User') returns (bool success) {
		return users.remove(tx.origin);
	}

	// ADVERTISER INTERFACE

	function setAudience(string audienceId, string genderCriteria, string cityCriteria) isRole('Advertiser') returns (bool success) {
		advertiser.payForDataUsage(tx.origin, address(this), baseAudiencePrice);
		return audiences.upsert(
			Utils.stringToBytes32(audienceId),
			Utils.stringToBytes32(genderCriteria),
			Utils.stringToBytes32(cityCriteria)
		);
	}

	function getAudiencePrice() isRole('Advertiser') returns (uint) {
		// includes user fee and dataprovider fee
		return baseAudiencePrice;
	}

	// PUBLISHER INTERFACE

	function doesBelong(address user, bytes32 audienceId) isRole('Publisher') returns (bool success) {
		bytes32 gender;
		bytes32 city;
		uint usrIdx;
		bytes32 genderCriteria;
		bytes32 cityCriteria;
		uint audIdx;
		(gender, city, usrIdx) = users.get(user);
		(genderCriteria, cityCriteria, audIdx) = audiences.get(audienceId);
		return (
			(genderCriteria == "" || genderCriteria == gender) && (cityCriteria == "" || cityCriteria == city)
		);
	}
}
