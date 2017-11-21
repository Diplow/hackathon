
SATISFACTION_TO_GROW_USER_BASE = 3
AD_VIEW_PRICE = 10

# NB : accounts[0] => Admin address
#      accounts[1] => ArtefHack address
#      accounts[2] => Publisher address
#      accounts[3] => Advertiser address

def one_day(contract_instances, accounts, current_users, users, current_contents, contents, users_contents_matrix):

    daily_visits, daily_satisfied_visits, daily_ad_views = [0] * 3
    for u in current_users:

        if current_users[u]['satisfaction'] >= 0:
            # the user interacts with our platform
            visited_content, message = visit(contract_instances, accounts[int(u)], accounts[3], accounts[1])
            evaluate(contract_instances, visited_content, accounts[int(u)], u, users_contents_matrix)

            # update output variables
            daily_visits += 1
            daily_ad_views += 1 if message else 0
            sat = adjust_user_satisfaction(visited_content, message, u, current_users, users_contents_matrix)
            daily_satisfied_visits += sat

            # append the seen content to current_contents
            update_contents(visited_content, current_contents)
            # the user base grows if the users like it
            update_user_base(u, current_users, users)
        else:
            current_users[u]['satisfaction'] = 0
    return (daily_visits, daily_satisfied_visits, daily_ad_views)

def visit(contract_instances, user_address, advertiser_address, artefhack_address):
    # call to get the results of our query
    visited_content, message = contract_instances['ArtefHack'].call({'from':user_address, 'gas': 200000}).visit()
    # transaction to insert our query in the blockchain
    contract_instances['ArtefHack'].transact({'from':user_address, 'gas': 200000}).visit()

    # the advertiser pays ArtefHack if a message is shown
    if message:
        contract_instances['Balances'].transact(
            {'from': advertiser_address, 'gas':100000}
        ).pay(
            advertiser_address, artefhack_address, AD_VIEW_PRICE
        )

    return (visited_content, message)

def evaluate(contract_instances, visited_content, user_address, user_index, users_contents_matrix):
    contract_instances['ArtefHack'].transact({'from': user_address, 'gas': 100000}).eval(
        visited_content,
        users_contents_matrix[user_index][visited_content.replace('\x00', '')],
        )

def update_contents(visited_content, current_contents):
    if visited_content.replace('\x00', '') not in current_contents:
        current_contents.append(visited_content.replace('\x00', ''))


def adjust_user_satisfaction(visited_content, message, user_index, current_users, users_contents_matrix):
    if(visited_content.replace('\x00', '') in current_users[user_index]['seen_contents']):
        current_users[user_index]['satisfaction'] -= 1
        return 0
    # TODO false condition
    elif (message and not current_users[user_index]['message']) or (users_contents_matrix[user_index][visited_content.replace('\x00', '')] == 1):
        add_user_content(visited_content, user_index, current_users)
        current_users[user_index]['satisfaction'] += 1
        return 1
    else:
        add_user_content(visited_content, user_index, current_users)
        current_users[user_index]['satisfaction'] -= 1
        current_users[user_index]['failures'] += 1
        return 0

def add_user_content(visited_content, user_index, current_users):
    current_users[user_index]['seen_contents'].append(
        visited_content.replace('\x00', '')
    )

def update_user_base(user_index, current_users, users):
    # if a user is very satisfied with the platform, she will recommend it to friends
    if current_users[user_index]['satisfaction'] >= SATISFACTION_TO_GROW_USER_BASE:
        current_users[str(len(current_users))] = users[str(len(current_users))]

    # if a user is very disatisfied with the platform, she will never use it again
    elif current_users[user_index]['failures'] >= 5:
        del current_users[user_index]

def get_publisher_revenue(contract_instances, publisher_address):
    P_b = contract_instances['Balances'].call(
        {'from': publisher_address, 'gas':200000}
    ).getBalance(
        publisher_address
    )
    return P_b
