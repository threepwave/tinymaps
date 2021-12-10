/* Build script - Runs a set of hardhat commands against your local vm */
const hre = require("hardhat");
const ethers = hre.ethers;

const fs = require('fs');

const price = 0.025;

async function main() {
    const TinyKingdoms = await ethers.getContractFactory("contracts/tinykingdomsmetadata.sol:TinyKingdomsMetadata");
    const kingdoms = await TinyKingdoms.deploy();
    await kingdoms.deployed();

    const TinyMaps = await ethers.getContractFactory("TinyMaps");
    const maps = await TinyMaps.deploy(kingdoms.address);
    await maps.deployed();
    
    let i = 1;  // Mint number

    let svg = await maps.getSVG(i);
    fs.writeFileSync(`./tmp/tmp${i}.svg`, svg);
    console.log('Write Complete');
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


