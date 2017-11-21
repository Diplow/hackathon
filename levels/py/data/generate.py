#generate data here
import json
import math
import random
import string

ADVERTISER_COUNT = 1
PUBLISHERS_COUNT = 1
CONTENTS_COUNT = 100
USERS_COUNT = 1000

def xUsers():
    previous_accounts = ADVERTISER_COUNT + PUBLISHERS_COUNT + 1 + 1 # ArtefHack and Admin
    for i in range(previous_accounts, USERS_COUNT + previous_accounts):
        yield str(i), {
          "preference": random.randint(0, 100),
          "message": True if 10 * random.random() > 3 else False,
          "seen_contents" : [],
          "satisfaction": 0,
          "failures": 0
        }

def generate_users(publisher_count, user_count):
    with open('./users.json' ,'w') as f:
        users = {"users":{}}
        users["users"] = {i: usr for i, usr in xUsers()}
        json.dump(users, f)

def generate_contents(publisher_count, contents_count):
    contents = {
        "contents": []
    }
    for i in range(0, contents_count):
        contents["contents"].append({
            "id": ''.join(random.choices(string.ascii_uppercase, k=10)),
            "preference": random.randint(0, 100)
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
                users_content_matrix["users_contents_matrix"][us][co["id"]] = 1 if (math.fabs(users[us]["preference"] - co["preference"]) < 10) else 0

    with open('./users_contents_matrix.json', 'w') as f:
        json.dump(users_content_matrix, f)

generate_users(PUBLISHERS_COUNT, USERS_COUNT)
generate_contents(PUBLISHERS_COUNT, CONTENTS_COUNT)
generate_users_contents_matrix()
