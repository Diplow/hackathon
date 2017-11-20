def one_day(contract_instances, accounts, current_users, users, current_contents, contents, users_contents_matrix, publisher_compensation):

    daily_visits, daily_satisfied_visits, daily_publisher_revenue, daily_ad_views = [0] * 4
    for u in current_users:

        if current_users[u]['satisfaction'] >= 0:
            # the user interacts with our platform
            visited_content, message = visit(contract_instances, accounts[int(u)])
            evaluate(contract_instances, visited_content, accounts[int(u)], u, users_contents_matrix)

            # update output variables
            daily_visits += 1
            daily_publisher_revenue += add_new_contents(visited_content, current_contents)
            daily_ad_views += 1 if message else 0
            sat = adjust_user_satisfaction(visited_content, message, u, current_users, users_contents_matrix)
            daily_satisfied_visits += sat

            # the user base grows if the users like it
            grow_user_base(u, current_users, users)
        else:
            current_users[u]['satisfaction'] = 0
    return (daily_visits, daily_satisfied_visits, daily_publisher_revenue, daily_ad_views)

def visit(contract_instances, user_address):
    # call to get the results of our query
    visited_content, message = contract_instances['ArtefHack'].visit(
        call={'from':user_address, 'gas': 100000})
    # transaction to insert our query in the blockchain
    contract_instances['ArtefHack'].visit(
        transact={'from':user_address, 'gas': 100000})
    return (visited_content, message)

def evaluate(contract_instances, visited_content, user_address, user_index, users_contents_matrix):
    contract_instances['ArtefHack'].eval(
        visited_content,
        users_contents_matrix[user_index][visited_content.replace('\x00', '')],
        transact={'from': user_address, 'gas': 100000})

def add_new_contents(visited_content, current_contents):
    if visited_content.replace('\x00', '') not in current_contents:
        current_contents.append(contents[len(current_contents)]["id"])
        return publisher_compensation
    else:
        return 0

def adjust_user_satisfaction(visited_content, message, user_index, current_users, users_contents_matrix):
    if(visited_content.replace('\x00', '') in current_users[user_index]['seen_contents']):
        current_users[user_index]['satisfaction'] -= 1
        return 0
    elif (message and not current_users[user_index]['likes_ads']) or (users_contents_matrix[user_index][visited_content.replace('\x00', '')] == 1):
        add_content(visited_content, user_index, current_users)
        current_users[user_index]['satisfaction'] += 1
        return 1
    else:
        add_content(visited_content, user_index, current_users)
        current_users[user_index]['satisfaction'] -= 1
        return 0

def add_content(visited_content, user_index, current_users):
    current_users[user_index]['seen_contents'].append(
        visited_content.replace('\x00', '')
    )

def grow_user_base(user_index, current_users, users):
    if current_users[user_index]['satisfaction'] > 2:
        current_users[str(len(current_users))] = users[str(len(current_users))]
