from web3.contract import ConciseContract
import json
import random
import string

def contract_deploy_data(contract):
	with open('../../build/contracts/{}.json'.format(contract)) as f:
		deploy_data = json.load(f)
	return deploy_data

def setup_contract_instances(web3):
    contract_metadata = {}
    contract_instances = {}
    for el in ['ArtefHack', 'Balances', 'DataProvider', 'Publisher', 'RolesStorage']:
        contract_metadata[el] = contract_deploy_data(el)
        network_id = list(contract_metadata[el]["networks"].keys())[-1]
        contract_instances[el] = web3.eth.contract(
    		contract_metadata[el]['abi'],
    		contract_metadata[el]["networks"][network_id]['address']
    	)
    return contract_instances

def load_data(variable):
    with open('./data/{}.json'.format(variable)) as f:
    	data = json.load(f)[variable]
    return data

def setup_users(whole_dataset, count, overhead=0):
    data = {}
    for i in range(overhead, overhead + count):
    	data[str(i)] = {}
    	data[str(i)] = whole_dataset[str(i)]
    return data

# we might not allow users to sell their data
# def insert_users(contract_instances, current_users, accounts, count):
#     for el in current_users:
#     	contract_instances['DataProvider'].insertUserData(
#     		current_users[el]['preference'],
#     		current_users[el]['likes_ads'],
#     		transact={
#     			'from':accounts[int(el)],
#     			'gas': 200000
#     		}
#     	)

def insert_contents(contract_instances, contents, admin_address):
    for el in contents:
    	contract_instances['Publisher'].transact({
			'from':admin_address,
			'gas': 200000
		}).insertContent(
    		bytearray(el['id'], 'utf-8'),
    		el['preference']
    	)

def set_stakeholders(contract_instances, accounts):
	contract_instances['ArtefHack'].transact({'from': accounts[0], 'gas':200000}).setArtefHack(accounts[1])
	contract_instances['Publisher'].transact({'from': accounts[0], 'gas':200000}).setPublisher(accounts[2])

def set_roles(contract_instances, accounts):
	for idx, role in enumerate(['ArtefHack', 'Publisher', 'Advertiser']):
	    contract_instances['RolesStorage'].transact({
			'from':accounts[0],
			'gas':100000}
		).setRole(accounts[idx + 1], role)
	for u in range(4, len(accounts)):
	    contract_instances['RolesStorage'].transact({
			'from':accounts[0],
			'gas':100000}
		).setRole(accounts[u], 'User')

def set_balances(contract_instances, accounts):
	# create balances for all addresses
	for ad in accounts:
		contract_instances['Balances'].transact({'from': accounts[0], 'gas':1000000}).create(ad)

	# fund admin's balance
	contract_instances['Balances'].transact({'from': accounts[0], 'gas':1000000}).fund(1000000)

	# set initial balance for stakeholders
	contract_instances['Balances'].transact({'from': accounts[0], 'gas':100000}).pay(accounts[0], accounts[1], 1000)
	contract_instances['Balances'].transact({'from': accounts[0], 'gas':100000}).pay(accounts[0], accounts[3], 50000)

	# set initial balance for all other users
	for u in range(4, len(accounts)):
		contract_instances['Balances'].transact({'from': accounts[0], 'gas':100000}).pay(accounts[0], accounts[u], 50)

def log_results(visits, satisfied_visits, publisher_revenue, ad_views):
    print('')
    print('Done!')
    print('')
    print(
        'Your implementation generated {} visits with a {} % satisfaction rate, {} token revenue for the publisher, and {} ad views!'.format(
            visits,
            round((satisfied_visits / visits) * 100),
            publisher_revenue,
            ad_views
        )
    )

    print(
        'Your score is {}'.format(
        generate_score(visits, satisfied_visits, publisher_revenue, ad_views)
        )
    )
    print('')

def generate_score(visits, satisfied_visits, publisher_revenue, ad_views):
    # TODO improve score calculation formula
    return visits + satisfied_visits + publisher_revenue + ad_views
