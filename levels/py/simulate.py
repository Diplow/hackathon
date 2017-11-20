import json
from web3 import Web3, HTTPProvider
from web3.contract import ConciseContract

from functions.setup import *
from functions.simulation import *

provider = HTTPProvider('http://localhost:8545')
web3 = Web3(provider)

accounts = web3.eth.accounts
contract_instances = setup_contract_instances(web3)

# TODO move this to cli argument
FIRST_RUN = False

DAYS_COUNT = 10
PUBLISHER_COMPENSATION = 5
STARTING_USERS_COUNT = 10
STARTING_CONTENTS_COUNT = 10

# setup users and contents
users = load_data("users")
contents = load_data("contents")
users_contents_matrix = load_data("users_contents_matrix")
current_users = setup_users(users, STARTING_USERS_COUNT, 10)
current_contents = [contents[c]["id"] for c in range(0, STARTING_CONTENTS_COUNT)]

# insert users and contents
if FIRST_RUN:
	print('')
	print('Setup of the simulation')
	print('')
	print('Inserting users...')
	insert_users(
		contract_instances,
		current_users,
		accounts,
		STARTING_USERS_COUNT
	)
	print('Done! {} users have been created'.format(STARTING_USERS_COUNT))
	print('')

	print('Inserting contents...')
	insert_contents(
		contract_instances,
		current_contents,
		accounts,
		STARTING_CONTENTS_COUNT
	)
	print('Done! {} contents have been created'.format(STARTING_CONTENTS_COUNT))
	print('')

	print('Setting roles')
	set_roles(contract_instances, accounts)
	print('Done! Roles have been set for {} addresses'.format(len(accounts)))
	print('')

	print('Creating Advertiser')
	# create advertiser + setup her balance

print('')
print('Starting the simulation...')
print('')

visits, satisfied_visits, publisher_revenue, ad_views = [0] * 4
for i in range(0, DAYS_COUNT):

	print('Day {}'.format(i+1))
	d_visits, s_visits, d_pb_rvn, d_views = one_day(
		contract_instances,
		accounts,
		current_users,
		users,
		current_contents,
		contents,
		users_contents_matrix,
		PUBLISHER_COMPENSATION
	)

	visits += d_visits
	satisfied_visits += s_visits
	publisher_revenue += d_pb_rvn
	ad_views += d_views

log_results(visits, satisfied_visits, publisher_revenue, ad_views)
