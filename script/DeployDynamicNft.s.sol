// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DynamicNft} from "../src/DynamicNft.sol";
import {Script} from "forge-std/Script.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract CodeConstants {
    string constant NFT_NAME = "Dynamic NFT";
    string constant NFT_SYMBOL = "DN";
    uint256 constant MAX_SUPPLY = 100;
}

contract DeployDynamicNft is Script, CodeConstants {
    function run() external returns (DynamicNft) {
        string memory happySvg = vm.readFile("./img/happy.svg");
        string memory sadSvg = vm.readFile("./img/sad.svg");

        vm.startBroadcast();
        DynamicNft dynamicNft = new DynamicNft(
            NFT_NAME,
            NFT_SYMBOL,
            MAX_SUPPLY,
            svgToImageURI(happySvg),
            svgToImageURI(sadSvg)
        );
        vm.stopBroadcast();
        return dynamicNft;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        // example:
        // <svg viewBox="0 0 200 200" width="400"  height="400" ....>
        // data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAyNHB4IiBoZWlnaHQ9

        // prefix to be added to base64 encoded svg
        string memory baseURL = "data:image/svg+xml;base64,";
        // base64 encode svg image file
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );

        // return using a concatanation method below
        // return string.concat(baseURL, svgBase64Encoded);
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
