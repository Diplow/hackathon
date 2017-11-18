pragma solidity ^0.4.4;

contract Catalogue {

  struct PublicContent {
    bytes32 contentIdentifier;
    uint preference;
    uint idx;
  }

  mapping(bytes32 => PublicContent) private publicContents;
  bytes32[] private index;

  function exists(bytes32 identifier) public constant returns(bool isIndeed) {
    if (index.length == 0) return false;

    return (
      index[publicContents[identifier].idx] == identifier
    );
  }

  function insert(bytes32 identifier, bytes32 contentIdentifier, uint preference) public returns(uint idx) {
    require(!exists(identifier)); 

    publicContents[identifier].contentIdentifier = contentIdentifier;
    publicContents[identifier].preference = preference;
    publicContents[identifier].idx = index.push(identifier)-1;

    return index.length-1;
  }
  
  function get(bytes32 identifier) public constant returns(bytes32 contentIdentifier, uint preference, uint idx) {
    require(exists(identifier)); 

    return(
      publicContents[identifier].contentIdentifier,
      publicContents[identifier].preference,
      publicContents[identifier].idx
    );
  } 
  
  function updateContentIdentifier(bytes32 identifier, bytes32 contentIdentifier) public returns(bool success) {
    require(exists(identifier));
    publicContents[identifier].contentIdentifier = contentIdentifier;
    return true;
  }
  
  function updatePreference(bytes32 identifier, uint preference) public returns(bool success) {
    require(exists(identifier)); 
    publicContents[identifier].preference = preference;
    return true;
  }

  function upsert(bytes32 identifier, bytes32 contentIdentifier, uint preference) public returns(bool success) {
    if (exists(identifier)) {
      return (
        updateContentIdentifier(identifier, contentIdentifier)
        && updatePreference(identifier, preference)
      );
    }
    return (insert(identifier, contentIdentifier, preference) > 0);
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32) {
    return index[idx];
  }

}
