
exports.advertise = function(contract, advertiser_idx, views_count, advertiser_message){
  contract.deployed(function(instance){
    instance.advertise(views_count, advertiser_message, {from: accounts[advertiser_idx], gas:100000})
    .then(console.log('Advertiser ' + accounts[advertiser_idx] + 'bought ' + views_count + ' views'))
  });
}

exports.eval = function(contract, user_idx, feedback){
  contract.deployed(function(instance){
    instance.eval(feedback, {from: accounts[user_idx], gas:100000})
    .then(console.log('User ' + accounts[user_idx] + 'gave her feedback after she visited'))
  });
}

exports.visit = function(contract, user_idx){
  var content, message;
  contract.deployed(function(instance){
    instance.visit({from: accounts[user_idx], gas:100000})
    .then(function(c, m){
      content = c; message = m;
      console.log('User ' + accounts[user_idx] + 'visited ArtefHack');
    })
  });
  return content, message;
}
