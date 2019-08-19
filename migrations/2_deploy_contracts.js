// Please fix this file in order to properly deploy your smart contract.
var Employee = artifacts.require("./Employee.sol");

module.exports = function(deployer) {
  deployer.deploy(Employee, '13-03-1993');
};
