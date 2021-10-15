const Migrations = artifacts.require("Migrations");
const CS721Factory = artifacts.require("CS721Factory");
const CS721Listings = artifacts.require("CS721Listings");

module.exports = async function (deployer) {
  await deployer.deploy(Migrations);
  await deployer.deploy(CS721Factory);
  await deployer.deploy(CS721Listings);
};
