// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";
// 1、参与者获取token
// 2、参与者转移token
// 3、销毁token
contract FundTokenERC20 is ERC20 {
    FundMe fundMe;
    constructor(address addr) ERC20("FundToken", "FUND") {
        fundMe = FundMe(addr);
    }


    function mint(uint256 amountToMint) public {
        require(fundMe.getFundSuccess(), "The fundme is not compelted yet");
        require(fundMe.fundersToAmount(msg.sender) >= amountToMint, "you cannot mint this many tokens");
        _mint(msg.sender, amountToMint);
        fundMe.setFundMapping(msg.sender, fundMe.fundersToAmount(msg.sender) - amountToMint);
    }



    function claim(uint256 amountToClain) public {
        require(fundMe.getFundSuccess(), "The fundme is not compelted yet");
        require(balanceOf(msg.sender) >=amountToClain, " you dont have enough ERC20 tokens" );
        _burn(msg.sender, amountToClain);
    }
}

