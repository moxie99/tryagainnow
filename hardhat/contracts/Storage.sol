// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./Disposer.sol";
import "@openzeppelin/contracts/utils/Context.sol";

/**
 * @title Storage : Uses proof of disposal
 * @dev Store & retrieve value in a variable
 */
contract Storage is Context, Disposer {
    error DuplicateProof();

    /**
        @notice Waste managers: 
                COLLECTOR: Users/Anyone.
                DISPOSER: Admin/Moderators.
     */
    // enum UserType { COLLECTOR, DISPOSER }


    enum Mode { NONE, PENDING, CONFIRMED }

    uint public wasteCounter;

    struct Collector {
        uint32 dateRecycled;
        bytes32 proof;
        bool userType;
    }

    bytes32[] public proofHash;
    
    mapping(bytes32 => Mode) public confirmation;

    /**
        @notice Proof records contain information for all 
     */
    mapping(address => mapping(uint => Collector)) private collectors;

    modifier validateProof(bytes32 proof) {
        if(confirmation[proof] == Mode.CONFIRMED) revert DuplicateProof();
        _;
    }

    modifier onlyDisposer() {

    }

    function _submitProofOfDisposal(bytes32 proof) internal validateProof(proof) {
        uint count = _generateId();
        collectors[msg.sender][count] = Collector(uint32(block.timestamp), proof, true);
        confirmation[proof] = Mode.PENDING;
        proofHash.push(proof);
    }

    function approvalDisposal(address who) internal virtual {
        require(confirmation);
    }

    function _generateId() internal returns(uint newCount) {
        newCount = proofHash.length;
    }
}
