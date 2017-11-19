#generate data here
import json
import math
import random
from uuid import uuid4

ADVERTISER_COUNT = 1
PUBLISHERS_COUNT = 1
CONTENTS_COUNT = 100
USERS_COUNT = 1000

def xUsers():
    previous_accounts = ADVERTISER_COUNT + PUBLISHERS_COUNT
    for i in range(previous_accounts, USERS_COUNT + previous_accounts):
        yield str(i), {
          "preference": random.randint(0, 100),
          "message": True if 10 * random.random() > 5 else False,
          "will_visit_next": True,
          "seen_contents" : [],
          "satisfaction": 0
        }

def xContents():
    for i in range(CONTENTS_COUNT):
        yield uuid4(), {
            "preference": random.randint(0, 100)
        }

def generate_users(publisher_count, user_count):
    with open('./users.js' ,'w') as f:
        users = {i: usr for i, usr in xUsers()}
        f.write('var users = {}'.format(json.dumps(users)))

# TODO contents ids are bytes32!!!
def generate_contents(publisher_count, contents_count):
    with open('./contents.js' ,'w') as f:
        contents = {i: content for i, content in xContents()}
        f.write('var contents = {}'.format(json.dumps(contents)))


def generate_users_contents_matrix():
    users_content_matrix = {}
    with open('./users.json') as u, open('./contents.json') as c:
        users = json.load(u)["users"]
        contents = json.load(c)["contents"]
        for i in range(0, len(users)):
            users_content_matrix[str(users.keys()[i])] = {}
            for j in range(0, len(contents)):
                users_content_matrix[str(users.keys()[i])][str(contents.keys()[j])] = 1 if (math.fabs(users[users.keys()[i]]["preference"] - contents[contents.keys()[j]]["metadata"]) < 10) else 0

    with open('./users_contents_matrix.json', 'w') as f:
        json.dump(users_content_matrix, f)

generate_users(PUBLISHERS_COUNT, USERS_COUNT)
generate_contents(PUBLISHERS_COUNT, CONTENTS_COUNT)
generate_users_contents_matrix()
