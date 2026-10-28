var TeacherRating = artifacts.require("./TeacherRating.sol");

module.exports = function(deployer) {
  deployer.deploy(TeacherRating);
};