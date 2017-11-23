pragma solidity ^0.4.4;


contract ArtefHackContentStorage {

  struct ArtefHackContent {
    uint preference;
    uint catalogueId;
    uint idx;
  }

  mapping(bytes32 => ArtefHackContent) public contents;
  mapping(uint => bytes32) public existByCtlg;
  mapping(uint => bytes32[]) public contentByPref; 
  bytes32[] public index;

  function exists(bytes32 identifier) public constant returns(bool) {
    return (index.length != 0 && index[contents[identifier].idx] == identifier);
  }

  function alreadyBought(uint catalogueId) public returns (bool, bytes32) {
    bytes32 c = existByCtlg[catalogueId];
    bool b = (c != "");
    return (b, c);
  }

  function insert(bytes32 identifier, uint catalogueId, uint preference) public returns(uint idx) {
    require(!exists(identifier));
    contents[identifier].preference = preference;
    contents[identifier].catalogueId = catalogueId;
    contents[identifier].idx = index.push(identifier)-1;
    existByCtlg[catalogueId] = identifier;
    contentByPref[preference].push(identifier);
    return index.length-1;
  }

  function getByPrefCount(uint pref) public returns(uint) {
    return contentByPref[pref].length;
  }

  function getByPrefAt(uint pref, uint at) public returns (bytes32) {
    return contentByPref[pref][at];
  }

  function get(bytes32 identifier) public constant returns(uint preference, uint catalogueId, uint idx) {
    require(exists(identifier));

    return(
      contents[identifier].preference,
      contents[identifier].catalogueId,
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

  function count() public returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32 identifier) {
    return index[idx];
  }
}
