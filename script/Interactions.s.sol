// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DynamicNft} from "../src/DynamicNft.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintDynamicNft is Script {
    function run() external {
        address mostRecentlyDeployedDynamicNft = DevOpsTools
            .get_most_recent_deployment("DynamicNft", block.chainid);
        mintNftOnContract(mostRecentlyDeployedDynamicNft);
    }

    function mintNftOnContract(address dynamicNftAddress) public {
        vm.startBroadcast();
        DynamicNft(dynamicNftAddress).mintNft();
        vm.stopBroadcast();
    }
}

contract FlipDynamicNft is Script {
    uint256 public constant TOKEN_ID_TO_FLIP = 0;

    function run() external {
        address mostRecentlyDeployedDynamicNft = DevOpsTools
            .get_most_recent_deployment("DynamicNft", block.chainid);
        flipDynamicNft(mostRecentlyDeployedDynamicNft);
    }

    function flipDynamicNft(address dynamicNftAddress) public {
        vm.startBroadcast();
        DynamicNft(dynamicNftAddress).flipMood(TOKEN_ID_TO_FLIP);
        vm.stopBroadcast();
    }
}
