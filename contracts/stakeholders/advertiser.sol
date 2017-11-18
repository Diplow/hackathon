pragma solidity ^0.4.4;

import '../utils/roles.sol';
import '../utils/utils.sol';


contract Advertiser is Role {
	address public owner;


	function Advertiser(address _balances, address _messages){
		owner = tx.origin;
	}

	function payForDataUsage(address from, address user, uint amountToPay) isRole('Advertiser') {
		require(balances.hasSufficientFunds(from, amountToPay));
		balances.payForDataUsage(user, amountToPay);
		balances.updateBalance(-int(amountToPay));
	}

}
