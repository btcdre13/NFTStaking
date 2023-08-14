
const hre = require("hardhat");

async function main() {
  const NFT = hre.ethers.getContractFactory("NFT");
  const nft = await NFT.deploy();
  await nft.deployed();

  console.log(`NFT contract deployed at address: ${nft.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
