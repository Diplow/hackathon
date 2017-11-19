


// exports.advertise = function(contract, advertiser_idx, views_count, advertiser_message){
//   contract.deployed(function(instance){
//     instance.advertise(views_count, advertiser_message, {from: accounts[advertiser_idx], gas:100000})
//     .then(console.log('Advertiser ' + accounts[advertiser_idx] + 'bought ' + views_count + ' views'))
//   });
// }

// TODO verify we don't need to pass accounts in argument

// add content id to eval fct
exports.eval = function(contract, user_idx, content, score){
  contract.deployed(function(instance){
    instance.eval(content, score, {from: accounts[user_idx], gas:100000})
    .then(console.log('User ' + accounts[user_idx] + 'gave her feedback after she visited'))
  });
}

// verfiy that message is a boolean
exports.visit = function(contract, user_idx){
  var content, message;
  contract.deployed(function(instance){
    instance.visit({from: accounts[user_idx], gas:100000})
    .then(function(c, m){
      content = c; message = m;
      console.log('User ' + accounts[user_idx] + 'visited ArtefHack and got: ' + content + 'and msg: ' + string(message));
    })
  });
  return content, message;
}
