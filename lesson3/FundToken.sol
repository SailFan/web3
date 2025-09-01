//SPDX-License-Identifier: MIT


pragma solidity ^0.8.20;


contract FundToken{

    // 1、Token的数量
    // 2、token 的名称
    // 3、token 的发行数量
    // 4、 owner的地址
    

    string public tokenName;
    string public tokenSymbol;
    uint256 public totalSupply;
    address public owner;
    mapping (address => uint256) public balanceOf;




    constructor(string memory _tokenName,string memory _tokenSymbol){
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        owner = msg.sender;
    }


    function mint(uint256 amountToMint) public {
        balanceOf[msg.sender] += amountToMint;
        totalSupply += amountToMint;
    }



    function transfer(address addr, uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "You do not have enough balance to transfer");
        balanceOf[msg.sender] -= amount;
        balanceOf[addr]+= amount;
    }


    function balanceOfWho(address addr) public view returns (uint256){
        return balanceOf[addr];

    }


}