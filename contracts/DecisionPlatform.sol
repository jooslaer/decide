// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";
import {euint32} from "@fhevm/solidity/lib/FHE.sol";

// decision-making platform with privacy
contract DecisionPlatform is ZamaEthereumConfig {
    struct Decision {
        address creator;
        string question;
        string[] options;
        euint32 weight;      // encrypted voting weight
        uint256 endTime;
        bool finalized;
    }
    
    struct Vote {
        address voter;
        euint32 choice;
        uint256 timestamp;
    }
    
    mapping(uint256 => Decision) public decisions;
    mapping(uint256 => Vote[]) public votes;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public decisionCounter;
    
    event DecisionCreated(uint256 indexed decisionId, address creator);
    event VoteCast(uint256 indexed decisionId, address voter);
    event DecisionFinalized(uint256 indexed decisionId);
    
    function createDecision(
        string memory question,
        string[] memory options,
        euint32 encryptedWeight,
        uint256 duration
    ) external returns (uint256 decisionId) {
        decisionId = decisionCounter++;
        decisions[decisionId] = Decision({
            creator: msg.sender,
            question: question,
            options: options,
            weight: encryptedWeight,
            endTime: block.timestamp + duration,
            finalized: false
        });
        emit DecisionCreated(decisionId, msg.sender);
    }
    
    function vote(uint256 decisionId, euint32 encryptedChoice) external {
        Decision storage decision = decisions[decisionId];
        require(!decision.finalized, "Decision finalized");
        require(block.timestamp < decision.endTime, "Time expired");
        require(!hasVoted[decisionId][msg.sender], "Already voted");
        
        votes[decisionId].push(Vote({
            voter: msg.sender,
            choice: encryptedChoice,
            timestamp: block.timestamp
        }));
        
        hasVoted[decisionId][msg.sender] = true;
        emit VoteCast(decisionId, msg.sender);
    }
    
    function finalizeDecision(uint256 decisionId) external {
        Decision storage decision = decisions[decisionId];
        require(decision.creator == msg.sender, "Not creator");
        require(block.timestamp >= decision.endTime, "Still active");
        
        decision.finalized = true;
        emit DecisionFinalized(decisionId);
    }
}

