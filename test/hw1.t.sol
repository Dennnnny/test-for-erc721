// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC721} from "oz/contracts/token/ERC721/ERC721.sol";
import {IERC721} from "oz/contracts/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "oz/contracts/token/ERC721/IERC721Receiver.sol";
import {Test, console2} from "forge-std/Test.sol";
import {NoUseful, HW_Token, ReceiverContract} from "../src/hw1.sol";

contract NoUsefulTest is Test {
    // uint256 public _tokenId = 0;
    NoUseful public noUseful;

    function setUp() public {
        noUseful = new NoUseful();
    }

    function testBasicInfo() public {
        assertEq(noUseful.name(), "NoUseful NFT");
        assertEq(noUseful.symbol(), "NUT");
    }

    function testTokenURI() public {
        assertEq(
            noUseful.tokenURI(0),
            "http://ipfs.io/ipfs/QmSfs2c2Gsd1PVJHzPpWnCQGLnAfcP92gpjZEGB1n2id1o"
        );
    }

    function testMint() public {
        address user1 = makeAddr(("user1"));
        vm.startPrank(user1);

        // check user1 has no nft before mint
        assertEq(noUseful.balanceOf(user1), 0);

        // check noUseful tokenId is 0 before mint
        assertEq(noUseful.tokenId(), 0);

        noUseful.mint();

        assertEq(noUseful.balanceOf(user1), 1);

        assertEq(noUseful.tokenId(), 1);

        vm.stopPrank();
    }
}

contract HW_TokenTest is Test {
    HW_Token public hwToken;

    function setUp() public {
        hwToken = new HW_Token();
    }

    function testBasicInfo() public {
        assertEq(hwToken.name(), "Don't send NFT to me");
        assertEq(hwToken.symbol(), "NONFT");
    }

    function testTokenURI() public {
        assertEq(
            hwToken.tokenURI(0),
            "http://ipfs.io/ipfs/QmXQRxaaoznroXWhLkkLnDmp24X3KPuBbuuNJ8gbcdLAMe"
        );
    }
}

contract ReceiverContractTest is Test {
    ReceiverContract public receiverContract;
    HW_Token public popoToken = new HW_Token();
    NoUseful public otherNFT = new NoUseful();
    address public someUser = makeAddr("user1");
    event TokenReceived(uint256 indexed token);

    function setUp() public {
        receiverContract = new ReceiverContract(popoToken);
    }

    function testOnERC721Received_SenderFromOtherNFT() public {
        vm.startPrank(someUser);

        // check receiverContract tId is 0 before trigger onERC721Received
        assertEq(receiverContract.tId(), 0);

        otherNFT.mint();

        // expect event triggered with tokenId 1
        vm.expectEmit();
        emit TokenReceived(1);

        otherNFT.safeTransferFrom(someUser, address(receiverContract), 1);

        // check receiverContract tId is 1 after trigger onERC721Received
        assertEq(receiverContract.tId(), 1);

        assertEq(HW_Token(popoToken).balanceOf(address(otherNFT)), 1);

        vm.stopPrank();
    }

    function testOnERC721Received_SenderFromPopoNFT() public {
        vm.startPrank(someUser);

        // check receiverContract tId is 0 before trigger onERC721Received
        assertEq(receiverContract.tId(), 0);

        popoToken.mint(someUser, 1);

        // expect event triggered with tokenId 1
        vm.expectEmit();
        emit TokenReceived(1);

        popoToken.safeTransferFrom(someUser, address(receiverContract), 1);

        // check receiverContract tId is still 0 after trigger onERC721Received
        assertEq(receiverContract.tId(), 0);

        assertEq(HW_Token(popoToken).balanceOf(address(receiverContract)), 1);

        vm.stopPrank();
    }
}
