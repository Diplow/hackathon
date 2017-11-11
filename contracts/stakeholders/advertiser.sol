pragma solidity ^0.4.4;

import '../storage/balances.sol';
import '../storage/messages.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract Advertiser is Role {
	address public owner;

	AdvertiserBalances private balances;
	MessageStorage private messages;

	function Advertiser(address _balances, address _messages){
		owner = tx.origin;
		balances = AdvertiserBalances(_balances);
		messages = MessageStorage(_messages);
	}

	// ADVERTISER INTERFACE
	function setMessage(string messageId, string messageText) isRole('Advertiser') {
		messages.upsert(
			Utils.stringToBytes32(messageId),
			tx.origin,
			Utils.stringToBytes32(messageText)
		);
	}

	function getMessage(string messageId) returns (address, bytes32, uint){
		return messages.get(Utils.stringToBytes32(messageId));
	}

	// PAYMENT INTERFACE FOR ADVERTISERS

	function payForDataUsage(address from, address user, uint amountToPay) isRole('Advertiser') {
		require(balances.hasSufficientFunds(from, amountToPay));
		balances.payForDataUsage(user, amountToPay);
		balances.updateBalance(-int(amountToPay));
	}

}
