// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC721} from "oz/contracts/token/ERC721/ERC721.sol";

contract FreeMint is ERC721 {
    uint256 public totalSupply = 500;
    address public owner;
    bool public isOpen = false;

    constructor() ERC721("FreeMint", "FNT") {
        owner = msg.sender;
    }

    function mint(address to) public {
        require(totalSupply > 0, "Already reach supply limit");
        _mint(to, totalSupply);
        totalSupply -= 1;
    }

    function openBlindBox() public {
        require(msg.sender == owner, "Only owner can open box");
        isOpen = true;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        if (!isOpen) {
            return
                "http://ipfs.io/ipfs/QmbJ9XfiE4ovS6xXa1tHaXTEsBLAnmhNuEo3G66oK628AC";
        } else {
            return
                "http://ipfs.io/ipfs/QmShaqsDvgFTKEmSYETGokp4cZTeCLr72BvXMmeooXDqzz";
        }
    }
}
