// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IStorage} from "./interfaces/IStorage.sol";

contract Storage is Ownable, IStorage {
    mapping(string => bool) public messages;

    constructor(address initialOwner) Ownable(initialOwner) {}

    function addMessage(string memory message_) external payable {
        require(!messages[message_], "Storage: such message is already exists");

        require(msg.value >= getCommission(message_), "Storage: comission is too low");

        messages[message_] = true;
    }

    function getCommission(string memory message_) public pure returns (uint256) {
        uint256 messageLength_ = bytes(message_).length;
        require(messageLength_ > 0, "Storage: too small message");
        return messageLength_ * 1 wei;
    }

    function withdraw(uint256 amount_) external onlyOwner {
        require(amount_ >= address(this).balance, "Storage: Insufficient contract balance");
        payable(owner()).transfer(amount_);
    }
}
