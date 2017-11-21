from web3 import Web3, HTTPProvider
import json

provider = HTTPProvider('http://localhost:8545')
web3 = Web3(provider)
with open('../../build/contracts/Publisher.json') as f:
	publisher_contract = json.load(f)

with open('../../build/contracts/Balances.json') as f:
	balances_contract = json.load(f)

with open('../../build/contracts/artefHack.json') as f:
	artefhack_contract = json.load(f)

with open('../../build/contracts/RolesStorage.json') as f:
	roles_contract = json.load(f)

with open('../../build/contracts/Catalogue.json') as f:
	catalogue_contract = json.load(f)

accounts = web3.eth.accounts

print('setup contract')
balances = web3.eth.contract(balances_contract['abi'], balances_contract["networks"]["1511268726732"]["address"])
roles = web3.eth.contract(roles_contract['abi'], roles_contract["networks"]["1511268726732"]["address"])
artefhack = web3.eth.contract(artefhack_contract['abi'], artefhack_contract["networks"]["1511268726732"]["address"])
publisher = web3.eth.contract(publisher_contract['abi'], publisher_contract["networks"]["1511268726732"]["address"])
catalogue = web3.eth.contract(catalogue_contract['abi'], catalogue_contract["networks"]["1511268726732"]["address"])

print('setup advertiser and artefhack addresses')
artefhack.transact({'from': accounts[0], 'gas':1000000}).setArtefHack(accounts[1])
publisher.transact({'from': accounts[0], 'gas':1000000}).setPublisher(accounts[2])
print('create balances')
balances.transact({'from': accounts[0], 'gas':1000000}).create(accounts[1])
balances.transact({'from': accounts[0], 'gas':1000000}).create(accounts[2])
print('fund artefhack')
balances.transact({'from': accounts[0], 'gas':1000000}).fund(10000)
balances.transact({'from': accounts[0], 'gas':1000000}).pay(accounts[0], accounts[1], 10000)
print('create artefhack role')
roles.transact({'from': accounts[0], 'gas':100000}).setRole(accounts[1], 'ArtefHack')
print('insert one content')
print(publisher.call({'from': accounts[0], 'gas':1000000}).insertContent(bytearray('02104123079', 'utf-8'), 12))
publisher.transact({'from': accounts[0], 'gas':1000000}).insertContent(bytearray('02104123079', 'utf-8'), 12)
print('')
print('')


# def hey(ohboi):
# 	print(ohboi)
# artefhack.on('Publish', {}, hey)
print(artefhack.call({'from': accounts[5], 'gas': 1000000}).visit())
artefhack.transact({'from': accounts[5], 'gas': 1000000}).visit()

# print(catalogue.call({'from': accounts[0]}).get(0))
# print(publisher.transact({'from': accounts[1], 'gas': 1000000}).buyContent(0))
