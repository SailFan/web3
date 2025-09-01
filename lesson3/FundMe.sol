// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// 1、 创建一个收款函数
// 2、 记录投资人并且查看
// 3、 达到目标值，生产商可以提款
// 4、 在锁定期内，没有达到目标值，投资人可以退款



contract FendMe{
    AggregatorV3Interface internal dataFeed;
    uint256 constant TARGET = 1 * 1e15;
    address public owner;
    mapping (address => uint256) public fundersToAmount;
    uint256 MINMUM_VALUE = 1 * 10 **15;


    constructor(){
        owner = msg.sender;
        // sepilia testnet
        dataFeed  = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    
    }

    function fund() 
    external
    payable {
        require(msg.value >= MINMUM_VALUE,'Send more ETH');
        fundersToAmount[msg.sender]  = msg.value;
    }


    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function convertEthToUsd(uint256 ethAmount) 
    internal
    view
    returns (uint256){
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmount * ethPrice / 1e8;
    }


    function getFund() external   {
        require(msg.sender == owner, "This function can only be called by owner");
        require(convertEthToUsd(address(this).balance) >= TARGET, "Target is not reached");
        // payable(msg.sender).transfer(address(this).balance);
        // bool isSuccess = payable(msg.sender).send(address(this).balance);
        // require(isSuccess == true, "tx failed");
        (bool isSuccess, )  = payable(msg.sender).call{value:address(this).balance}("");
        require(isSuccess == true, "tx failed");
        fundersToAmount[msg.sender] = 0;

    }


    function transferOwnership(address newAddress)public {
        require(msg.sender == owner, "This function can only be called by owner");
        owner = newAddress;
    }



    function refund() external {
        require(convertEthToUsd(address(this).balance)<=TARGET, "Target is not reached");
        require(fundersToAmount[msg.sender] != 0, "There is not fund for you");
        (bool isSuccess, )  = payable(msg.sender).call{value:fundersToAmount[msg.sender]}("");
        require(isSuccess == true, "tx failed");
        fundersToAmount[msg.sender] = 0;



    }

}