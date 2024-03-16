// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {EchonomySong} from "../src/EchonomySong.sol";

contract EchonomySongTest is Test {
    EchonomySong public song;

    function setUp() public {
        song = new EchonomySong(address(this), "Test Song", "https://echonomy.vercel.app/api/v1/nft-metadata/0");
    }

    /*function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }*/
}
