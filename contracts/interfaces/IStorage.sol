// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

interface IStorage {
    // TODO: add proof in the params and verify it here requirment statement inside
    // the function
    function addMessage(string memory message_) external payable;
}
