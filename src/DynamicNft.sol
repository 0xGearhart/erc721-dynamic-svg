// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DynamicNft is ERC721 {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    error DynamicNft__MaxSupplyExceeded();
    error DynamicNft__OnlyOwnerCanChangeMood(uint256 tokenId);

    /*//////////////////////////////////////////////////////////////
                           TYPE DECLARATIONS
    //////////////////////////////////////////////////////////////*/

    enum Mood {
        HAPPY, // 0
        SAD // 1
    }

    /*//////////////////////////////////////////////////////////////
                                 STATE
    //////////////////////////////////////////////////////////////*/

    uint256 private immutable i_maxSupply;
    uint256 private s_currentSupply;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;
    mapping(uint256 => Mood) private s_tokenIdToMood;

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        string memory nftName,
        string memory nftSymbol,
        uint256 maxSupply,
        string memory happySvgImageUri,
        string memory sadSvgImageUri
    ) ERC721(nftName, nftSymbol) {
        s_currentSupply = 0;
        i_maxSupply = maxSupply;
        s_happySvgImageUri = happySvgImageUri;
        s_sadSvgImageUri = sadSvgImageUri;
    }

    /*//////////////////////////////////////////////////////////////
                           PUBLIC & EXTERNAL
    //////////////////////////////////////////////////////////////*/

    function mintNft() external returns (uint256 nftId) {
        s_currentSupply++;
        if (s_currentSupply > i_maxSupply) {
            revert DynamicNft__MaxSupplyExceeded();
        }
        s_tokenIdToMood[s_currentSupply] = Mood.HAPPY;
        _safeMint(msg.sender, s_currentSupply);
        return s_currentSupply;
    }

    function flipMood(uint256 tokenId) external {
        if (_ownerOf(tokenId) != msg.sender) {
            revert DynamicNft__OnlyOwnerCanChangeMood(tokenId);
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    /*//////////////////////////////////////////////////////////////
                                INTERNAL
    //////////////////////////////////////////////////////////////*/

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    /*//////////////////////////////////////////////////////////////
                              VIEW & PURE
    //////////////////////////////////////////////////////////////*/

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // check token exists
        _requireOwned(tokenId);
        string memory imageUri;
        // check image URI for current mood
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageUri = s_happySvgImageUri;
        } else {
            imageUri = s_sadSvgImageUri;
        }
        // build and return token metadata in .json format based on dynamic variables
        // {"name": "Dynamic NFT"}
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "A dynamic NFT that changes image based on the owners mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
                            imageUri,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function getMaxSupply() external view returns (uint256) {
        return i_maxSupply;
    }

    function getCurrentSupply() external view returns (uint256) {
        return s_currentSupply;
    }

    function getCurrentMood(uint256 tokenId) external view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }

    function getMoodImage(Mood mood) external view returns (string memory) {
        if (mood == Mood.HAPPY) {
            return s_happySvgImageUri;
        } else {
            return s_sadSvgImageUri;
        }
    }
}
