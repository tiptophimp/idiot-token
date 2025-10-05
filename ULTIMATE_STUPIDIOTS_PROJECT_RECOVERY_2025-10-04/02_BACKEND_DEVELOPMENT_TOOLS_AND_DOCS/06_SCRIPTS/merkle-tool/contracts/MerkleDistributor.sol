// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title MerkleDistributor for IDIOT
/// @notice Simple distributor: claim with a Merkle proof (address, amountWei)
contract MerkleDistributor is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;
    bytes32 public merkleRoot;

    uint256 public claimStart;
    uint256 public claimEnd;

    mapping(address => bool) public claimed;

    event Claimed(address indexed account, uint256 amount);
    event MerkleRootUpdated(bytes32 root);
    event WindowUpdated(uint256 start, uint256 end);
    event Swept(uint256 amount, address to);

    constructor(address _token) Ownable(msg.sender) {
        require(_token != address(0), "token=0");
        token = IERC20(_token);
    }

    function setMerkleRoot(bytes32 _root) external onlyOwner {
        merkleRoot = _root;
        emit MerkleRootUpdated(_root);
    }

    function setWindow(uint256 _start, uint256 _end) external onlyOwner {
        require(_end == 0 || _end > _start, "bad window");
        claimStart = _start;
        claimEnd = _end;
        emit WindowUpdated(_start, _end);
    }

    function isActive() public view returns (bool) {
        if (claimStart != 0 && block.timestamp < claimStart) return false;
        if (claimEnd != 0 && block.timestamp > claimEnd) return false;
        return true;
    }

    function claim(uint256 amountWei, bytes32[] calldata proof) external {
        require(isActive(), "not active");
        require(!claimed[msg.sender], "already claimed");
        // leaf = keccak256(abi.encode(msg.sender, amountWei))
        bytes32 leaf = keccak256(abi.encode(msg.sender, amountWei));
        require(verify(leaf, proof), "bad proof");

        claimed[msg.sender] = true;
        token.safeTransfer(msg.sender, amountWei);
        emit Claimed(msg.sender, amountWei);
    }

    function verify(bytes32 leaf, bytes32[] calldata proof) public view returns (bool) {
        bytes32 computed = leaf;
        bytes32 root = merkleRoot;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 p = proof[i];
            computed = computed <= p
                ? keccak256(abi.encodePacked(computed, p))
                : keccak256(abi.encodePacked(p, computed));
        }
        return computed == root;
    }

    /// @notice sweep remaining tokens after window ends
    function sweep(address to) external onlyOwner {
        require(claimEnd != 0 && block.timestamp > claimEnd, "not ended");
        uint256 bal = token.balanceOf(address(this));
        token.safeTransfer(to, bal);
        emit Swept(bal, to);
    }
}
