pragma solidity ^0.4.4;

import '../utils/utils.sol';

contract RolesStorage {
  address owner;
  string[] authorizedRoles;
  mapping(address => string) rolesStorage;

  function RolesStorage(){
    owner = tx.origin;
    authorizedRoles = ['Advertiser', 'DataProvider', 'User', 'Publisher', 'ArtefHack'];
    setRole(tx.origin, 'Admin');
  }

  function setRole(address _from, string role){
    require(tx.origin == owner);
    require(isAuthorizedRole(role) || ((_from == owner) && (Utils.compare(role, 'Admin') == 0)));
    rolesStorage[_from] = role;
  }

  function getRole(address _from) returns (bytes32){
    return Utils.stringToBytes32(rolesStorage[_from]);
  }

  function isAuthorizedRole(string role) returns (bool isIndeed){
    for(uint i=0; i<authorizedRoles.length; i++){
      if(Utils.compare(role, authorizedRoles[i]) == 0){
        return true;
      }
    }
    return false;
  }

}
