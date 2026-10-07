# ERC-8004 Foundry Demo

Demo code from the **Tech with Pandit** video *ERC-8004 Explained: How AI Agents Trust Each Other On-Chain*.

📺 Channel: https://www.youtube.com/@panditdhamdheretech

These tests fork Ethereum mainnet and talk to the **official ERC-8004 registries**:

| Registry | Mainnet address |
|---|---|
| Identity | `0x8004A169FB4a3325136EB29fA0ceB6D2e539a432` |
| Reputation | `0x8004BAa17C55a88189AE136b182e5fdA19dE9b63` |

## What the tests show

- `test_registerAndReview`: registers an agent (mints an ERC-721 identity), a client leaves 87/100 feedback tagged `starred`, then reads it back with `getSummary`, which needs the list of reviewers you trust.
- `test_ownerCannotReviewOwnAgent`: an agent's owner tries to 5-star their own agent, and the Reputation Registry reverts. No self-feedback.

## Run it

You need [Foundry](https://getfoundry.sh) installed.

```bash
git clone https://github.com/<your-username>/erc8004-foundry-demo
cd erc8004-foundry-demo
export ETH_RPC_URL=https://ethereum-rpc.publicnode.com   # or your own mainnet RPC
forge test -vv
```

Quick check that the Identity Registry is live:

```bash
cast call 0x8004A169FB4a3325136EB29fA0ceB6D2e539a432 "name()(string)" --rpc-url $ETH_RPC_URL
# "AgentIdentity"
```

## Files

- `src/interfaces/IERC8004.sol`: minimal interfaces for the Identity and Reputation registries
- `test/ERC8004Fork.t.sol`: the two fork tests from the video

> ERC-8004 is still a **Draft** standard, so function signatures may change. Check the [EIP](https://eips.ethereum.org/EIPS/eip-8004) for the latest.

## License

MIT
