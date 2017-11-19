#generate data here
import json
import math
import random

PUBLISHERS_COUNT = 10
CONTENTS_COUNT = 100
USERS_COUNT = 1000

def generate_users(publisher_count, user_count):
    users = {
        "users": {}
    }
    for i in range(publisher_count, user_count + publisher_count):
        users["users"][str(i)] = {
          "preference": random.randint(0, 100),
          "likes_ads": True if 10 * random.random() > 5 else False,
          "will_visit_next": True,
          "seen_contents" : [],
          "satisfaction": 0
        }

    with open('./users.json' ,'w') as f:
        json.dump(users, f);

def generate_contents(publisher_count, contents_count):
    contents = {
        "contents": {}
    }
    for i in range(0, contents_count):
        contents["contents"][str(i)] = {
            "publisher": random.randint(2, 2 + publisher_count),
            "metadata": random.randint(0, 100)
        }
    with open('./contents.json', 'w') as f:
        json.dump(contents, f)

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
