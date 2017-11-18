pragma solidity ^0.4.4;

import '../utils/utils.sol';


contract Catalogue {

  struct PublicContent {
      uint contentIdentifier;
      uint preference;
      uint idx;
    }

  mapping(bytes32 => PublicContent) private publicContents;
  bytes32[] private index;

  function exists(bytes32 identifier) public constant returns(bool exists) {
    return (index.length > 0 && index[publicContents[identifier].idx] == identifier);
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

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32) {
    return index[idx];
  }
}