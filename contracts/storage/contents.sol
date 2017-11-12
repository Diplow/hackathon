pragma solidity ^0.4.4;

contract ContentStorage {

  struct Content {
    address publisher;
    uint entertainment;
    uint information;
    uint idx;
  }

  mapping(bytes32 => Content) private Contents;
  bytes32[] private index;

  function exists(bytes32 identifier) public constant returns(bool isIndeed) {
    if (index.length == 0) return false;

    return (
      index[Contents[identifier].idx] == identifier
    );
  }

  function insert(bytes32 identifier, address publisher, uint entertainment, uint information) public returns(uint idx) {
    require(!exists(identifier)); 

    Contents[identifier].publisher = publisher;
    Contents[identifier].entertainment = entertainment;
    Contents[identifier].idx = index.push(identifier)-1;

    return index.length-1;
  }
  
  function get(bytes32 identifier) public constant returns(address publisher, uint entertainment, uint information, uint idx) {
    require(exists(identifier)); 

    return(
      Contents[identifier].publisher,
      Contents[identifier].entertainment,
      Contents[identifier].idx
    );
  } 
  
  function updatePublisher(bytes32 identifier, address publisher) public returns(bool success) {
    require(exists(identifier));
    Contents[identifier].publisher = publisher;
    return true;
  }
  
  function updateEntertainment(bytes32 identifier, uint entertainment) public returns(bool success) {
    require(exists(identifier)); 
    Contents[identifier].entertainment = entertainment;
    return true;
  }

  function updateInformation(bytes32 identifier, uint information) public returns(bool success) {
    require(exists(identifier)); 
    Contents[identifier].information = information;
    return true;
  }

  function upsert(bytes32 identifier, address publisher, uint entertainment, uint information) public returns(bool success) {
    if (exists(identifier)) {
      return (
        updatePublisher(identifier, publisher)
        && updateEntertainment(identifier, entertainment)
        && updateInformation(identifier, information)
      );
    }
    return (insert(identifier, publisher, entertainment) > 0);
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32) {
    return index[idx];
  }

}
