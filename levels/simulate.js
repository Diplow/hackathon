// TEST FIRST LEVEL

// Import libraries we need.
import { default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them into usable abstractions.
import artefHack_artifacts from '../build/contracts/ArtefHack.json'
import dataProvider_artifacts from '../build/contracts/DataProvider.json'
import roles_artifacts from '../build/contracts/Role.json'

function simulate() {
	var DataProvider = contract(dataProvider_artifacts);
	var ArtefHack = contract(artefHack_artifacts);
	var Roles = contract(roles_artifacts);

	var data = require('./data/test.js')
	var setup = require('./functions/setup.js')
	var simulation = require('./functions/simulation.js')
	var artefHack = require('./functions/artefHack.js')
	var dataprovider = require('./functions/dataProvider.js')

	// setup the test environment
	var accounts, web3;
	web3, accounts = setup.init_variables();
	setup.setup_contracts(ArtefHack, DataProvider, Roles, web3);
	role.setRoles(Roles, data.roles);

	// advertiser variables
	var advertiser = accounts[0];
	var advertiser_available_views = 0;

	// constants
	var NUMBER_OF_DAYS = 100;
	var ADVERTISER_BATCH_BUY_COUNT = 100;
	var PUBLISHER_PRICE = 5;

	// output variables
	var visits = 0;
	var satisfied_visits = 0;
	var publisheds_revenue = 0;
	var ad_views = 0;

	// set up simulation
	var current_users = setup.variable(data.users, 1000);
	var current_contents = setup.variable(data.contents, 100);
	dataprovider.insertUsers(DataProvider, current_users);
	publisher.insertContents(DataProvider, current_contents);

	// test your implementation!
	for(var i=0; i < NUMBER_OF_DAYS; i++){
	  // simulate one day of the platform
	  var daily_visits, daily_satisfied_visits, daily_publisher_revenue, daily_ad_views = simulation.one_day(advertiser, current_users, current_contents);
	  // update output variables
	  visits += daily_visits;
	  satisfied_visits += daily_satisfied_visits;
	  publisheds_revenue += daily_publisher_revenue;
	  ad_views += daily_ad_views;
	}
	setup.log_results(visits, (satisfied_visits/visits)*100, publishers_revenue, ad_views);

}
