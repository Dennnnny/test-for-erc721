// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {FreeMint} from "../src/hw2.sol";
import {Strings} from "oz/contracts/utils/Strings.sol";

contract FreeMintTest is Test {
    FreeMint public freeMint;
    address public owner = makeAddr("owner");

    function setUp() public {
        vm.prank(owner);
        freeMint = new FreeMint();
    }

    function testBasicInfo() public {
        assertEq(freeMint.name(), "FreeMint");
        assertEq(freeMint.symbol(), "FNT");
    }

    function testOwnership() public {
        assertEq(freeMint.owner(), owner);
    }

    function testOpenBlindBox() public {
        assertEq(freeMint.isOpen(), false);

        vm.expectRevert("Only owner can open box");
        freeMint.openBlindBox();

        vm.prank(owner);
        freeMint.openBlindBox();

        assertEq(freeMint.isOpen(), true);
    }

    function testTokenURI() public {
        assertEq(
            freeMint.tokenURI(0),
            "http://ipfs.io/ipfs/QmbJ9XfiE4ovS6xXa1tHaXTEsBLAnmhNuEo3G66oK628AC"
        );

        vm.prank(owner);
        freeMint.openBlindBox();

        assertEq(
            freeMint.tokenURI(0),
            "http://ipfs.io/ipfs/QmShaqsDvgFTKEmSYETGokp4cZTeCLr72BvXMmeooXDqzz"
        );
    }

    function testMint() public {
        // test for 500 times
        for (uint256 index = 0; index < 500; index++) {
            address testAddress = makeAddr(Strings.toString(index));
            freeMint.mint(testAddress);
        }
        assertEq(freeMint.totalSupply(), 0);

        //expect error next mint
        vm.expectRevert("Already reach supply limit");
        freeMint.mint(makeAddr("user1"));
    }
}
