// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/finance/VestingWallet.sol";

// This contract is just to make VestingWallet available for verification
contract ImportVestingWallet is VestingWallet {
    constructor(address beneficiaryAddress, uint64 startTimestamp, uint64 durationSeconds) 
        VestingWallet(beneficiaryAddress, startTimestamp, durationSeconds) 
    {
    }
}
