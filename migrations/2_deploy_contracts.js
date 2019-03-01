const NumaToken = artifacts.require("NumaToken");

module.exports = function(deployer) {
  //deployer.deploy(ConvertLib);
  //deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(NumaToken);
};
