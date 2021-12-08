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
    function getPalette(uint256 tokenId) external view returns (string[3] memory);
}

contract TinyMaps {
    string public description = "Tiny Kingdoms Maps";

    // HACK - Replace w/ reference to Tiny Kingdoms Metadata contract
    TinyKingdomsMetadata internal metadata;

    /* @HACK Remove for launch */
    event Debug(string output);

    struct TinyFlag {
        string placeName;
        // string flagName; // Not used for now
        string[3] palette;
    }

    /* getSVG(tokenId) - Returns an SVG of the current map, rendered in Tiny Kingdoms' style */

    function getSVG(uint256 tokenId) public view returns (string memory) {
        TinyFlag memory flag = TinyFlag(metadata.getKingdomName(tokenId), metadata.getPalette(tokenId));
        return(flag.placeName);
    }

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