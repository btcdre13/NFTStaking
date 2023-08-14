
const hre = require("hardhat");

async function main() {
  const Staker = hre.ethers.getContractFactory("Staker");
  const staker = await Staker.deploy("addr", "addr");
  await staker.deployed();

  console.log(`Staker contract deployed at address: ${staker.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
