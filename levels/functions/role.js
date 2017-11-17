var data = require('../data/test.js');

function setOneRole(contract, admin_address, user_address, role) {
  contract.deployed()
  .then(function(instance){
    instance.setRole(user_address, role, {from: admin_address, gas:100000})
    .then(console.log('Role ' + role + ' set for user ' + user_address))
  });
}

exports.setRoles = function(contract, admin_address, accounts, roles){
  for(var user in roles){
    setOneRole(contract, admin_address, accounts[user], data.roles[user]);
  }
}
