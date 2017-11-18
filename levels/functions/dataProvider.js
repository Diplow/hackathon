var data = require('../data/test.js');

function insertOneUser: function(contract, admin_address, user_address, preference){
  contract.deployed(function(instance){
    instance.insertUser(user_address, preference, {from: admin_address, gas:100000})
    .then(console.log('Inserted user ' + user_address + ' with preference ' + preference))
  });
}

exports.inserUsers = function(contract, users){
  for(var user in users){
    functions.insertOneUser(contract, data.users[user]['address'], data.users[user]['preference']);
  }
}
