// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import dataProvider_artifacts from '../build/contracts/DataProvider.json'
import publisher_artifacts from '../build/contracts/Publisher.json'
import advertiser_artifacts from '../build/contracts/Advertiser.json'

var DataProvider = contract(dataProvider_artifacts);
var Publisher = contract(publisher_artifacts);
var Advertiser = contract(advertiser_artifacts);

var web3;
var accounts;

function setUpWeb3() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }
}

function setupTest() {
  DataProvider.setProvider(web3.currentProvider);
  Publisher.setProvider(web3.currentProvider);
  Advertiser.setProvider(web3.currentProvider);
  accounts = web3.eth.accounts;
}

function setRole(accounts, index, role) {
  // all base contracts inherit from Role
  DataProvider.deployed()
  .then(function(contract){
    contract.setRole(accounts[index], role, {from: accounts[0], gas:100000})
    .then(console.log('Role ' + role + ' set for user ' + accounts[index].toString()))
  });
}

function getRole(account) {
  // all base contracts inherit from Role
  DataProvider.deployed()
  .then(function(contract){
    contract.getRole.call(account, {from: accounts[0], gas:100000})
    .then(function(resp){console.log('User ' + account + ' has role ' + resp)})
  });
}

export function firstLevel() {
  setUpWeb3();
  setupTest();

  // generate more accounts at the deployment of testrpc with --account option
  // ex: testrpc --accounts 1000

  // set roles for further use
  setRole(accounts, 0, 'Admin');
  setRole(accounts, 1, 'User');
  setRole(accounts, 2, 'User');
  setRole(accounts, 3, 'User');
  setRole(accounts, 4, 'DataProvider');
  setRole(accounts, 5, 'Publisher');

  // teenee tiny verification
  // getRole(accounts[2]);
  // getRole(accounts[5]);

  // users set their data

  // publishers create placements

  // advertisers create messages

  // advertisers create audiences

  // advertisers set up targetings

  // and voila! users should visit now
  // ----- TEST CASE 1 -----
  // ----- TEST CASE 2 -----
  // ----- TEST CASE 3 -----
  // --------- ETC ---------
}

