// USERS
// example
users = [
  user
];
user = {
  'address': 'adr',
  'preference': 20,
  'likes_ads': false,
  'will_visit_next': true,
  'seen_contents' : [2, 5, 4],
  'satisfaction': 0
};

// CONTENTS
// example
contents = [
  content
];
content = {
  'publisher': 'adr',
  'metadata': 30
};

// USERS VS contents
user_content_matrix = {
  3: {1:0, 2:1, 3:0},
  4: {1:1, 2:0, 3:1}
}

// ROLES
roles = [
  'Admin',
  'Advertiser',
  'Publisher',
  'Publisher',
  'Publisher',
  'User',
  'User'
];
