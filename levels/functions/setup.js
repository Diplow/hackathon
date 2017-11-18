import { default as Web3} from 'web3';

exports.setup_contracts = function(artefHack, dataProvider, publisher, roles, web3) {
  artefHack.setProvider(web3.currentProvider);
  dataProvider.setProvider(web3.currentProvider);
  publisher.setProvider(we3.currentProvider);
  roles.setProvider(web3.currentProvider);
}

exports.init_variables = function(){
  var web3;
  var accounts;
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  accounts = web3.eth.accounts;
  return (web3, accounts);
}

exports.generate_score = function(visits, user_satisfaction_rate, publishers_revenue, ad_views){
  // insert very smart formula here
  return 12;
}

exports.variable = function(variable, count){
  return variable.slice(0, count);
}

exports.log_results = function(visits, user_satisfaction_rate, publishers_revenue, ad_views){
  console.log('Your implementation generated ' + visits + ' user visits, '
  + ' with a ' + user_satisfaction_rate +  ' user satisfaction rate, '
  + publishers_revenue + ' tokens for publishers, and '
  + ad_views + ' ad views for the advertiser!');
  console.log('Your score is : ' +
  setup.generate_score(visits, user_satisfaction_rate, publishers_revenue, ad_views));
}
