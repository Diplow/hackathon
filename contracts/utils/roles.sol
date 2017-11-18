pragma solidity ^0.4.4;

import '../utils/utils.sol';

contract Role {
  address public owner;
  string[] public authorizedRoles;
  mapping(address => string) public rolesStorage;

  function Role() {
    owner = tx.origin;
    authorizedRoles = ['Advertiser', 'DataProvider', 'User', 'Publisher', 'ArtefHack'];
    setRole(tx.origin, 'Admin');
  }

  function setRole(address _from, string role) returns (bool success) {
    require(isAuthorizedRole(role) || ((_from == owner) && (Utils.compare(role, 'Admin') == 0)));
    rolesStorage[_from] = role;
    return true;
  }

  function getRole(address _from) returns (string role){
    return rolesStorage[_from];
  }

  function isAuthorizedRole(string role) returns (bool isIndeed){
    for(uint i=0; i<authorizedRoles.length; i++){
      if(Utils.compare(role, authorizedRoles[i]) == 0){
        return true;
      }
    }
    return false;
  }

  modifier isRole(string role){
    require(isAuthorizedRole(role));
    require(Utils.compare(rolesStorage[tx.origin], role) == 0);

    _;
  }
}
