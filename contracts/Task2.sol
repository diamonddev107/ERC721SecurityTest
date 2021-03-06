/* See the code snippet for ERC721BidSale below. The ERC721.sol file is simply an
interface.

Find as many security issues as you can.
Explain why they are security issues.
Solve them (a enough detailed description of how you would solve it would be
enough, but if you prefer you can submit a fixed source code). */

pragma solidity 0.6.4;
import "./Interfaces/ERC721.sol";
contract ERC721BidSale {
    address payable _seller;
    ERC721 _tokenContract;
    uint256 _tokenId;
    uint256 _delay;
    uint256 _timeLimit;
    uint256 _lastBid;
    address payable _lastBidder;

    constructor() public {
        _seller = msg.sender;
    }

    function setup(ERC721 tokenContract, uint256 tokenId, uint256 delay) external {
    require(msg.sender == _seller, "NOT_AUTHORIZED");
        _delay = delay;
        _tokenContract = tokenContract;
        _tokenId = tokenId;
        _tokenContract.transferFrom(msg.sender, address(this), tokenId);
        _timeLimit = now + delay;
    }

    function bid() external payable {
        require(msg.value > _lastBid, "BID_TOO_LOW");
        require(now < _timeLimit, "BID_OVER");
        _lastBidder.transfer(_lastBid);
        _timeLimit = now + _delay;
        _lastBid = msg.value;
        _lastBidder = msg.sender;
    }

    function widthrawPrice() external {

        require(now >= _timeLimit, "BID_NOT_OVER");

        if (_lastBidder != address(0)) {
            require(_lastBidder == msg.sender, "NOT_LAST_BIDDER");
        } else {
            require(_seller == msg.sender, "NOT_SELLER");
        }

        _tokenContract.safeTransferFrom(address(this), msg.sender, _tokenId);
    }

    function withdrawSale() external {
        _seller.transfer(_lastBid);
        _lastBid = 0;
    }
}