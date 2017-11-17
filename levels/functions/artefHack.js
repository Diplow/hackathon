
function advertise(contract, advertiser_address, views_count, advertiser_message){
  contract.deployed(function(instance){
    instance.advertise(views_count, advertiser_message, {from: advertiser_address, gas:100000})
    .then(console.log('Advertiser ' + advertiser_address + 'bought views'))
  });
}

function eval(contract, user_address, feedback){
  contract.deployed(function(instance){
    instance.eval(feedback, {from: user_address, gas:100000})
    .then(console.log('User ' + user_address + 'gave her feedback after she visited'))
  });
}

function visit(contract, user_address){
  var content, message;
  contract.deployed(function(instance){
    instance.visit({from: user_address, gas:100000})
    .then(function(c, m){
      content = c; message = m;
      console.log('User ' + user_address + 'visited ArtefHack');
    })
  });
  return content, message;
}
