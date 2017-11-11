pragma solidity ^0.4.4;

import '../utils/utils.sol';

contract Role {
  address owner;
  string[] authorizedRoles;
  mapping(address => string) rolesStorage;

  function Role() {
    owner = tx.origin;
    authorizedRoles = ['Advertiser', 'DataProvider', 'User', 'Publisher'];
    setRole(tx.origin, 'Admin');
  }

  function setRole(address _from, string role){
    require(isAuthorizedRole(role) || ((_from == owner) && (Utils.compare(role, 'Admin') == 0)));
    rolesStorage[_from] = role;
  }

  function getRole(address _from) returns (string){
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
