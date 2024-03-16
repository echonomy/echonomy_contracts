// SPDX-License-Identifier: UNKNOWN 
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EchonomySong is ERC721, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    string private _dynamicBaseURI;

    constructor(address registry, string memory songName, string memory baseURI)
        ERC721(string.concat("Echonomy Song: ", songName), "SONG")
        Ownable(registry)
    {
        _dynamicBaseURI = baseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return _dynamicBaseURI;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }
}