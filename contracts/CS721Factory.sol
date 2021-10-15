pragma solidity ^0.8.7;
// SPDX-License-Identifier: MIT


import "./CS721.sol";
import "./interfaces/IPancakeRouter02.sol";
import "./interfaces/IPancakePair.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract CS721Factory is Ownable {

    // TESTNET ADDRESSES !!!!
    IERC20 public immutable CoinSack = IERC20(0x8307d42ecf950935c47Afcb9fC4c1f74cF3F938C);
    IPancakeRouter02 public immutable PancakeRouter = IPancakeRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
    IPancakePair public immutable CoinSackPancakePair = IPancakePair(0xec829197B1c45B197cDa4104f22511e9ec53Dc61);
    address public immutable DeadAddress = 0x000000000000000000000000000000000000dEaD;

    CS721 private _cs721;
    uint256 private _mintFeeCS = 2000000000;

    mapping (address => bool) private _canMintWithoutFees;


    constructor() {
        _cs721 = new CS721();
        _canMintWithoutFees[owner()] = true;
    }


    function mintWithCS() public {
        require(CoinSack.allowance(msg.sender, address(this)) >= _mintFeeCS, "factory CS allowance not provided");
        CoinSack.transferFrom(msg.sender, DeadAddress, _mintFeeCS);
        (address tokenAddress, uint256 tokenId) =  _mint(msg.sender);
        emit Mint(tokenAddress, tokenId);
    }

    function mintWithBNB() public payable {
        uint256 mintFeeBNB = _getMintFeeBNB();
        require(msg.value >= mintFeeBNB, "message value does not cover mint fee");
        if(msg.value > mintFeeBNB) {
            payable(msg.sender).transfer(msg.value - mintFeeBNB);
        }
        address[] memory path = new address[](2);
        path[0] = PancakeRouter.WETH();
        path[1] = address(CoinSack);
        PancakeRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: mintFeeBNB}(0, path, DeadAddress, block.timestamp + 300);
        (address tokenAddress, uint256 tokenId) =  _mint(msg.sender);
        emit Mint(tokenAddress, tokenId);
    }

    function mintWithoutFees() public {
        require(_canMintWithoutFees[msg.sender], "caller cannot mint without fees");
        (address tokenAddress, uint256 tokenId) =  _mint(msg.sender);
        emit Mint(tokenAddress, tokenId);
    }

    function getMintFeeCS() public view returns (uint256) {
        return _mintFeeCS;
    }

    function getMintFeeBNB() public view returns (uint256) {
        return _getMintFeeBNB();
    }

    function canMintWithoutFees(address account) public view returns (bool) {
        return _canMintWithoutFees[account];
    }

    function setMintFeeCS(uint256 mintFeeCS) public onlyOwner() {
        _mintFeeCS = mintFeeCS;
    }

    function setCanMintWithoutFees(address account, bool canMintWithoutFees) public onlyOwner() {
        _canMintWithoutFees[account] = canMintWithoutFees;
    }

    function _mint(address to) internal returns (address, uint256) {
        if(_cs721.mintsRemaining() == 0){
            _cs721 = new CS721();
        }
        return _cs721.mint(to);
    }

    function _getMintFeeBNB() internal view returns (uint256) {
       (uint256 reserve0, uint256 reserve1, ) = CoinSackPancakePair.getReserves();
       return (uint256(PancakeRouter.getAmountIn(_mintFeeCS*115/100, reserve1, reserve0)));
    }


    event Mint(address tokenAddress, uint256 tokenId);

}