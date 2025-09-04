// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// 1、 创建一个收款函数
// 2、 记录投资人并且查看
// 3、 达到目标值，生产商可以提款
// 4、 在锁定期内，没有达到目标值，投资人可以退款



contract FundMe{
    AggregatorV3Interface internal dataFeed;
    uint256 constant TARGET = 10 * 1e15;
    address public owner;
    mapping (address => uint256) public fundersToAmount;
    uint256 MINMUM_VALUE = 1 * 10 **15;
    uint256 deployTimestamp;
    uint256 lockTime;
    address addressERC20;
    bool public  getFundSuccess = false;



    constructor(uint256 _lockTime){
        owner = msg.sender;
        // sepilia testnet
        dataFeed  = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deployTimestamp = block.timestamp;
        lockTime = _lockTime;
    }


    function setFunderAddress (address _erc20Address)public onlyOwner{
        addressERC20 = _erc20Address;
    }



    function setFundMapping  (address funder, uint256 _amount) external{
        require(msg.sender == addressERC20, "only owner");
        fundersToAmount[funder] = _amount;
    }



    function fund() 
    external
    payable {
        require(msg.value >= MINMUM_VALUE,'Send more ETH');
        require(block.timestamp < (deployTimestamp + lockTime), "window is closed");
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


    function getFund() external  windowClose  onlyOwner{
        require(convertEthToUsd(address(this).balance) >= TARGET, "Target is not reached");
        // payable(msg.sender).transfer(address(this).balance);
        // bool isSuccess = payable(msg.sender).send(address(this).balance);
        // require(isSuccess == true, "tx failed");
        (bool isSuccess, )  = payable(msg.sender).call{value:address(this).balance}("");
        require(isSuccess == true, "tx failed");
        fundersToAmount[msg.sender] = 0;
        getFundSuccess = true;

    }


    function transferOwnership(address newAddress)public  onlyOwner{
        owner = newAddress;
    }



    function refund() external windowClose{
        require(convertEthToUsd(address(this).balance)<=TARGET, "Target is not reached");
        require(fundersToAmount[msg.sender] != 0, "There is not fund for you");
        (bool isSuccess, )  = payable(msg.sender).call{value:fundersToAmount[msg.sender]}("");
        require(isSuccess == true, "tx failed");
        fundersToAmount[msg.sender] = 0;
    }



    

    modifier windowClose (){
        require(block.timestamp >= (deployTimestamp + lockTime), "window is closed");
        _;
    }
// 1.9909
// 1.9898 

    modifier onlyOwner(){
        require(msg.sender == owner, "This function can only be called by owner");
        _;
    }

}