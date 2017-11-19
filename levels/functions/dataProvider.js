var data = require('../data/test.js');

function insertUserData(contract, user_address, preference, message){
  contract.deployed(function(instance){
    instance.insertUserData(preference, message, {from: user_address, gas:100000})
    .then(console.log('Inserted user ' + user_address + ' with preference ' + preference + ', and ' + message))
  });
}

exports.insertUsers = function(contract, users){
  for(var user in users){
    functions.insertOneUser(contract, data.users[user]['address'], data.users[user]['preference']);
  }
}
