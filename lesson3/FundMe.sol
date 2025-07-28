// SPDX-License-Identifier: MIT


pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    address public owner;
    AggregatorV3Interface internal dataFeed;
    uint256 deploymentTimestamp;
    uint256 lockTime;
    mapping(address => uint256) public fundersToAmount;
    bool public getFundSuccess = false;
    uint256 constant MINIMUM_VALUE = 100 * 10; //USD
    uint256 constant TARGET = 1000 * 10;

    // 1、创建一个收款函数
    // 2、记录投资人并且查看
    // 3、在锁定期内，达到目标值，生产商可以提款
    // 4、在锁定期内，没有达到目标值，投资人在锁定期以后退款

    constructor(uint256 lockTime){
        owner = msg.sender;
        deploymentTimestamp = block.timestamp;
        lockTime = lockTime;
    }


    function getFund() 
    external  
    windowClosed 
    onlyOwner {
        require(convertEthToUsd(address(this).balance) >= TARGET, "Target is not reached");
        bool success;
        (success, )  = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "transfer tx failed");
        // fundersToAmount[msg.sender] = msg.value;
        getFundSuccess = true;
    }



    
    function fund()
    external
    payable{
        require(convertEthToUsd(msg.value) >= MINIMUM_VALUE, "Send more ETH");
        require(block.timestamp < deploymentTimestamp + lockTime, "window is closed");
        fundersToAmount[msg.sender] = msg.value;

    }

    function convertEthToUsd(uint256 ethAmount)
     internal 
     view 
     returns (uint256) {
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmount * ethPrice / (1e26);
    }

    function getChainlinkDataFeedLatestAnswer()
     public
     view
     returns(int){
        ( , int256 answer, , , ) = dataFeed.latestRoundData();
        return answer;
    }

    function transferOwnership (address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function setErc20Addr(address _erc20Addr) public onlyOwner {
        erc20Addr = _erc20Addr;
    }


    function refund() external windowClosed(){
        require(convertEthToUsd(address(this).balance) < TARGET, "Target is reached");
        require(fundersToAmount[msg.sender]!=0, 'there is no fund for you' );
        bool success;
        (success, ) = payable(msg.sender).call{value: fundersToAmount[msg.sender]}("");
        require(success, "transfer tx failed");
        fundersToAmount[msg.sender] = 0;




    }


    modifier  windowClosed (){
        require((block.timestamp >= deploymentTimestamp + lockTime), "Window is not closed");
        _;
    }



    modifier onlyOwner() {  
        require(msg.sender == owner, "this function can only be called by owner");
        _;
    }
}