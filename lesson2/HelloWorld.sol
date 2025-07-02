// SPDX-License-Identifier: MIT


pragma solidity ^0.8.20;

contract HelloWorld{

    string strVar = "Hello wf";

    struct Info {
        string phrase;
        uint256 id;
        address addr;
    }

    mapping (uint256 => Info info) infoMapping;

    function sayHello(uint256 id)
    public 
    view 
    returns (string memory) {
        if(infoMapping[id].addr == address(0x0)){
            return strVar;
        }else{
            return addInfo(infoMapping[id].phrase);
        }
        
    }

    function addInfo(string memory helloStr)
    internal  
    pure
    returns (string memory){
        return string.concat(helloStr," postman ");
    }


    function setHello(uint256 id,string memory phrase ) 
    public {
       Info memory info = Info (phrase,id,msg.sender);
       infoMapping[id] = info;
    }

    
}

