pragma solidity ^0.4.4;

contract AudienceStorage {

  struct Audience {
    bytes32 genderCriteria;
    bytes32 cityCriteria;
    /*uint cnt;*/
    uint idx;
  }

  mapping(bytes32 => Audience) private audiences;
  bytes32[] private index;

  event LogNewAudience   (bytes32 indexed identifier, uint idx, bytes32 genderCriteria, bytes32 cityCriteria);
  event LogUpdateAudience(bytes32 indexed identifier, uint idx, bytes32 genderCriteria, bytes32 cityCriteria);

  function exists(bytes32 identifier) public constant returns(bool isIndeed) {
    if (index.length == 0) return false;

    return (
      index[audiences[identifier].idx] == identifier
    );
  }

  function insert(bytes32 identifier, bytes32 genderCriteria, bytes32 cityCriteria) public returns(uint idx) {
    require(!exists(identifier));

    audiences[identifier].genderCriteria = genderCriteria;
    audiences[identifier].cityCriteria = cityCriteria;
    audiences[identifier].idx = index.push(identifier)-1;

    LogNewAudience(
      identifier,
      audiences[identifier].idx,
      genderCriteria,
      cityCriteria
    );

    return index.length-1;
  }

  function get(bytes32 identifier) public constant returns(bytes32 genderCriteria, bytes32 cityCriteria, uint idx) {
    require(exists(identifier));

    return(
      audiences[identifier].genderCriteria,
      audiences[identifier].cityCriteria,
      audiences[identifier].idx
    );
  }

  function updateGenderCriteria(bytes32 identifier, bytes32 genderCriteria) public returns(bool success) {
    require(exists(identifier));

    audiences[identifier].genderCriteria = genderCriteria;

    LogUpdateAudience(
      identifier,
      audiences[identifier].idx,
      genderCriteria,
      audiences[identifier].cityCriteria
    );

    return true;
  }

  function updateCityCriteria(bytes32 identifier, bytes32 cityCriteria) public returns(bool success) {
    require(exists(identifier));

    audiences[identifier].cityCriteria = cityCriteria;

    LogUpdateAudience(
      identifier,
      audiences[identifier].idx,
      audiences[identifier].genderCriteria,
      cityCriteria
    );

    return true;
  }

  function upsert(bytes32 identifier, bytes32 genderCriteria, bytes32 cityCriteria) public returns(bool success) {
    if (exists(identifier)) {
      return (updateGenderCriteria(identifier, genderCriteria) && updateCityCriteria(identifier, cityCriteria));
    }
    return (insert(identifier, genderCriteria, cityCriteria) > 0);
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32) {
    return index[idx];
  }
}
