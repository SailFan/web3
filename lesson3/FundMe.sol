// SPDX-License-Identifier: MIT


pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    AggregatorV3Interface internal dataFeed;

    // 1、创建一个收款函数
    // 2、记录投资人并且查看
    // 3、在锁定期内，达到目标值，生产商可以提款
    // 4、在锁定期内，没有达到目标值，投资人在锁定期以后退款

    
    function fund()
    external
    payable{

    }

    function convertEthToUsd(uint256 ethAmount) internal view returns (uint256) {
        // uint256()

    }

    function getChainlinkDataFeedLatestAnswer()
     public
     view
     returns(int){
        ( , int256 answer, , , ) = dataFeed.latestRoundData();
        return answer;
    }
}