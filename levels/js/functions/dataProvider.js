var data = require('../data/test.js');

var insertUserData = async function(contract, user_address, preference, message){

  let meta = await contract.deployed();
  let fun = meta.insertUserData(preference, message, {from: user_address, gas:1000000});
  console.log('Inserted user ' + user_address + ' with preference ' + preference + ', and ' + message)

  // contract.deployed(function(instance){
  //   instance.insertUserData(preference, message, {from: user_address, gas:100000})
  //   .then(console.log('Inserted user ' + user_address + ' with preference ' + preference + ', and ' + message))
  // });
}

exports.insertUsers = function(contract, accounts, users){
  for(var user in users){
    if(data.users[user] != undefined){
      insertUserData(contract, accounts[user], data.users[user]['preference'], data.users[user]['likes_ads']);
    }
  }
}
