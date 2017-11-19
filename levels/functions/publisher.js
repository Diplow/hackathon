var data = require('../data/test.js');

// TODO remove publisher address
function insertContent(contract, admin_address, content_metadata){
  contract.deployed(function(instance){
    instance.insertContent(content_metada, {from: admin_address, gas:100000})
    .then(console.log('Inserted content from publisher ' + address + ' contents ' + preference))
  });
}

exports.insertContents = function(contract, admin_address, contents){
  for(var content in contents){
    insertOneContent(contract, admin_address, data.contents[content]['publisher'], data.contents[content]['metadata']);
  }
}
