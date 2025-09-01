//SPDX-License-Identifier: MIT


pragma solidity ^0.8.20;

contract  FundToken {
    //1. 通证的名字
    //2、通证的简称
    //3 通证的发行数量
     // 4. owner地址

    string public  tokenName;
    string public tokenSymbol;
    uint256 public totalSupply;
    address public owner;
    mapping (address => uint256) public balances;


    // mint 通证
    function mint(uint256 amount) 
    public {
        balances[msg.sender]+= amount;
        totalSupply += amount;
    }


    function balancesOf(address addr) 
    public 
    view  
    returns (uint256){
        return balances[addr];
    }


    function transferToken ()pub]{

    }


}