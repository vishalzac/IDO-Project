pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract IDO {
    IERC20 public token;
    address public owner;
    uint256 public price;
    uint256 public tokensSold;
    uint256 public minPurchase;
    uint256 public maxPurchase;
    uint256 public startDate;
    uint256 public endDate;

    mapping(address => uint256) public balances;

    constructor(
        IERC20 _token,
        uint256 _price,
        uint256 _tokensSold,
        uint256 _minPurchase,
        uint256 _maxPurchase,
        uint256 _startDate,
        uint256 _endDate
    ) {
        token = _token;
        owner = msg.sender;
        price = _price;
        tokensSold = _tokensSold;
        minPurchase = _minPurchase;
        maxPurchase = _maxPurchase;
        startDate = _startDate;
        endDate = _endDate;
    }

    function buyTokens(uint256 _amount) public {
        require(block.timestamp >= startDate && block.timestamp <= endDate, "IDO has ended or not started yet");
        require(_amount >= minPurchase && _amount <= maxPurchase, "Invalid purchase amount");
        uint256 cost = _amount * price;
        require(token.transferFrom(msg.sender, address(this), cost), "Token transfer failed");
        balances[msg.sender] += _amount;
        tokensSold += _amount;
    }

    function withdrawTokens() public {
        require(msg.sender == owner, "Only owner can withdraw tokens");
        require(block.timestamp >= endDate, "IDO has not ended yet");
        uint256 balance = token.balanceOf(address(this));
        require(token.transfer(owner, balance), "Token transfer failed");
    }
}
