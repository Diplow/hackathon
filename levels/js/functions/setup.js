import { default as Web3} from 'web3';

exports.setup_contracts = function(artefHack, dataProvider, publisher, roles, web3) {
  artefHack.setProvider(web3.currentProvider);
  dataProvider.setProvider(web3.currentProvider);
  publisher.setProvider(web3.currentProvider);
  roles.setProvider(web3.currentProvider);
}

exports.init_variables = function(){
  var web3;
  var accounts;
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  accounts = web3.eth.accounts;
  return {
    web3: web3,
    accounts:accounts
  };
}

function generate_score(visits, user_satisfaction_rate, publishers_revenue, ad_views){
  // insert very smart formula here
  return visits + user_satisfaction_rate + publishers_revenue + ad_views;
}

exports.variable = function(variable, count){
  var sliced = {};
  for (var i=0; i < count; i++){
    sliced[i] = variable[i];
  }
  return sliced;
}

exports.log_results = function(visits, user_satisfaction_rate, publishers_revenue, ad_views){
  console.log('Your implementation generated ' + visits + ' user visits, '
  + ' with a ' + user_satisfaction_rate +  ' user satisfaction rate, '
  + publishers_revenue + ' tokens for publishers, and '
  + ad_views + ' ad views for the advertiser!');
  console.log('Your score is : ' +
  generate_score(visits, user_satisfaction_rate, publishers_revenue, ad_views));
}
