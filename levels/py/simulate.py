import json
from web3 import Web3, HTTPProvider

from functions.setup import *
from functions.simulation import *

provider = HTTPProvider('http://localhost:8545')
web3 = Web3(provider)

accounts = web3.eth.accounts
contract_instances = setup_contract_instances(web3)

# TODO move this to cli argument
FIRST_RUN = True

DAYS_COUNT = 2
STARTING_USERS_COUNT = 50

# setup users and contents
users = load_data("users")
contents = load_data("contents")
users_contents_matrix = load_data("users_contents_matrix")
current_users = setup_users(users, STARTING_USERS_COUNT, 4)
# there are no contents in the platform at the start of the simulation
current_contents = []

# insert users and contents
if FIRST_RUN:
	print('')
	print('\033[1mSetup of the simulation\033[0m')
	print('')

	# we might not make users able to sell their data
	# TODO remove DataProvider.sol?
	# print('Inserting users...')
	# insert_users(
	# 	contract_instances,
	# 	current_users,
	# 	accounts,
	# 	STARTING_USERS_COUNT
	# )
	# print('Done! {} users have been created'.format(STARTING_USERS_COUNT))
	# print('')

	# make contents available in the catalogue
	print('Inserting contents...')
	insert_contents(contract_instances, contents, accounts[0])
	print('Done! {} contents have been created'.format(len(contents)))
	print('')

	print('Setting ArtefHack and Publisher addresses')
	set_stakeholders(contract_instances, accounts)
	print('Done!')
	print('')

	print('Setting roles')
	set_roles(contract_instances, accounts)
	print('Done! Roles have been set for {} addresses'.format(len(accounts)))
	print('')

	print('Setting and funding balances')
	set_balances(contract_instances, accounts)
	print('Done! ArtefHack received 1000 tokens, the Advertiser received 50000 tokens, and each user received 10 tokens')
	print('')


print('')
print('\033[1mStarting the simulation...\033[0m')
print('Target : {} days'.format(DAYS_COUNT))
print('')

visits, satisfied_visits, ad_views = [0] * 3
for i in range(0, DAYS_COUNT):

	print('Day {}'.format(i+1))
	d_visits, s_visits, d_views = one_day(
		contract_instances,
		accounts,
		current_users,
		users,
		current_contents,
		contents,
		users_contents_matrix
	)

	visits += d_visits
	satisfied_visits += s_visits
	ad_views += d_views

log_results(
	visits,
	satisfied_visits,
	get_publisher_revenue(contract_instances, accounts[2]),
	ad_views
)
