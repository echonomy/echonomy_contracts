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
    
    function createSongContract(string memory name, uint256 price) public {
        // TODO: dynamically construct the baseURI
        EchonomySong newSong = new EchonomySong(address(this), name, 
            string.concat("https://echonomy.vercel.app/api/v1/nft-metadata/", Strings.toString(_nextSongId), "/"));
        _songs[_nextSongId] = newSong;
        _songOwners[_nextSongId] = payable(msg.sender);
        _songPrices[_nextSongId] = price;
        _nextSongId++;
    }

    function mintSong(uint256 index, address to) public payable {
        require(msg.value == _songPrices[index], "EchonomySongRegistry: incorrect payment amount");
        _withdrawableBalance[_songOwners[index]] += msg.value;
        EchonomySong song = _songs[index];
        song.safeMint(to);
    }

    function withdraw() public {
        uint256 amount = _withdrawableBalance[msg.sender];
        require(amount > 0, "EchonomySongRegistry: no withdrawable balance");
        _withdrawableBalance[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function getSong(uint256 index) public view returns (EchonomySong) {
        return _songs[index];
    }

    function getSongOwner(uint256 index) public view returns (address) {
        return _songOwners[index];
    }

    function getSongPrice(uint256 index) public view returns (uint256) {
        return _songPrices[index];
    }

    function getSongCount() public view returns (uint256) {
        return _nextSongId - 1;
    }
}