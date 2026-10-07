// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {IIdentityRegistry, IReputationRegistry} from "../src/interfaces/IERC8004.sol";

contract ERC8004ForkTest is Test {
    // Official ERC-8004 registries on Ethereum mainnet (from github.com/erc-8004/erc-8004-contracts)
    IIdentityRegistry identity = IIdentityRegistry(0x8004A169FB4a3325136EB29fA0ceB6D2e539a432);
    IReputationRegistry reputation = IReputationRegistry(0x8004BAa17C55a88189AE136b182e5fdA19dE9b63);

    address agentOwner = makeAddr("agentOwner");
    address client = makeAddr("client");

    function setUp() public {
        vm.createSelectFork(vm.envString("ETH_RPC_URL"));
    }

    function test_registerAndReview() public {
        // 1. Register an agent -> mints an ERC-721, returns agentId
        vm.prank(agentOwner);
        uint256 agentId = identity.register("ipfs://bafy.../agent.json");

        assertEq(identity.ownerOf(agentId), agentOwner);
        assertEq(identity.getAgentWallet(agentId), agentOwner); // defaults to owner
        console.log("agentId:", agentId);

        // 2. A client leaves feedback: 87/100, tag "starred"
        vm.prank(client);
        reputation.giveFeedback(agentId, 87, 0, "starred", "", "", "", bytes32(0));

        // 3. Read the summary - you MUST pass the reviewers you trust
        address[] memory trusted = new address[](1);
        trusted[0] = client;
        (uint64 count, int128 value, uint8 decimals) =
            reputation.getSummary(agentId, trusted, "starred", "");

        assertEq(count, 1);
        assertEq(value, 87);
        assertEq(decimals, 0);
    }

    function test_ownerCannotReviewOwnAgent() public {
        vm.startPrank(agentOwner);
        uint256 agentId = identity.register("ipfs://bafy.../agent.json");

        vm.expectRevert(); // "Self-feedback not allowed"
        reputation.giveFeedback(agentId, 100, 0, "starred", "", "", "", bytes32(0));
        vm.stopPrank();
    }
}
