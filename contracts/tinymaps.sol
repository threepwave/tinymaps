// SPDX-License-Identifier: MIT

/* @HACK Remove for launch */
import "hardhat/console.sol";

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title TinyMaps
 * @dev Renders beautiful Tiny Maps based on Tiny Kingdoms
 */

interface TinyKingdomsMetadata {
    function getKingdomName(uint256 tokenId) external view returns (string memory);
    function getPalette(uint256 tokenId) external view returns (string[4] memory);
}

interface Dungeons {
    function getLayout(uint256 tokenId) external view returns (bytes memory);
    function getSize(uint256 tokenId) external view returns (uint8);
}

contract TinyMaps {
    string public description = "Tiny Kingdoms Maps";

    // HACK - Replace w/ reference to Tiny Kingdoms Metadata contract
    TinyKingdomsMetadata internal metadata;

    address internal dungeonsContract = 0x86f7692569914B5060Ef39aAb99e62eC96A6Ed45;
    Dungeons internal dungeons = Dungeons(dungeonsContract); 

    /* @HACK Remove for launch */
    event Debug(string output);

    struct TinyFlag {
        string placeName;
        string[4] palette;
    }

    struct DungeonMap {
        uint256[] layout;
        uint8 size;
    }

    /* getSVG(tokenId) - Returns an SVG of the current map, rendered in Tiny Kingdoms' style */
    function getSVG(uint256 tokenId) public view returns (string memory) {
        DungeonMap memory map = DungeonMap(fromBytes(dungeons.getLayout(tokenId)), dungeons.getSize(tokenId));
        TinyFlag memory flag = TinyFlag(metadata.getKingdomName(tokenId), metadata.getPalette(tokenId));
        string memory svg = draw(flag, map);
        return svg;
    }

    /* draw(flag) - Renders an svg of the map in a TinyKingdoms style */
    function draw(TinyFlag memory flag, DungeonMap memory map) public view returns (string memory) {
        string memory style = getFlagStyle(flag);
        string memory svg = getFlagSVG(flag, style, map);
        return(svg);
    }

    /* Layout rendering */
    function getFlagStyle(TinyFlag memory flag) internal view returns (string memory){
        string[9] memory parts;

        parts[0]='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 609 602" style="background-color:'; //#faf2e5"> <defs> <style> .shadow{stroke-linecap:round;stroke-linejoin:round;fill:#565656;stroke:#565656} .cls-1{fill:';
        parts[1]=flag.palette[3];
        parts[2]='"> <defs> <style> .shadow{stroke-linecap:round;stroke-linejoin:round;fill:#565656;stroke:#565656} .cls-1{fill:';
        parts[3]=flag.palette[0];
        parts[4]=';}.cls-2{fill:';
        parts[5]=flag.palette[1];
        parts[6]=';}.cls-3{fill:';
        parts[7]=flag.palette[2];
        parts[8]=';}.cls-5{fill:none;stroke:#565656;stroke-miterlimit:10;stroke-width:2px;} .contour{fill:none;stroke:#565656;stroke-miterlimit:10;stroke-width:2px;height:279,width:382, x:113, y:86}.place{font-size:36px;font-family:serif;fill:#565656}</style></defs>';

        string memory output = string(abi.encodePacked(parts[0],parts[1],parts[2],parts[3],parts[4],parts[5],parts[6],parts[7], parts[8]));
        return output;
    }
    
    function getFlagSVG(TinyFlag memory flag, string memory style, DungeonMap memory map) internal view returns (string memory){
        string[7] memory parts;

        parts[0]=style;
        parts[1]='<pattern id="backDots" width="64" height="64" patternUnits="userSpaceOnUse"><line fill="transparent" stroke="#565656" stroke-width="2" opacity=".6" x1="14.76" y1="24.94" x2="20.5" y2="19.5" /></pattern><filter id="back"><feTurbulence type="fractalNoise" baseFrequency="0.1" numOctaves="1" seed="42"/> <feDisplacementMap in="SourceGraphic" xChannelSelector="B" scale="200"/></filter><g filter="url(#back)"><rect x="-50%" y="-50%" width="200%" height="200%" fill="url(#backDots)" /></g><filter id="displacementFilter"><feTurbulence id="turbulenceMap" type="turbulence" baseFrequency="0.05" numOctaves="2" result= "turbulence"><animate attributeName="baseFrequency" values="0.01;0.001;0.01" dur="4s" repeatCount="indefinite"/></feTurbulence><feDisplacementMap in2="turbulence" in="SourceGraphic" scale="9" xChannelSelector="R" yChannelSelector="G" /></filter> <g id="layer_2" style="filter: url(#displacementFilter)">';
        // Define flag parts here
        parts[2]=getMapSVG(map);
        // End flag part definition
        parts[3]='</g> <rect class="contour"  x="113.5" y="86.5" width="382" height="279" style="filter: url(#displacementFilter)"/><polygon class="shadow" points="112.5 365.5 112.5 87.92 108 97 108 370 490 370 494.67 365.5 112.5 365.5" style="filter: url(#displacementFilter)"/>';
        parts[4]='</svg>';

        string memory output = string(abi.encodePacked(parts[0],parts[1],parts[2],parts[3],parts[4]));
        return output;
    }

    function getMapSVG(DungeonMap memory map) internal view returns (string memory) {
        // uint256 startX = 110;
        // uint256 startY = 90;

        string memory output = "";
        string[5] memory parts;

        // Draw rectangle for walls
        parts[0] = '<rect class="cls-1" x="110" y="90" height="';
        parts[1] = toString(20*uint256(map.size));  // Cast to uint256 to prevent overflow
        parts[2] = '" width="';
        parts[3] = toString(20*uint256(map.size));
        parts[4] = '" style="filter: url(#displacementFilter)" />';
        output = string(abi.encodePacked(output, parts[0], parts[1], parts[2], parts[3], parts[4]));

        // Lay floor on top
        uint256 counter = 0;
        for(uint256 y = 0; y < map.size; y++) {
            string memory row = "";

            for(uint256 x = 0; x < map.size; x++) {
                // Apply color based on map palette
                if(getBit(map.layout, counter) == 1) {
                    parts[0] = '<rect class="cls-2" x="';
                    parts[1] = toString(110 + (20*x));
                    parts[2] = '" y="';
                    parts[3] = toString(90 + (20*y));
                    parts[4] = '" height="20" width="20" style="filter: url(#displacementFilter)" />';
                
                    row = string(abi.encodePacked(row, parts[0], parts[1], parts[2], parts[3], parts[4]));
                }
                counter++;
            }

            output = string(abi.encodePacked(output, row));
        } 

        return(output);
    }


    /* Bitwise Helper Functions */
    function getBit(uint256[] memory map, uint256 position) internal pure returns(uint256) {
    // Returns whether a bit is set or off at a given position in our map (credit: @cjpais)
        (uint256 quotient, uint256 remainder) = getDivided(position, 256);
        require(position <= 255 + (quotient * 256));
        return (map[quotient] >> (255 - remainder)) & 1;
    }


    function getDivided(uint256 numerator, uint256 denominator) public pure returns (uint256 quotient, uint256 remainder)
    {
        require(denominator > 0);
        quotient = numerator / denominator;
        remainder = numerator - denominator * quotient;
    }

    function getNumIntsRequired(bytes memory data) public pure returns (uint256)
    {
    // Calculate the number of ints needed to contain the number of bytes in data
        require(data.length > 0);

        (uint256 quotient, uint256 remainder) = getDivided(data.length, 32);

        if (remainder > 0) return quotient + 1;
        return quotient;
    }


    function fromBytes(bytes memory encodedMap) internal pure returns (uint256[] memory) {
    // Converts a bytes array to a map (two uint256)
        uint256 num = getNumIntsRequired(encodedMap);
        uint256[] memory result = new uint256[](num);

        uint256 offset = 0;
        uint256 x;

        for (uint256 i = 0; i < num; i++) {
            assembly {
                x := mload(add(encodedMap, add(0x20, offset)))
                mstore(add(result, add(0x20, offset)), x)
            }
            offset += 0x20;
        }

        return result;
    }


    /* Utility Functions */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    constructor(TinyKingdomsMetadata _metadata) {
        metadata = _metadata;
    }
}