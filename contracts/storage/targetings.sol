pragma solidity ^0.4.4;

contract TargetingStorage {

  struct Targeting {
    bytes32 content;
    bytes32 message;
    uint idx;
  }

  mapping(bytes32 => Targeting) private targetings;
  bytes32[] private index;

  function exists(bytes32 identifier) public constant returns(bool isIndeed) {
    if (index.length == 0) return false;

    return (
      index[targetings[identifier].idx] == identifier
    );
  }

  function insert(bytes32 identifier, bytes32 content, bytes32 message) public returns(uint idx) {
    require(!exists(identifier)); 

    targetings[identifier].content = content;
    targetings[identifier].message = message;
    targetings[identifier].idx = index.push(identifier)-1;

    return index.length-1;
  }
  
  function get(bytes32 identifier) public constant returns(bytes32 content, bytes32 message, uint idx) {
    require(exists(identifier)); 

    return(
      targetings[identifier].content,
      targetings[identifier].message,
      targetings[identifier].idx
    );
  } 
  
  function updateContent(bytes32 identifier, bytes32 content) public returns(bool success) {
    require(exists(identifier));
    targetings[identifier].content = content;
    return true;
  }
  
  function updateMessage(bytes32 identifier, bytes32 message) public returns(bool success) {
    require(exists(identifier)); 
    targetings[identifier].message = message;
    return true;
  }

  function upsert(bytes32 identifier, bytes32 content, bytes32 message) public returns(bool success) {
    if (exists(identifier)) {
      return (
        updateContent(identifier, content)
        && updateMessage(identifier, message)
      );
    }
    return (insert(identifier, content, message) > 0);
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32) {
    return index[idx];
  }

}
