pragma solidity ^0.8.7;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CS721 is ERC721 {

    address public factory;

    uint256 private _nextTokenId = 100000000001;
    uint256 private _maxTokenId = 999999999999;


    constructor() ERC721("Coin Sack NFTs", "CS NFTs") {
        factory = _msgSender();
    }


    function mintsRemaining() public view returns (uint256) {
        return _maxTokenId - _nextTokenId + 1;
    }

    function mint(address to) public returns (address, uint256) {
        require(_msgSender() == factory, "mint can only be called by factory contract");
        require(_nextTokenId <= _maxTokenId, "maximum contract token number reacted");

        super._safeMint(to, _nextTokenId);

        _nextTokenId = _nextTokenId + 1;

        return (address(this), _nextTokenId - 1);
    }


    function _baseURI() internal view override returns (string memory) {
        string memory baseURI = "https://nfts-static-service.azurewebsites.net/metadata/0x";
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, _toAsciiString(address(this)), "/")) : "";
    }

    function _toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = _char(hi);
            s[2*i+1] = _char(lo);            
        }
        return string(s);
    }

    function _char(bytes1 b) internal pure returns (bytes1) {
        if (uint8(b) < 10) {
            return bytes1(uint8(b) + 0x30);
        } else {
            return bytes1(uint8(b) + 0x57);
        }
    }
    
}