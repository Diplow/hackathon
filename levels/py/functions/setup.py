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
    for el in ['ArtefHack', 'DataProvider', 'Publisher', 'RolesStorage']:
        contract_metadata[el] = contract_deploy_data(el)
        network_id = list(contract_metadata[el]["networks"].keys())[-1]
        contract_instances[el] = web3.eth.contract(
    		contract_metadata[el]['abi'],
    		contract_metadata[el]["networks"][network_id]['address'],
    		ContractFactoryClass=ConciseContract
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

def setup_contents(whole_dataset, count):
    return whole_dataset[:count]

def set_roles(contract_instances, accounts):
    contract_instances['RolesStorage'].setRole(
        accounts[1],
        'Publisher',
        transact={'from':accounts[0], 'gas':100000}
    )
    contract_instances['RolesStorage'].setRole(
        accounts[2],
        'Advertiser',
        transact={'from':accounts[0], 'gas':100000}
    )
    for u in range(2, len(accounts)):
        contract_instances['RolesStorage'].setRole(
            accounts[u],
            'User',
            transact={'from':accounts[0], 'gas':100000}
        )


def insert_users(contract_instances, current_users, accounts, count):
    for el in current_users:
    	contract_instances['DataProvider'].insertUserData(
    		current_users[el]['preference'],
    		current_users[el]['likes_ads'],
    		transact={
    			'from':accounts[int(el)],
    			'gas': 200000
    		}
    	)

def insert_contents(contract_instances, current_contents, accounts, count):
    for el in current_contents:
    	contract_instances['Publisher'].insertContent(
    		bytearray(''.join(random.choices(string.ascii_uppercase, k=5)), 'utf-8'),
    		current_contents[el]['metadata'],
    		transact={
    			'from':accounts[0],
    			'gas': 200000
    		}
    	)

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
