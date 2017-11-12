
contract ArtefHack is Role {
	Balances private balances;

	ContentStorage public contents;
	MessageStorage public messages;
	TargetingStorage public targetings;

	function publish(bytes32 contentId, uint entertainment, uint information) isRole('Publisher') returns (uint idx) {
		return contents.upsert(contentId, tx.origin, entertainment, information);
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

// LVL 1
// Publisher
// Advertiser
// publish
// advertise

// LVL 2
// publish + pay
// advertise + pay
// visit + pay
// DataProvider
// eval

// LVL 3
// get more advertisers
// get more content
// get more users