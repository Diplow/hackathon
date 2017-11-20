#generate data here
import json
import math
import random
import string

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
