// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DynamicNft} from "../src/DynamicNft.sol";
import {Script} from "forge-std/Script.sol";

contract CodeConstants {
    string constant NFT_NAME = "DynamicNFT";
    string constant NFT_SYMBOL = "DN";
    uint256 constant MAX_SUPPLY = 100;
}

contract DeployDynamicNft is Script, CodeConstants {
    function run() external returns (DynamicNft) {
        vm.startBroadcast();
        DynamicNft dynamicNft = new DynamicNft(
            NFT_NAME,
            NFT_SYMBOL,
            MAX_SUPPLY
        );
        vm.stopBroadcast();
        return dynamicNft;
    }
}
