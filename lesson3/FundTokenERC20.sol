//SPDX-License-Identifier: MIT


pragma solidity  ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";


contract FundTokenERC20 is  ERC20{
    
    FundMe fundMe;

    function mint (uint256 amountToMint) public {
        require(fundMe.fundersToAmount(msg.sender) >= amountToMint, "You cannot mint many tokens");
        require(fundMe.getFundSuccess(), "The fundme is not completed yet");
        _mint(msg.sender,amountToMint);
        fundMe.setFunderToAmount(msg.sender, fundMe.fundersToAmount(msg.sender) - amountToMint);
    }


    function claim(uint256 amount) public {
        require(balanceOf(msg.sender) >= amountToClaim, "You dont have enough ERC20 tokens");

    }_

}