
contract ArtefHack is Role {
	Balances private balances;

	DataProvider public dataProvider;
	ArtefHackUserStorage private users;
	ContentStorage public contents;
	MessageStorage public messages;

	function ArtefHack(address _contents, address _messages) {
		contents = ContentStorage(_contents);
		messages = MessageStorage(_messages);
	}

	function publish(bytes32 catalogueId, bytes32 contentId) {
		uint preference;
		uint idx;
		dataProvider.buyContent(catalogueId)
		contents.upsert(contentId, preference)
	}

	function advertise(bytes32 identifier, bytes32 message) returns (uint idx) {
		messages.upsert(identifier, message);
	}

	function visit() returns (bytes32 content, bytes32 message) {

	}

	function eval(bytes32 content, int score) returns (bool success) {
		// update user preference
		if (score < 0) {
			address(this).pay(tx.origin);
		}
		if (score > 0) {
			tx.origin(this).pay(address(this));
		}
	}
}

contract ArtefHackUserStorage {

  struct ArtefHackUser {
    bool message;
    uint preference;
    uint idx;
  }

  mapping(address => ArtefHackUser) private users;
  address[] private index;

  function exists(address addr) public constant returns(bool isIndeed) {
    if (index.length == 0) return false;

    return (
      index[users[addr].idx] == addr
    );
  }

  function insert(address addr, uint preference, bool message) public returns(uint idx) {
    require(!exists(addr));

    users[addr].preference = preference;
    users[addr].message = message;
    users[addr].idx = index.push(addr)-1;

    return index.length-1;
  }

  function get(address addr) public constant returns(uint preference, bool message, uint idx) {
    require(exists(addr));

    return(
      users[addr].preference,
      users[addr].message,
      users[addr].idx
    );
  }

  function remove(address addr) public returns (bool success) {
    require(exists(addr));
    uint indexToDelete = users[addr].idx;
    address addressToMove   = index[index.length-1];
    index[indexToDelete] = addressToMove;
    users[addressToMove].idx = indexToDelete;
    index.length--;
    return true;
  }

  function updatePreference(address addr, uint preference) public returns(bool success) {
    require(exists(addr));
    users[addr].preference = preference;
    return true;
  }

  function updateMessage(address addr, bool message) public returns(bool success) {
    require(exists(addr));
    users[addr].message = message;
    return true;
  }

  function upsert(address addr, uint preference, bool message) public returns(bool success) {
    if (exists(addr)) {
      return (
      	updatePreference(addr, preference)
      	&& updateMessage(addr, message)
      );
    }
    return (insert(addr, preference, message) > 0);
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(address) {
    return index[idx];
  }
}
