// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {EchonomySongRegistry} from "../src/EchonomySongRegistry.sol";

contract EchonomySongTest is Test {
    EchonomySongRegistry public registry;

    function setUp() public {
        registry = new EchonomySongRegistry();
    }

    function test_CreateSongContract() public {
        registry.createSongContract("Test Song", 100);
        assertEq(registry.songCount(), 1);
        assertEq(registry.songOwner(1), address(this));
        assertEq(registry.songPrice(1), 100);
    }

    function test_CreateSongContract_WithPriceZero() public {
        registry.createSongContract("Test Song", 0);
        assertEq(registry.songCount(), 1);
        assertEq(registry.songOwner(1), address(this));
        assertEq(registry.songPrice(1), 0);
    }

    function test_MintSong() public {
        registry.createSongContract("Test Song", 100);
        registry.mintSong{value: 100}(1, address(this));
        assertEq(registry.song(1).balanceOf(address(this)), 1);
    }

    function test_MintSong_WithIncorrectPayment() public {
        registry.createSongContract("Test Song", 100);
        vm.expectRevert(bytes("EchonomySongRegistry: incorrect payment amount"));
        registry.mintSong{value: 50}(1, address(this));
    }

    function test_Withdraw() public {
        registry.createSongContract("Test Song", 100);
        registry.mintSong{value: 100}(1, address(this));
        uint256 balanceBefore = address(this).balance;
        registry.withdraw();
        assertEq(address(this).balance, balanceBefore + 100);
    }

    receive() external payable {}

    function onERC721Received(address, address, uint256, bytes memory) public pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
