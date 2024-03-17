pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./EchonomySong.sol";

contract EchonomySongRegistry {
    event SongCreated(uint256 indexed songId, address indexed owner, uint256 price);

    IERC20 private _usdcContract = IERC20(0x036CbD53842c5426634e7929541eC2318f3dCF7e);

    uint256 private _nextSongId = 1;
    mapping(uint256 => address payable) private _songArtist;
    mapping(uint256 => uint256) private _songPrice;
    mapping(uint256 => address[]) private _songOwners;
    mapping(address => uint256[]) private _ownedSongs;
    mapping(address => mapping(uint256 => bool)) private _ownsSong;
    
    function createSongContract(uint256 price) public {
        uint256 songId = _nextSongId;
        _songArtist[songId] = payable(msg.sender);
        _songPrice[songId] = price;
        _nextSongId++;
        emit SongCreated(songId, msg.sender, price);
    }

    function buySong(uint256 index) public {
        require(_songArtist[index] != address(0), "EchonomySongRegistry: song does not exist");
        require(!_ownsSong[msg.sender][index], "EchonomySongRegistry: already owns song");

        _usdcContract.transferFrom(msg.sender, _songArtist[index], _songPrice[index]);

        _songOwners[index].push(msg.sender);
        _ownedSongs[msg.sender].push(index);
        _ownsSong[msg.sender][index] = true;
    }

    function songArtist(uint256 index) public view returns (address) {
        return _songArtist[index];
    }

    function songPrice(uint256 index) public view returns (uint256) {
        return _songPrice[index];
    }

    function ownsSong(address owner, uint256 index) public view returns (bool) {
        return _ownsSong[owner][index];
    }

    function ownedSongs(address owner) public view returns (uint256[] memory) {
        return _ownedSongs[owner];
    }

    function songOwners(uint256 index) public view returns (address[] memory) {
        return _songOwners[index];
    }

    function songCount() public view returns (uint256) {
        return _nextSongId - 1;
    }
}