#generate data here
import json
from math import fabs
import numpy as np
import random
import string

ADVERTISER_COUNT = 1
PUBLISHERS_COUNT = 1
CONTENTS_COUNT = 600
USERS_COUNT = 1000

def generate_users(publisher_count, user_count):
    with open('./users.json' ,'w') as f:
        users = {"users":{}}
        users["users"] = {
            i: usr for i, usr in xUsers(
                generate_preferences(user_count)
            )
        }
        json.dump(users, f)

def xUsers(preferences):
    previous_accounts = ADVERTISER_COUNT + PUBLISHERS_COUNT + 1 + 1 # ArtefHack and Admin accounts
    for i in range(previous_accounts, USERS_COUNT + previous_accounts):
        yield str(i), {
          "preference": preferences[i-previous_accounts],
          "message": True if 10 * random.random() > 3 else False,
          "seen_contents" : [],
          "satisfaction": 0,
          "failures": 0
        }

def generate_preferences(TOTAL_USERS_COUNT):
    # generate our skewed user base
    pop1 = [int(round(i)) for i in np.random.normal(20, 5, int(0.15*TOTAL_USERS_COUNT))]
    pop2 = [int(round(i)) for i in np.random.normal(45, 4, int(0.25*TOTAL_USERS_COUNT))]
    pop3 = [int(round(i)) for i in np.random.normal(80, 3, int(0.3*TOTAL_USERS_COUNT))]
    random_rest = [random.randint(0, 99) for i in range(0, int(0.3*TOTAL_USERS_COUNT))]

    tot_users = pop1 + pop2 + pop3 + random_rest
    random.shuffle(tot_users)
    return tot_users

def generate_contents(publisher_count, contents_count):
    contents = {
        "contents": []
    }
    for i in range(0, contents_count):
        contents["contents"].append({
            "id": ''.join(random.choices(string.ascii_uppercase, k=10)),
            "preference": random.randint(0, 99)
        })
    with open('./contents.json', 'w') as f:
        json.dump(contents, f)

def generate_users_contents_matrix():
    users_content_matrix = {
        "users_contents_matrix": {}
    }
    with open('./users.json') as u, open('./contents.json') as c:
        users = json.load(u)["users"]
        contents = json.load(c)["contents"]
        for us in users:
            users_content_matrix["users_contents_matrix"][us] = {}
            for co in contents:
                users_content_matrix["users_contents_matrix"][us][co["id"]] = 1 if (fabs(users[us]["preference"] - co["preference"]) < 10) else 0

    with open('./users_contents_matrix.json', 'w') as f:
        json.dump(users_content_matrix, f)

generate_users(PUBLISHERS_COUNT, USERS_COUNT)
generate_contents(PUBLISHERS_COUNT, CONTENTS_COUNT)
generate_users_contents_matrix()
