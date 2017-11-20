// TEST FIRST LEVEL

// Import libraries we need.
import { default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them into usable abstractions.
import artefHack_artifacts from '../build/contracts/ArtefHack.json'
import dataProvider_artifacts from '../build/contracts/DataProvider.json'
import publisher_artifacts from '../build/contracts/Publisher.json'
import roles_artifacts from '../build/contracts/Role.json'

// output variables
var visits = 0;
var satisfied_visits = 0;
var publishers_revenue = 0;
var ad_views = 0;

export function simulate() {
	var DataProvider = contract(dataProvider_artifacts);
	var ArtefHack = contract(artefHack_artifacts);
	var Roles = contract(roles_artifacts);
	var Publisher = contract(publisher_artifacts);

	var data = require('./data/test.js');
	var setup = require('./functions/setup.js');
	var simulation = require('./functions/simulation.js');
	var artefHack = require('./functions/artefHack.js');
	var dataprovider = require('./functions/dataProvider.js');
	var role = require('./functions/role.js');
	var publisher = require('./functions/publisher.js');

	// setup the test environment
	var variables = setup.init_variables();
	var web3 = variables.web3;
	var accounts = variables.accounts;
	setup.setup_contracts(ArtefHack, DataProvider, Roles, Publisher, web3);
	role.setRoles(Roles, data.roles);

	// advertiser variables
	var advertiser = accounts[0];
	var advertiser_available_views = 0;

	// constants
	var NUMBER_OF_DAYS = 100;
	var ADVERTISER_BATCH_BUY_COUNT = 100;
	var PUBLISHER_PRICE = 5;

	// set up simulation
	// TODO verify current_users is right
	var current_users = setup.variable(data.users, 20);
	var current_contents = setup.variable(data.contents, 10);
	dataprovider.insertUsers(DataProvider, accounts, current_users);
	// publisher.insertContents(DataProvider, current_contents);
	//set advertiser + set advertiser balance (id dans content, private)

	// test your implementation!
	for(var i=0; i < NUMBER_OF_DAYS; i++){
		// simulate one day of the platform
		var one = simulation.one_day(advertiser, current_users, current_contents);
		var daily_visits = one[0];
		var daily_satisfied_visits = one[1];
		var daily_publisher_revenue = one[2];
		var daily_ad_views = one[3];
		// update output variables
		visits += daily_visits;
		satisfied_visits += daily_satisfied_visits;
		publishers_revenue += daily_publisher_revenue;
		ad_views += daily_ad_views;
	}
}

export function log(){
  var setup = require('./functions/setup.js');
  setup.log_results(visits, (satisfied_visits/visits)*100, publishers_revenue, ad_views);
}
