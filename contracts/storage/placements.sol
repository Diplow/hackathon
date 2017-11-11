pragma solidity ^0.4.4;

contract PlacementStorage {

  struct Placement {
    address publisher;
    uint cost;
    uint idx;
  }
  
  mapping(bytes32 => Placement) private placements;
  bytes32[] private index;

  event LogNewPlacement   (bytes32 indexed identifier, uint idx, address publisher, uint cost);
  event LogUpdatePlacement(bytes32 indexed identifier, uint idx, address publisher, uint cost);

  function exists(bytes32 identifier) public constant returns(bool isIndeed) {
    if (index.length == 0) return false;

    return (
      index[placements[identifier].idx] == identifier
    );
  }

  function insert(bytes32 identifier, address publisher, uint cost) public returns(uint idx) {
    require(!exists(identifier)); 

    placements[identifier].publisher = publisher;
    placements[identifier].cost = cost;
    placements[identifier].idx = index.push(identifier)-1;

    LogNewPlacement(
      identifier,
      placements[identifier].idx,
      publisher,
      cost
    );

    return index.length-1;
  }
  
  function get(bytes32 identifier) public constant returns(address publisher, uint cost, uint idx) {
    require(exists(identifier)); 

    return(
      placements[identifier].publisher,
      placements[identifier].cost,
      placements[identifier].idx
    );
  } 
  
  function updatePublisher(bytes32 identifier, address publisher) public returns(bool success) {
    require(exists(identifier));

    placements[identifier].publisher = publisher;

    LogUpdatePlacement(
      identifier, 
      placements[identifier].idx,
      publisher, 
      placements[identifier].cost
    );

    return true;
  }
  
  function updateCost(bytes32 identifier, uint cost) public returns(bool success) {
    require(exists(identifier)); 

    placements[identifier].cost = cost;

    LogUpdatePlacement(
      identifier, 
      placements[identifier].idx,
      placements[identifier].publisher, 
      cost
    );

    return true;
  }

  function upsert(bytes32 identifier, address publisher, uint cost) public returns(bool success) {
    if (exists(identifier)) {
      return (updatePublisher(identifier, publisher) && updateCost(identifier, cost));
    }
    return (insert(identifier, publisher, cost) > 0);
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32) {
    return index[idx];
  }

}
