
var data = require('../data/test.js')

// TODO current_users, current_contents

exports.one_day = function(advertiser, available_views, users, contents){
  advertise(advertiser, available_views);
  return visits(users, contents);
}

// simulation of one day of users visits
function visits(users, contents){
  var daily_visits = 0;
  var daily_satisfied_visits = 0;
  var daily_publisher_revenue = 0;
  var daily_ad_views = 0;

  for(var i=0; i<users.length; i++){

    if(data.users[users[i]]['will_visit_next']){
      var content, message, publisher_revenue, views;

      content, message, publisher_revenue, views = visit(users[i], contents);
      evaluation = evaluate(users[i], content, message);

      daily_visits++;
      daily_satisfied_visits += (1 + evaluation)/2;
      daily_publisher_revenue += publisher_revenue;
      daily_ad_views += views;

      data.users[users[i]]['satisfaction'] += evaluation;
    } else {
      users[i]['will_visit_next'] = true;
    }

    // if users are satisfied by the service, the user base will grow
    if(data.users[users[i]].satisfaction > 3){
      current_users.push(data.users[current_users.length + 1]);
    }

  }
  return (daily_visits, daily_satisfied_visits, daily_publisher_revenue, daily_ad_views);
}

function visit(user, current_contents){
  var visited_content, message;
  var publisher_revenue = 0;
  var views = 0;
  visited_content, message = artefHack.visit(user);

  // store the content if it has never been seen before
  if(!current_contents.exists(visited_content)){
    current_contents.push(data.contents[visited_content]);
    publisher_revenue = PUBLISHER_PRICE;
  }

  if(message != ''){
    views = 1;
  }

  // if the user has already seen the content, she will not visit the next day
  if(user['seen_contents'].exists(visited_content)){
    user['will_visit_next'] = false;
  } else {
    current_contents.push(data.contents[visited_content]);
  }

  return content, message, publisher_revenue, views;
}

function evaluate(user, content, message){
  if(message != '' && !data.users[user]['likes_ads']){
    artefHack.eval(user, -1);
    return -1;
  } else {
    return artefHack.eval(user, data.user_content_matrix[user, content]);
  }
}

function advertise(advertiser, available_views){
  // TODO improve how views_count is calculated
  if(advertiser_available_views < 20){
    artefHack.advertise(advertiser, ADVERTISER_BATCH_BUY_COUNT, 'Advertising message');
    available_views += ADVERTISER_BATCH_BUY_COUNT;
  }
}
