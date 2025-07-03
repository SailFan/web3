// SPDX-License-Identifier: MIT


pragma solidity ^0.8.20;

import { HelloWorld } from "./HelloWorld.sol";

contract HelloWorldFactory{
    HelloWorld  helloWorldInstance;
    HelloWorld[] helleWorlds;

    function createHelloWorld() public {
        helloWorldInstance = new HelloWorld();
        helleWorlds.push(helloWorldInstance);
    }

    function getHelloWorld(uint256 index)
     view
     public 
     returns  (HelloWorld){
        return helleWorlds[index];
    }


    function callHello(uint256 _id, uint256 _index) view  public returns (string memory){
       return getHelloWorld(_index).sayHello(_id);
    }

    function callSetHello(uint256 _index,uint256 _id, string memory str ) 
    public{
        helleWorlds[_index].setHello(_id,str);
    }
}