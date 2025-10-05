// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MerkleDistributor is Ownable, ReentrancyGuard {
    IERC20 public immutable token;
    bytes32 public merkleRoot;
    uint256 public claimStart;
    uint256 public claimEnd;
    
    mapping(address => bool) public claimed;
    
    event Claimed(address indexed account, uint256 amount);
    event MerkleRootUpdated(bytes32 indexed merkleRoot);
    event ClaimWindowUpdated(uint256 start, uint256 end);
    
    constructor(address _token) {
        token = IERC20(_token);
    }
    
    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
        emit MerkleRootUpdated(_merkleRoot);
    }
    
    function setClaimWindow(uint256 _start, uint256 _end) external onlyOwner {
        require(_start < _end, "Invalid window");
        claimStart = _start;
        claimEnd = _end;
        emit ClaimWindowUpdated(_start, _end);
    }
    
    function claim(
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external nonReentrant {
        require(block.timestamp >= claimStart, "Claim not started");
        require(block.timestamp <= claimEnd, "Claim ended");
        require(!claimed[account], "Already claimed");
        
        bytes32 leaf = keccak256(abi.encodePacked(account, amount));
        require(MerkleProof.verify(merkleProof, merkleRoot, leaf), "Invalid proof");
        
        claimed[account] = true;
        require(token.transfer(account, amount), "Transfer failed");
        
        emit Claimed(account, amount);
    }
    
    function sweepUnclaimed() external onlyOwner {
        require(block.timestamp > claimEnd, "Claim window active");
        uint256 balance = token.balanceOf(address(this));
        require(token.transfer(owner(), balance), "Sweep failed");
    }
    
    function isClaimed(address account) external view returns (bool) {
        return claimed[account];
    }
    
    function canClaim(address account) external view returns (bool) {
        return block.timestamp >= claimStart && 
               block.timestamp <= claimEnd && 
               !claimed[account];
    }
}
