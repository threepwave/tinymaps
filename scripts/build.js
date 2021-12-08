/* Build script - Runs a set of hardhat commands against your local vm */
const hre = require("hardhat");
const ethers = hre.ethers;

const price = 0.025;

async function main() {
    const TinyKingdoms = await ethers.getContractFactory("TinyKingdomsMetadata");
    const kingdoms = await TinyKingdoms.deploy();
    await kingdoms.deployed();
    
    let flagname = await kingdoms.getFlagName(1);
    console.log(flagname);

    let kingdomname = await kingdoms.getKingdomName(1);
    console.log(kingdomname);
    
    let palette = await kingdoms.getPalette(1);
    console.log(palette);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
