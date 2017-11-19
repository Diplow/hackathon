pragma solidity ^0.4.4;

import '../utils/utils.sol';


contract Catalogue {

  struct PublicContent {
      uint preference;
      uint idx;
    }

  mapping(uint => PublicContent) private publicContents;
  uint[] private index;

  function exists(uint identifier) public constant returns(bool) {
    return (index.length > 0 && index[publicContents[identifier].idx] == identifier);
  }

  function insert(uint identifier, uint preference) public returns(uint idx) {
    require(!exists(identifier));
    publicContents[identifier].preference = preference;
    publicContents[identifier].idx = index.push(identifier)-1;
    return index.length-1;
  }

  function get(uint identifier) public constant returns(uint preference, uint idx) {
    require(exists(identifier)); 
    return(
      publicContents[identifier].preference,
      publicContents[identifier].idx
    );
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(uint) {
    return index[idx];
  }
}