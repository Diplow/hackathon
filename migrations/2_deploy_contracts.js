var advertiser = artifacts.require("Advertiser");
var dataprovider = artifacts.require("DataProvider");
var publisher = artifacts.require("Publisher");

var audiences = artifacts.require("AudienceStorage");
var balances = artifacts.require("AdvertiserBalances");
var messages = artifacts.require("MessageStorage");
var placements = artifacts.require("PlacementStorage");
var targetings = artifacts.require("TargetingStorage");
var users = artifacts.require("UserStorage");

var utils = artifacts.require("Utils");

module.exports = function(deployer) {
  deployer.deploy(utils).then(function(){
    return deployer.link(utils, [advertiser, balances, dataprovider, publisher]).then(function(){
      return deployer.deploy(audiences).then(function() {
        return deployer.deploy(users).then(function() {
          return deployer.deploy(balances).then(function() {
            return deployer.deploy(messages).then(function() {
              return deployer.deploy(placements).then(function() {
                return deployer.deploy(targetings, audiences.address, messages.address, placements.address).then(function() {
                  return deployer.deploy(advertiser, balances.address, messages.address).then(function() {
                    return deployer.deploy(dataprovider, advertiser.address, audiences.address, users.address).then(function() {
                      return deployer.deploy(publisher, advertiser.address, messages.address, placements.address, dataprovider.address, targetings.address);
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  });
};
