
var data = require('../data/test.js')
var artefHack = require('./artefHack.js')

exports.one_day = function(contract, advertiser_address, available_views, views_to_buy, users, contents){
  advertise(contract, advertiser_address, available_views, views_to_buy);
  return visits(contract, users, contents);
}

// simulation of one day of users visits
function visits(contract, users, contents){
  var daily_visits = 0;
  var daily_satisfied_visits = 0;
  var daily_publisher_revenue = 0;
  var daily_ad_views = 0;

  for(var i=0; i<users.length; i++){

    if(data.users[users[i]]['will_visit_next']){
      var content, message, publisher_revenue, views;

      content, message, publisher_revenue, views = visit(contract, users[i], contents);
      evaluation = evaluate(contract, users[i], content, message);

      daily_visits++;
      daily_satisfied_visits += (1 + evaluation)/2;
      daily_publisher_revenue += publisher_revenue;
      daily_ad_views += views;

      data.users[users[i]]['satisfaction'] += evaluation;
    } else {
      data.users[users[i]]['will_visit_next'] = true;
    }

    // if users are satisfied by the service, the user base will grow
    if(data.users[users[i]].satisfaction > 3){
      current_users.push(data.users[current_users[current_users.length -1 ] + 1]);
    }

  }
  return (daily_visits, daily_satisfied_visits, daily_publisher_revenue, daily_ad_views);
}

function visit(contract, user, contents){
  var visited_content, message;
  var publisher_revenue = 0;
  var views = 0;
  visited_content, message = artefHack.visit(contract, user);

  // store the content if it has never been seen before
  if(!(visited_content in contents)){
    current_contents.push(data.contents[visited_content]);
    publisher_revenue = PUBLISHER_PRICE;
  }

  if(message != ''){
    views = 1;
  }

  // if the user has already seen the content, she will not visit the next day
  if(visited_content in data.users[user]['seen_contents']){
    user['will_visit_next'] = false;
  } else {
    current_contents.push(data.contents[visited_content]);
  }

  return content, message, publisher_revenue, views;
}

function evaluate(contract, user, content, message){
  if(message != '' && !data.users[user]['likes_ads']){
    artefHack.eval(user, -1);
    return -1;
  } else {
    return artefHack.eval(contract, user, data.user_content_matrix[user][content]);
  }
}

function advertise(contract, advertiser, available_views, views_to_buy){
  if(advertiser_available_views < 20){
    artefHack.advertise(contract, advertiser, views_to_buy, 'Advertising message');
    window["available_views"] += views_to_buy;
  }
}
