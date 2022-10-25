// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract buyMeACryptoCoffee {
    uint256 totalCoffee;

    address payable public owner;

    event NewCoffee(
        address indexed from,
        uint256 timestamp,
        string message,
        string name,
        uint256 value
    );

    constructor() payable {
        console.log("This is contract");

        owner = payable(msg.sender);
    }

    struct Coffee {
        address giver;
        string message;
        string name;
        uint256 timestamp;
        uint256 value;
    }

    Coffee[] coffee;

    function getAllCoffee() public view returns (Coffee[] memory) {
        return coffee;
    }

    function getTotalCoffee() public view returns (uint256) {
        console.log("We have %d total coffee recieved ", totalCoffee);
        return totalCoffee;
    }

    function buyCoffee(
        string memory _message,
        string memory _name,
        uint256 _payAmount
    ) public payable {

        totalCoffee += 1;
        console.log("%s has just sent a coffee!", msg.sender);

        coffee.push(Coffee(msg.sender, _message, _name, block.timestamp, _payAmount));

        (bool success, ) = owner.call{value: _payAmount}("");
        require(success, "Failed to send money");

        emit NewCoffee(msg.sender, block.timestamp, _message, _name, _payAmount);
    }

    function destroySmartContract(address payable _to) public {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(_to);
    }
}
