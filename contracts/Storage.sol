// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.16;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IStorage} from "./interfaces/IStorage.sol";

contract Storage is Ownable, IStorage {
    mapping(uint256 => bool) public messages;

    constructor(address initialOwner) Ownable() {}

    function addMessage(uint256 message_) public {
        require(!messages[message_], "Storage: such message is already exists");

        messages[message_] = true;
    }
}
