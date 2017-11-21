pragma solidity ^0.4.4;


contract ArtefHackContentStorage {

  struct ArtefHackContent {
    uint preference;
    uint idx;
  }

  mapping(bytes32 => ArtefHackContent) public contents;
  bytes32[] public index;

  function exists(bytes32 identifier) public constant returns(bool) {
    return (index.length != 0 && index[contents[identifier].idx] == identifier);
  }

  function insert(bytes32 identifier, uint preference) public returns(uint idx) {
    require(!exists(identifier));
    contents[identifier].preference = preference;
    contents[identifier].idx = index.push(identifier)-1;
    return index.length-1;
  }

  function get(bytes32 identifier) public constant returns(uint preference, uint idx) {
    require(exists(identifier));

    return(
      contents[identifier].preference,
      contents[identifier].idx
    );
  }

  function remove(bytes32 identifier) public returns (bool success) {
    require(exists(identifier));
    uint indexToDelete = contents[identifier].idx;
    bytes32 identifierToMove   = index[index.length-1];
    index[indexToDelete] = identifierToMove;
    contents[identifierToMove].idx = indexToDelete;
    index.length--;
    return true;
  }

  function count() returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32 identifier) {
    return index[idx];
  }
}
