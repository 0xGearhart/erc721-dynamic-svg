// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {DynamicNft} from "../src/DynamicNft.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

// import {HelperConfig} from "./HelperConfig.s.sol";

// TO DO: need to refactor to change run() functions to not require contractAddress parameters
// need the input for tests since test deployments are not recorded by DevOpsTools
// but calling through Makefile requires no input parameters.
// Maybe tests should be changed?
// Maybe using DevOpsTools incorrectly? Where do test deployments get recorded?

// contract MintOrFlipDynamicNft is Script {
//     // change depending on what NFT you want to flip
//     uint256 constant TOKEN_ID_TO_FLIP = 1;
//     HelperConfig public helperConfig;
//     DynamicNft public dynamicNft;
//     HelperConfig.NetworkConfig public currentConfig;

//     function run() external {
//         helperConfig = new HelperConfig();
//         currentConfig = helperConfig.getConfig();
//         dynamicNft = currentConfig.dynamicNft;
//     }

//     function mintDynamicNft() public {
//         vm.startBroadcast(currentConfig.account);
//         dynamicNft.mintNft();
//         vm.stopBroadcast();
//     }

//     function flipDynamicNftMood() public {
//         vm.startBroadcast(currentConfig.account);
//         dynamicNft.flipMood(TOKEN_ID_TO_FLIP);
//         vm.stopBroadcast();
//     }
// }

contract MintDynamicNft is Script {
    function run() external {
        address mostRecentlyDeployedDynamicNft = DevOpsTools.get_most_recent_deployment("DynamicNft", block.chainid);
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
        address mostRecentlyDeployedDynamicNft = DevOpsTools.get_most_recent_deployment("DynamicNft", block.chainid);
        flipDynamicNft(mostRecentlyDeployedDynamicNft);
    }

    function flipDynamicNft(address dynamicNftAddress) public {
        vm.startBroadcast();
        DynamicNft(dynamicNftAddress).flipMood(TOKEN_ID_TO_FLIP);
        vm.stopBroadcast();
    }
}
