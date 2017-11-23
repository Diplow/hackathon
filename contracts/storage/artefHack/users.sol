pragma solidity ^0.4.4;


contract ArtefHackUserStorage {

  struct ArtefHackUser {
    bool message;
    uint preference;
    bytes32[] contents;
    uint contentIdx;
    uint stage;
    uint idx;
  }

  // bytes32[] private initContents;
  mapping(address => ArtefHackUser) private users;
  mapping(bytes32 => bool) public seen;
  address[] private index;

  function exists(address addr) public constant returns(bool) {
    return (index.length != 0 && index[users[addr].idx] == addr);
  }

  function updatePref(address addr, bool score, bool message, uint preference) public {
    require(exists(addr));
    if (users[addr].stage == 0) {
      if (score) {
        users[addr].preference = preference;
        users[addr].stage = 1;
      }
      else {
        users[addr].preference = preference + 10;
        users[addr].stage = 0;
      }
    }
    if (users[addr].stage == 1) {
      if (!score) {
        users[addr].preference = preference - 6;
        users[addr].stage = 2;
        users[addr].message = true;
      }
    }
    if (users[addr].stage == 2) {
      users[addr].message = score;
      users[addr].stage = 3;
    }
  }

  function hasSeen(address usr, bytes32 content) public returns (bool) {
    require(exists(usr));
    return seen[content];
  }

  function insert(address addr, uint preference, bool message) public returns(uint idx) {
    require(!exists(addr));

    users[addr].preference = preference;
    users[addr].message = message;
    //users[addr].contents = initContents(addr);
    //users[addr].contentIdx = 0;
    users[addr].idx = index.push(addr)-1;

    return index.length-1;
  }

  function addContent(address addr, bytes32 content) public returns(bool) {
    require(exists(addr));
    uint idx = users[addr].contents.push(content)-1;
    users[addr].contentIdx = idx;
    return true;
  }

  function getContent(address usr) public returns (bytes32 content) {
    require(exists(usr));
    uint idx = users[usr].contentIdx;
    users[usr].contentIdx += 1;
    seen[users[usr].contents[idx]] = true;
    return users[usr].contents[idx];
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

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(address) {
    return index[idx];
  }
}