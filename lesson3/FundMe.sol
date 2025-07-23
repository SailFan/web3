// SPDX-License-Identifier: MIT


pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    address public owner;
    AggregatorV3Interface internal dataFeed;
    uint256 deploymentTimestamp;
    uint256 lockTime;

    // 1、创建一个收款函数
    // 2、记录投资人并且查看
    // 3、在锁定期内，达到目标值，生产商可以提款
    // 4、在锁定期内，没有达到目标值，投资人在锁定期以后退款

    constructor(uint256 lockTime){
        owner = msg.sender;
        deploymentTimestamp = block.timestamp;
        lockTime = lockTime;
    }


    function getFund()external  windowClosed onlyOwner {
    
    }


    
    // function fund()
    // external
    // payable{

    // }

    function convertEthToUsd(uint256 ethAmount)
     internal 
     view 
     returns (uint256) {
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmount * ethPrice / (1e8);
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




    modifier  windowClosed (){
        require((block.timestamp >= deploymentTimestamp + lockTime), "Window is not closed");
        _;
    }



    modifier onlyOwner() {  
        require(msg.sender == owner, "this function can only be called by owner");
        _;
    }
}