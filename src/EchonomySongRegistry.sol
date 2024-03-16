pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./EchonomySong.sol";

contract EchonomySongRegistry {
    uint256 private _nextSongId = 1;
    mapping(uint256 => EchonomySong) private _songs;
    mapping(uint256 => address payable) private _songOwners;
    mapping(uint256 => uint256) private _songPrices;
    mapping(address => uint256) private _withdrawableBalance;
    
    function createSongContract(string memory name, uint256 price) public returns (uint256) {
        uint256 songId = _nextSongId;
        // TODO: dynamically construct the baseURI
        EchonomySong newSong = new EchonomySong(address(this), name, 
            string.concat("https://echonomy.vercel.app/api/v1/nft-metadata/", Strings.toString(_nextSongId), "/"));
        _songs[songId] = newSong;
        _songOwners[songId] = payable(msg.sender);
        _songPrices[songId] = price;
        _nextSongId++;
        return songId;
    }

    function mintSong(uint256 index, address to) public payable {
        require(msg.value == _songPrices[index], "EchonomySongRegistry: incorrect payment amount");
        _withdrawableBalance[_songOwners[index]] += msg.value;
        song(index).safeMint(to);
    }

    function withdraw() public {
        uint256 amount = _withdrawableBalance[msg.sender];
        require(amount > 0, "EchonomySongRegistry: no withdrawable balance");
        _withdrawableBalance[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function withdrawableBalance(address owner) public view returns (uint256) {
        return _withdrawableBalance[owner];
    }

    function song(uint256 index) public view returns (EchonomySong) {
        return _songs[index];
    }

    function songOwner(uint256 index) public view returns (address) {
        return _songOwners[index];
    }

    function songPrice(uint256 index) public view returns (uint256) {
        return _songPrices[index];
    }

    function songCount() public view returns (uint256) {
        return _nextSongId - 1;
    }
}