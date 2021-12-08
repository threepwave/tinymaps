/* Build script - Runs a set of hardhat commands against your local vm */
const hre = require("hardhat");
const ethers = hre.ethers;

const price = 0.025;

async function main() {
    const TinyKingdoms = await ethers.getContractFactory("contracts/tinykingdomsmetadata.sol:TinyKingdomsMetadata");
    const kingdoms = await TinyKingdoms.deploy();
    await kingdoms.deployed();

    const TinyMaps = await ethers.getContractFactory("TinyMaps");
    const maps = await TinyMaps.deploy(kingdoms.address);
    await maps.deployed();
    
    let name = await maps.getSVG(1);
    console.log(name)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
