// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployDynamicNft, CodeConstants} from "../script/DeployDynamicNft.s.sol";
import {DynamicNft} from "../src/DynamicNft.sol";
import {Test} from "forge-std/Test.sol";

contract DynamicNftTest is Test, CodeConstants {
    DeployDynamicNft public deployer;
    DynamicNft public dynamicNft;

    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    function setUp() external {
        deployer = new DeployDynamicNft();
        dynamicNft = deployer.run();
    }

    function testCurrentSupplyIsSetToZeroAtDeployment() external view {
        assertEq(dynamicNft.getCurrentSupply(), 0);
    }

    function testMaxSupplyWasSetCorrectly() external view {
        assertEq(dynamicNft.getMaxSupply(), MAX_SUPPLY);
    }

    function testNameWasSetCorrectly() external view {
        // cannot directly compare two strings with assert(dynamicNft.name() == NFT_NAME);
        // since strings are actually arrays they need to be encoded and hashed so we can compare the hash of the values inside the array
        assert(
            keccak256(abi.encodePacked(dynamicNft.name())) ==
                keccak256(abi.encodePacked(NFT_NAME))
        );
        // this cleaner method works as well
        assertEq(dynamicNft.name(), NFT_NAME);
    }

    function testSymbolWasSetCorrectly() external view {
        assertEq(dynamicNft.symbol(), NFT_SYMBOL);
    }
}
