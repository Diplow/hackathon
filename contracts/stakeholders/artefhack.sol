
contract ArtefHack is Role {
	Balances private balances;

	ContentStorage public contents;
	MessageStorage public messages;

	function publish(bytes32 content) isRole('Publisher') returns (uint idx) {
	}

	function advertise(bytes32 content, bytes32 message) isRole('Advertiser') returns (bool success) {
	}

	function visit() isRole('User') returns (bytes32 content, bytes32 message) {
		// Choose what content to return
		// Choose what message to return if any

		// show the better fit for this user according to the DP data
	}

	function eval(bytes32 content, uint score) isRole('User') returns (bool success) {
	}

	function eval(bytes32 message, uint score) isRole('User') returns (bool success) {
	}
}
