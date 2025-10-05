const { ethers } = require("hardhat");

async function main() {
  const IdiotToken = await ethers.getContractFactory("IdiotToken");
  console.log("Deploying IDIOT Token...");
  const token = await IdiotToken.deploy();
  await token.waitForDeployment();
  console.log("IDIOT Token deployed at:", await token.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
