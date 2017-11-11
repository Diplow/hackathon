pragma solidity ^0.4.4;

import './audiences.sol';
import './messages.sol';
import './placements.sol';


contract TargetingStorage {
  address public owner;

  MessageStorage messages;
  PlacementStorage placements;
  AudienceStorage audiences;

  struct Targeting {
    address advertiser;
    bytes32 message;
    bytes32 placement;
    bytes32 audience;
    bool state;
    uint idx;
  }

  mapping(bytes32 => Targeting) private targetings;
  bytes32[] private index;

  event LogNewTargeting   (address advertiser, bytes32 indexed identifier, uint idx, bytes32 message, bytes32 placement, bytes32 audience, bool state);
  event LogUpdateTargeting(bytes32 indexed identifier, uint idx, bytes32 message, bytes32 placement, bytes32 audience, bool state);

  function TargetingStorage(address _messages, address _placements, address _audiences) {
    messages = MessageStorage(_messages);
    placements = PlacementStorage(_placements);
    audiences = AudienceStorage(_audiences);
    owner = tx.origin;
  }

  function exists(bytes32 identifier)
  public constant returns(bool isIndeed) {
    if (index.length == 0) return false;

    return (
      index[targetings[identifier].idx] == identifier
    );
  }

  function insert(address advertiser, bytes32 identifier, bytes32 message, bytes32 placement, bytes32 audience, bool state)
  public returns(uint idx) {
    require(!exists(identifier));
    require(messages.exists(message));
    require(placements.exists(placement));
    require(audiences.exists(audience));

    targetings[identifier].advertiser = advertiser;
    targetings[identifier].message = message;
    targetings[identifier].placement = placement;
    targetings[identifier].audience = audience;
    targetings[identifier].state = state;
    targetings[identifier].idx = index.push(identifier)-1;

    LogNewTargeting(
      advertiser,
      identifier,
      targetings[identifier].idx,
      message,
      placement,
      audience,
      state
    );

    return index.length-1;
  }

  function get(bytes32 identifier)
  public constant returns(address advertiser, bytes32 message, bytes32 placement, bytes32 audience, bool state, uint idx) {
    require(exists(identifier));

    return(
      targetings[identifier].advertiser,
      targetings[identifier].message,
      targetings[identifier].placement,
      targetings[identifier].audience,
      targetings[identifier].state,
      targetings[identifier].idx
    );
  }

  function updateMessage(bytes32 identifier, bytes32 message)
  public returns(bool success) {
    require(exists(identifier));
    require(messages.exists(message));

    targetings[identifier].message = message;

    LogUpdateTargeting(
      identifier,
      targetings[identifier].idx,
      message,
      targetings[identifier].placement,
      targetings[identifier].audience,
      targetings[identifier].state
    );

    return true;
  }

  function updatePlacement(bytes32 identifier, bytes32 placement)
  public returns(bool success) {
    require(exists(identifier));
    require(placements.exists(placement));

    targetings[identifier].placement = placement;

    LogUpdateTargeting(
      identifier,
      targetings[identifier].idx,
      targetings[identifier].message,
      placement,
      targetings[identifier].audience,
      targetings[identifier].state
    );

    return true;
  }

  function updateAudience(bytes32 identifier, bytes32 audience)
  public returns(bool success) {
    require(exists(identifier));
    require(audiences.exists(audience));

    targetings[identifier].audience = audience;

    LogUpdateTargeting(
      identifier,
      targetings[identifier].idx,
      targetings[identifier].message,
      targetings[identifier].placement,
      audience,
      targetings[identifier].state
    );

    return true;
  }

  function updateState(bytes32 identifier, bool state)
  public returns(bool success) {
    require(exists(identifier));

    targetings[identifier].state = state;

    LogUpdateTargeting(
      identifier,
      targetings[identifier].idx,
      targetings[identifier].message,
      targetings[identifier].placement,
      targetings[identifier].audience,
      state
    );

    return true;
  }

  function upsert(address advertiser, bytes32 identifier, bytes32 message, bytes32 placement, bytes32 audience, bool state)
  public returns(bool success) {
    if (exists(identifier)) {
      return (updateMessage(identifier, message) && updatePlacement(identifier, placement) && updateAudience(identifier, audience) && updateState(identifier, state));
    }
    return (insert(advertiser, identifier, message, placement, audience, state) > 0);
  }

  function count() public constant returns(uint) {
    return index.length;
  }

  function getAt(uint idx) public constant returns(bytes32) {
    return index[idx];
  }

}
