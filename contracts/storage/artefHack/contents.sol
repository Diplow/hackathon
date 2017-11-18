

contract ArtefHackContentStorage {

  struct ArtefHackContent {
    uint preference;
    uint idx;
  }

  mapping(bytes32 => ArtefHackUser) private users;
  identifier[] private index;

  function exists(bytes32 identifier) public constant returns(bool exists) {
    return (index.length != 0 && index[users[addr].idx] == addr);
  }

  function insert(bytes32 identifier, uint preference) public returns(uint idx) {
    require(!exists(addr));
    users[addr].preference = preference;
    users[addr].idx = index.push(addr)-1;
    return index.length-1;
  }

  function get(bytes32 identifier) public constant returns(uint preference, uint idx) {
    require(exists(addr));

    return(
      users[addr].preference,
      users[addr].idx
    );
  }

  function remove(bytes32 identifier) public returns (bool success) {
    require(exists(addr));
    uint indexToDelete = users[addr].idx;
    bytes32 identifierToMove   = index[index.length-1];
    index[indexToDelete] = identifierToMove;
    users[identifierToMove].idx = indexToDelete;
    index.length--;
    return true;
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32 identifier) {
    return index[idx];
  }
}
