pragma solidity ^0.5.6;

import "./klaytn-contracts/token/KIP17/IKIP17.sol";
import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IMix.sol";

contract KeplerMinter is Ownable {
    using SafeMath for uint256;

    IKIP17 public nft;
    uint256 public mintPrice = 40 * 1e18;
    address payable public feeTo;
    uint256 public maxCount = 20;
    uint256 public limit;
    uint256 public totalSupply;

    constructor(IKIP17 _nft, address payable _feeTo) public {
        nft = _nft;
        feeTo = _feeTo;
    }

    function setMintPrice(uint256 _price) external onlyOwner {
        mintPrice = _price;
    }

    function setFeeTo(address payable _feeTo) external onlyOwner {
        feeTo = _feeTo;
    }

    function setMaxCount(uint256 _maxCount) external onlyOwner {
        maxCount = _maxCount;
    }

    function setLimit(uint256 _limit) external onlyOwner {
        limit = _limit;
    }

    function mint(uint256 count) payable external {
        require(count <= limit && count <= maxCount);
        require(msg.value == mintPrice.mul(count));
        for (uint256 i = 0; i < count; i = i.add(1)) {
            nft.transferFrom(owner(), msg.sender, totalSupply);
            totalSupply = totalSupply.add(1);
        }
        feeTo.transfer(msg.value);
        limit = limit.sub(count);
    }
}
