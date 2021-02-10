const Autopool = artifacts.require("Autopool");

module.exports = function (deployer) {
  deployer.deploy(Autopool);
};