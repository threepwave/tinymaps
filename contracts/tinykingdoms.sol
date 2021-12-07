/* @HACK Remove for launch */
import "hardhat/console.sol";

// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TinyKingdoms
 * @dev Generates beautiful tiny kingdoms
 */


contract TinyKingdoms is ERC721Enumerable,ReentrancyGuard,Ownable {

// 888888888888888888888888888888888888888888888888888888888888
// 888888888888888888888888888888888888888888888888888888888888
// 8888888888888888888888888P""  ""9888888888888888888888888888
// 8888888888888888P"88888P          988888"9888888888888888888
// 8888888888888888  "9888            888P"  888888888888888888
// 888888888888888888bo "9  d8o  o8b  P" od88888888888888888888
// 888888888888888888888bob 98"  "8P dod88888888888888888888888
// 888888888888888888888888    db    88888888888888888888888888
// 88888888888888888888888888      8888888888888888888888888888
// 88888888888888888888888P"9bo  odP"98888888888888888888888888
// 88888888888888888888P" od88888888bo "98888888888888888888888
// 888888888888888888   d88888888888888b   88888888888888888888
// 8888888888888888888oo8888888888888888oo888888888888888888888
// 8888888888888888888888888888888888888888888888888Ojo 9888888

    using Counters for Counters.Counter;
    
    uint256 private constant maxSupply = 4096;
    uint256 private  mintPrice = 0.025 ether;

    Counters.Counter private _tokenIdCounter;
    bool public saleIsActive = true; 

    /* @HACK Remove for launch */
    event Debug(string output);
    
    constructor() ERC721("Tiny Kingdoms", "TNY") Ownable() {
        _tokenIdCounter.increment();
    }
    
    string[] private nouns = [ 
        "Eagle","Meditation","Folklore","Star","Light","Play","Palace","Wildflower","Rescue","Fish","Painting",
        "Shadow","Revolution","Planet","Storm","Land","Surrounding","Spirit","Ocean","Night","Snow","River",
        "Sheep","Poison","State","Flame","River","Cloud","Pattern","Water","Forest","Tactic","Fire","Strategy",
        "Space","Time","Art","Stream","Spectrum","Fleet","Ship","Spring","Shore","Plant","Meadow","System","Past",
        "Parrot","Throne","Ken","Buffalo","Perspective","Tear","Moon","Moon","Wing","Summer","Broad","Owls",
        "Serpent","Desert","Fools","Spirit","Crystal","Persona","Dove","Rice","Crow","Ruin","Voice","Destiny",
        "Seashell","Structure","Toad","Shadow","Sparrow","Sun","Sky","Mist","Wind","Smoke","Division","Oasis",
        "Tundra","Blossom","Dune","Tree","Petal","Peach","Birch","Space","Flower","Valley","Cattail","Bulrush",
        "Wilderness","Ginger","Sunset","Riverbed","Fog","Leaf","Fruit","Country","Pillar","Bird","Reptile","Melody","Universe",
        "Majesty","Mirage","Lakes","Harvest","Warmth","Fever","Stirred","Orchid","Rock","Pine","Hill","Stone","Scent","Ocean",
        "Tide","Dream","Bog","Moss","Canyon","Grave","Dance","Hill","Valley","Cave","Meadow","Blackthorn","Mushroom","Bluebell",
        "Water","Dew","Mud","Family","Garden","Stork","Butterfly","Seed","Birdsong","Lullaby","Cupcake","Wish",
        "Laughter","Ghost","Gardenia","Lavender","Sage","Strawberry","Peaches","Pear","Rose","Thistle","Tulip",
        "Wheat","Thorn","Violet","Chrysanthemum","Amaranth","Corn","Sunflower","Sparrow","Sky","Daisy","Apple",
        "Oak","Bear","Pine","Poppy","Nightingale","Mockingbird","Ice","Daybreak","Coral","Daffodil","Butterfly",
        "Plum","Fern","Sidewalk","Lilac","Egg","Hummingbird","Heart","Creek","Bridge","Falling Leaf","Lupine","Creek",
        "Iris Amethyst","Ruby","Diamond","Saphire","Quartz","Clay","Coal","Briar","Dusk","Sand","Scale","Wave","Rapid",
        "Pearl","Opal","Dust","Sanctuary","Phoenix","Moonstone","Agate","Opal","Malachite","Jade","Peridot","Topaz",
        "Turquoise","Aquamarine","Amethyst","Garnet","Diamond","Emerald","Ruby","Sapphire","Typha","Sedge","Wood"
    ];
    
    string[] private adjectives = [
        "Central","Free","United","Socialist","Ancient Republic of","Third Republic of",
        "Eastern","Cyber","Northern","Northwestern","Galactic Empire of","Southern","Solar",
        "Islands of","Kingdom of","State of","Federation of","Confederation of",
        "Alliance of","Assembly of","Region of","Ruins of","Caliphate of","Republic of",
        "Province of","Grand","Duchy of","Capital Federation of","Autonomous Province of",
        "Free Democracy of","Federal Republic of","Unitary Republic of","Autonomous Regime of","New","Old Empire of"
    ];
    
    
    string[] private suffixes = [
        "Beach", "Center","City", "Coast","Creek", "Estates", "Falls", "Grove",
        "Heights","Hill","Hills","Island","Lake","Lakes","Park","Point","Ridge",
        "River","Springs","Valley","Village","Woods", "Waters", "Rivers", "Points", 
        "Mountains", "Volcanic Ridges", "Dunes", "Cliffs", "Summit"
    ];

      
    string[4][21] private colors = [            
        ["#006D77", "#83C5BE", "#FFDDD2", "#faf2e5"],
        ["#351F39", "#726A95", "#719FB0", "#f6f4ed"],
        ["#472E2A", "#E78A46", "#FAC459", "#fcefdf"],
        ["#0D1B2A", "#2F4865", "#7B88A7", "#fff8e7"],
        ["#E95145", "#F8B917", "#FFB2A2", "#f0f0e8"],
        ["#C54E84", "#F0BF36", "#3A67C2", "#F6F1EC"],
        ["#E66357", "#497FE3", "#8EA5FF", "#F1F0F0"],
        ["#ED7E62", "#F4B674", "#4D598B", "#F3EDED"],
        ["#D3EE9E", "#006838", "#96CF24", "#FBFBF8"],
        ["#FFE8F5", "#8756D1", "#D8709C", "#faf2e5"],
        ["#533549", "#F6B042", "#F9ED4E", "#f6f4ed"],
        ["#8175A3", "#A3759E", "#443C5B", "#fcefdf"],
        ["#788EA5", "#3D4C5C", "#7B5179", "#fff8e7"],
        ["#553C60", "#FFB0A0", "#FF6749", "#f0f0e8"],
        ["#99C1B2", "#49C293", "#467462", "#F6F1EC"],
        ["#ECBFAF", "#017724", "#0E2733", "#F1F0F0"],
        ["#D2DEB1", "#567BAE", "#60BF3C", "#F3EDED"],
        ["#FDE500", "#58BDBC", "#EFF0DD", "#FBFBF8"],
        ["#2f2043", "#f76975", "#E7E8CB", "#faf2e5"],
        ["#5EC227", "#302F35", "#63BDB3", "#f6f4ed"],
        ["#75974a", "#c83e3c", "#f39140", "#fcefdf"]
    ];

    string [25] private flags = [
        "Rising Sun",
        "Vertical Triband", 
        "Chevron", 
        "Nordic Cross", 
        "Spanish Fess", 
        "Five Stripes", 
        "Hinomaru", 
        "Vertical Bicolor", 
        "Saltire", 
        "Horizontal Bicolor", 
        "Vertical Misplaced Bicolor", 
        "Bordure", 
        "Inverted Pall", 
        "Twenty-four squared", 
        "Diagonal Bicolor", 
        "Horizontal Triband", 
        "Diagonal Bicolor Inverse", 
        "Quadrisection", 
        "Diagonal Tricolor Inverse", 
        "Rising Split Sun", 
        "Lonely Star",  
        "Diagonal Bicolor Right", 
        "Horizontal Bicolor with a star", 
        "Bonnie Star",
        "Jolly Roger"
    ];


    uint256[3][6] private orders = [
        [1, 2, 3],
        [1, 3, 2],
        [2, 1, 3],
        [2, 3, 1],
        [3, 1, 2],
        [3, 2, 1]
    ];
    

    struct TinyFlag {
        string placeName;
        string flagType; 
        string flagName;
        
        uint256 themeIndex;
        uint256 orderIndex;
        uint256 flagIndex;

    }

    function getOrderIndex (uint256 tokenId) internal pure returns (uint256){
        uint256 rand = random(tokenId,"ORDER") % 1000;
        uint256  orderIndex= rand / 166;
        return orderIndex;
    
    }

    function getThemeIndex (uint256 tokenId) internal pure returns (uint256){
        uint256 rand = random(tokenId,"THEME") % 1050;
        uint256 themeIndex;

        if (rand<1000){themeIndex=rand/50;}
        else {themeIndex = 20;}
       
        return themeIndex;
    
    }
    
    function getFlagIndex(uint256 tokenId) internal pure returns (uint256) {
        uint256 rand = random(tokenId,"FLAG") % 1000;
        uint256 flagIndex =0;

        if (rand>980){flagIndex=24;}
        else {flagIndex = rand/40;}
        
        return flagIndex;
    }

    function getflagName(uint256 flagIndex) internal view returns (string memory) {       
        string memory f1 = flags[flagIndex];
        return string(abi.encodePacked(f1));
    }

    function getKingdom (uint256 tokenId, uint256 flagIndex) internal view returns (string memory) {
        uint256 rand = random(tokenId, "PLACE");
        
        
        string memory a1 = adjectives[(rand / 7) % adjectives.length];
        string memory n1 =nouns[(rand / 200) % nouns.length];
        string memory s1;

        if (flagIndex == 24) {
            s1 = "pirate ship";
        } else {
            s1 = suffixes[(rand /11) % suffixes.length];
        }
        
        string memory output= string(abi.encodePacked(a1,' ',n1,' ',s1)); 
        
        return output;

    }


    function randomFlag(uint256 tokenId) internal view  returns (TinyFlag memory) {
        TinyFlag memory flag;
        
        flag.themeIndex= getThemeIndex(tokenId);
        flag.orderIndex = getOrderIndex(tokenId);
        flag.flagIndex = getFlagIndex(tokenId);
        flag.flagName = getflagName(flag.flagIndex);
        flag.placeName= getKingdom(tokenId, flag.flagIndex);

        return flag;
    }

    function getFlagStyle(TinyFlag memory flag) internal view returns (string memory){
        string[9] memory parts;

        parts[0]='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 609 602" style="background-color:'; //#faf2e5"> <defs> <style> .shadow{stroke-linecap:round;stroke-linejoin:round;fill:#565656;stroke:#565656} .cls-1{fill:';
        parts[1]=colors[flag.themeIndex][3];
        parts[2]='"> <defs> <style> .shadow{stroke-linecap:round;stroke-linejoin:round;fill:#565656;stroke:#565656} .cls-1{fill:';
        parts[3]=colors[flag.themeIndex][orders[flag.orderIndex][0]-1];
        parts[4]=';}.cls-2{fill:';
        parts[5]=colors[flag.themeIndex][orders[flag.orderIndex][1]-1];
        parts[6]=';}.cls-3{fill:';
        parts[7]=colors[flag.themeIndex][orders[flag.orderIndex][2]-1];
        parts[8]=';}.cls-5{fill:none;stroke:#565656;stroke-miterlimit:10;stroke-width:2px;} .contour{fill:none;stroke:#565656;stroke-miterlimit:10;stroke-width:2px;height:279,width:382, x:113, y:86}.place{font-size:36px;font-family:serif;fill:#565656}</style></defs>';

        string memory output = string(abi.encodePacked(parts[0],parts[1],parts[2],parts[3],parts[4],parts[5],parts[6],parts[7], parts[8]));
        return output;
    }

    function getPalette(TinyFlag memory flag) internal view returns (string memory) {
        string[9] memory palette;
        palette[0] = '["';
        palette[1] = colors[flag.themeIndex][orders[flag.orderIndex][0]-1];
        palette[2] = '", "';
        palette[3] = colors[flag.themeIndex][orders[flag.orderIndex][1]-1];
        palette[4] = '", "';
        palette[5] = colors[flag.themeIndex][orders[flag.orderIndex][2]-1];
        palette[6] = '", "';
        palette[7] = colors[flag.themeIndex][3];
        palette[8] = '"]';
        string memory output = string(abi.encodePacked(palette[0], palette[1], palette[2], palette[3], palette[4], palette[5], palette[6], palette[7], palette[8]));
        return output;
    }
   
    function random(uint256 tokenId, string memory seed) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, Strings.toString(tokenId))));
    }
    
    function _upper(bytes1 _b1) private pure returns (bytes1) {
          if (_b1 >= 0x61 && _b1 <= 0x7A) {
              return bytes1(uint8(_b1) - 32);
              }
              return _b1;
    }

    
    function tokenURI(uint256 tokenId) override public view  returns (string memory) {
        TinyFlag memory flag = randomFlag(tokenId);

        string memory palette = getPalette(flag);

        string memory json = Base64.encode(
            bytes(
                string(abi.encodePacked(
                    '{"name": "Tiny Kingdom #',
                     Strings.toString(tokenId),
                     '", "description": "Fully on-chain, randomly generated tiny flags." ',
                    ',"attributes":[ {"trait_type": "type", "value":"',flag.flagName,
                    '"}, {"trait_type": "name", "value":"', flag.placeName, 
                    '"}, {"trait_type": "palette", "value":', palette, 
                    '}]}'
                    ))));
        
        json = string(abi.encodePacked('data:application/json;base64,', json));
        return json;
        }

    function claim() public payable {
         uint256 nextId = _tokenIdCounter.current();
        require(saleIsActive, "Sale is not active");
        require(mintPrice <= msg.value, "Ether value sent is not correct");
        require(nextId <= maxSupply, "Token limit reached");  
        _safeMint(_msgSender(), nextId);
        _tokenIdCounter.increment();
  }

  function withdrawAll() public payable onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }
    
    // function flipSaleState() public onlyOwner {
    //     saleIsActive = !saleIsActive;
    //     }

}
/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}