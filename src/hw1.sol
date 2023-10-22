// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC721} from "oz/contracts/token/ERC721/ERC721.sol";
import {IERC721} from "oz/contracts/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "oz/contracts/token/ERC721/IERC721Receiver.sol";

contract NoUseful is ERC721 {
    uint256 public tokenId = 0;

    constructor() ERC721("NoUseful NFT", "NUT") {}

    function mint() public {
        tokenId += 1;
        _mint(msg.sender, tokenId);
    }

    function tokenURI(
        uint256 _tokenId
    ) public pure override returns (string memory) {
        return
            "http://ipfs.io/ipfs/QmSfs2c2Gsd1PVJHzPpWnCQGLnAfcP92gpjZEGB1n2id1o";
    }
}

contract HW_Token is ERC721 {
    constructor() ERC721("Don't send NFT to me", "NONFT") {}

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }

    function tokenURI(
        uint256 _tokenId
    ) public pure override returns (string memory) {
        // popo json
        return
            "http://ipfs.io/ipfs/QmXQRxaaoznroXWhLkkLnDmp24X3KPuBbuuNJ8gbcdLAMe";
    }
}

contract ReceiverContract is IERC721Receiver {
    HW_Token public popoToken;
    uint256 public tId = 0;
    event TokenReceived(uint256 indexed token);

    constructor(HW_Token _addr) {
        popoToken = HW_Token(_addr);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    ) public virtual override returns (bytes4) {
        emit TokenReceived(tokenId);
        if (msg.sender != address(popoToken)) {
            ERC721(msg.sender).transferFrom(address(this), from, tokenId);

            tId += 1;
            popoToken.mint(msg.sender, tId);
        }
        return this.onERC721Received.selector;
    }
}
