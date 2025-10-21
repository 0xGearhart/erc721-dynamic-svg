// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DynamicNft is ERC721 {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    error DynamicNft__MaxSupplyExceeded();

    /*//////////////////////////////////////////////////////////////
                                 STATE
    //////////////////////////////////////////////////////////////*/

    uint256 private immutable i_maxSupply;
    uint256 private s_currentSupply;
    mapping(uint256 => string) private s_tokenIdToUri;

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        string memory nftName,
        string memory nftSymbol,
        uint256 maxSupply
    ) ERC721(nftName, nftSymbol) {
        s_currentSupply = 0;
        i_maxSupply = maxSupply;
    }

    /*//////////////////////////////////////////////////////////////
                           PUBLIC & EXTERNAL
    //////////////////////////////////////////////////////////////*/

    function mintNft(string memory _tokenUri) external returns (uint256 nftId) {
        s_currentSupply++;
        s_tokenIdToUri[s_currentSupply] = _tokenUri;
        if (s_currentSupply > i_maxSupply)
            revert DynamicNft__MaxSupplyExceeded();
        _safeMint(msg.sender, s_currentSupply);
        return s_currentSupply;
    }

    /*//////////////////////////////////////////////////////////////
                              VIEW & PURE
    //////////////////////////////////////////////////////////////*/

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }

    function getMaxSupply() external view returns (uint256) {
        return i_maxSupply;
    }

    function getCurrentSupply() external view returns (uint256) {
        return s_currentSupply;
    }
}
