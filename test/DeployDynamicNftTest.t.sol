// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {DeployDynamicNft, CodeConstants} from "../script/DeployDynamicNft.s.sol";
import {DynamicNft} from "../src/DynamicNft.sol";
import {Test, console} from "forge-std/Test.sol";
import {IERC721Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract DeployDynamicNftTest is Test, CodeConstants {
    DeployDynamicNft public deployer;

    // DynamicNft public dynamicNft;

    // address user1 = makeAddr("user1");
    // address user2 = makeAddr("user2");

    function setUp() external {
        deployer = new DeployDynamicNft();
        // dynamicNft = deployer.run();
    }

    function testConvertSvgToUri() public view {
        string memory expectedUri =
            "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iNTAwIiBoZWlnaHQ9IjUwMCI+PHRleHQgeD0iMCIgeT0iMTUiIGZpbGw9ImJsYWNrIj5IaSEgWW91ciBicm93c2VyIGRlY29kZWQgdGhpczwvdGV4dD48L3N2Zz4=";
        string memory svg =
            '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="500" height="500"><text x="0" y="15" fill="black">Hi! Your browser decoded this</text></svg>';
        string memory generatedUri = deployer.svgToImageURI(svg);
        // compare strings using one of the methods below
        assertEq(generatedUri, expectedUri);
        // assert(
        //     keccak256(abi.encodePacked(generatedUri)) ==
        //         keccak256(abi.encodePacked(expectedUri))
        // );
    }
}
