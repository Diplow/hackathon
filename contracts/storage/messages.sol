pragma solidity ^0.4.4;

contract MessageStorage {

  struct Message {
    address advertiser;
    bytes32 content;
    uint idx;
  }

  mapping(bytes32 => Message) private messages;
  bytes32[] private index;

  event LogNewMessage   (bytes32 indexed identifier, uint idx, address advertiser, bytes32 content);
  event LogUpdateMessage(bytes32 indexed identifier, uint idx, address advertiser, bytes32 content);

  function exists(bytes32 identifier) public constant returns(bool isIndeed) {
    if (index.length == 0) return false;

    return (
      index[messages[identifier].idx] == identifier
    );
  }

  function insert(bytes32 identifier, address advertiser, bytes32 content) public returns(uint idx) {
    require(!exists(identifier)); 

    messages[identifier].advertiser = advertiser;
    messages[identifier].content = content;
    messages[identifier].idx = index.push(identifier)-1;

    LogNewMessage(
      identifier,
      messages[identifier].idx,
      advertiser,
      content
    );

    return index.length-1;
  }
  
  function get(bytes32 identifier) public constant returns(address advertiser, bytes32 content, uint idx) {
    require(exists(identifier)); 

    return(
      messages[identifier].advertiser,
      messages[identifier].content,
      messages[identifier].idx
    );
  } 
  
  function updateAdvertiser(bytes32 identifier, address advertiser) public returns(bool success) {
    require(exists(identifier));

    messages[identifier].advertiser = advertiser;

    LogUpdateMessage(
      identifier, 
      messages[identifier].idx,
      advertiser, 
      messages[identifier].content
    );

    return true;
  }
  
  function updateContent(bytes32 identifier, bytes32 content) public returns(bool success) {
    require(exists(identifier)); 

    messages[identifier].content = content;

    LogUpdateMessage(
      identifier, 
      messages[identifier].idx,
      messages[identifier].advertiser, 
      content
    );

    return true;
  }

  function upsert(bytes32 identifier, address advertiser, bytes32 content) public returns(bool success) {
    if (exists(identifier)) {
      return (updateAdvertiser(identifier, advertiser) && updateContent(identifier, content));
    }
    return (insert(identifier, advertiser, content) > 0);
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32) {
    return index[idx];
  }

}
