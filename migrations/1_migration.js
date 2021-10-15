const Migrations = artifacts.require("Migrations");
const CS721Factory = artifacts.require("CS721Factory");

module.exports = async function (deployer) {
  await deployer.deploy(Migrations);
  await deployer.deploy(CS721Factory);
};
