/* Build script - Runs a set of hardhat commands against your local vm */
const hre = require("hardhat");
const ethers = hre.ethers;

const price = 0.025;

async function main() {
    const TinyKingdoms = await ethers.getContractFactory("TinyKingdoms");
    const kingdoms = await TinyKingdoms.deploy();
    await kingdoms.deployed();
    
    const ethToSend = ethers.utils.parseEther(price.toString());

    await kingdoms.claim({value: ethToSend});
    let tokenURI = await kingdoms.tokenURI(1);
    let json = tokenURI.substr(29);
    let output = JSON.parse(Buffer.from(json, 'base64').toString());
    console.log(output)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
