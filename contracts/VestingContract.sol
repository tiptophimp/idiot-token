// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VestingContract
 * @dev A simple vesting contract that locks tokens for a specified duration
 * @notice This contract is immutable - vesting parameters cannot be changed after deployment
 */
contract VestingContract {
    // Immutable parameters set at deployment
    address public immutable beneficiary;
    uint256 public immutable cliffStart;
    uint256 public immutable vestingDuration;
    
    // Events
    event TokensReleased(address indexed beneficiary, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    // Owner for potential token transfers (if needed)
    address public owner;
    
    /**
     * @dev Constructor sets immutable vesting parameters
     * @param _beneficiary Address that will receive vested tokens
     * @param _cliffStart Unix timestamp when vesting starts
     * @param _vestingDuration Duration in seconds for complete vesting
     */
    constructor(
        address _beneficiary,
        uint256 _cliffStart,
        uint256 _vestingDuration
    ) {
        require(_beneficiary != address(0), "VestingContract: beneficiary is zero address");
        require(_cliffStart > 0, "VestingContract: cliff start must be positive");
        require(_vestingDuration > 0, "VestingContract: duration must be positive");
        
        beneficiary = _beneficiary;
        cliffStart = _cliffStart;
        vestingDuration = _vestingDuration;
        owner = _beneficiary; // Initially owned by beneficiary
    }
    
    /**
     * @dev Returns the amount of tokens that have vested
     * @return Amount of tokens that can be released
     */
    function vestedAmount() public view returns (uint256) {
        if (block.timestamp < cliffStart) {
            return 0;
        }
        
        uint256 elapsed = block.timestamp - cliffStart;
        if (elapsed >= vestingDuration) {
            return address(this).balance; // All tokens vested
        }
        
        // Linear vesting: (elapsed / duration) * total balance
        return (address(this).balance * elapsed) / vestingDuration;
    }
    
    /**
     * @dev Returns the amount of tokens that have been released
     * @return Amount of tokens already released
     */
    function releasedAmount() public view returns (uint256) {
        return address(this).balance - vestedAmount();
    }
    
    /**
     * @dev Release vested tokens to beneficiary
     * @notice Can only be called by beneficiary or owner
     */
    function release() external {
        require(
            msg.sender == beneficiary || msg.sender == owner,
            "VestingContract: caller is not beneficiary or owner"
        );
        
        uint256 vested = vestedAmount();
        require(vested > 0, "VestingContract: no tokens to release");
        
        // Transfer vested amount to beneficiary
        (bool success, ) = payable(beneficiary).call{value: vested}("");
        require(success, "VestingContract: transfer failed");
        
        emit TokensReleased(beneficiary, vested);
    }
    
    /**
     * @dev Transfer ownership of the contract
     * @param newOwner Address of the new owner
     * @notice Can only be called by current owner
     */
    function transferOwnership(address newOwner) external {
        require(msg.sender == owner, "VestingContract: caller is not the owner");
        require(newOwner != address(0), "VestingContract: new owner is zero address");
        
        address previousOwner = owner;
        owner = newOwner;
        
        emit OwnershipTransferred(previousOwner, newOwner);
    }
    
    /**
     * @dev Receive function to accept ETH deposits
     */
    receive() external payable {}
    
    /**
     * @dev Fallback function
     */
    fallback() external payable {}
}
