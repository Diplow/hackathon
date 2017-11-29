var artefhack = artifacts.require("ArtefHack");
var publisher = artifacts.require("Publisher");

var artefhackcontentsstorage = artifacts.require("ArtefHackContentStorage");
var artefhackusersstorage = artifacts.require("ArtefHackUserStorage");
var balances = artifacts.require("Balances");
var catalogue = artifacts.require("Catalogue");
var users = artifacts.require("Users");

var roles = artifacts.require("RolesStorage");
var utils = artifacts.require("Utils");

module.exports = function(deployer) {
  deployer.deploy(utils).then(function(){
    return deployer.link(utils, [artefhack, publisher, roles]).then(function(){
      return deployer.deploy(roles).then(function() {
        return deployer.deploy(artefhackcontentsstorage).then(function() {
          return deployer.deploy(artefhackusersstorage).then(function() {
            return deployer.deploy(balances).then(function() {
              return deployer.deploy(catalogue).then(function() {
                return deployer.deploy(users).then(function() {
                  return deployer.deploy(publisher, catalogue.address, balances.address, roles.address).then(function() {
                    return deployer.deploy(artefhack, balances.address, artefhackcontentsstorage.address, artefhackusersstorage.address, publisher.address, roles.address, catalogue.address);
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
