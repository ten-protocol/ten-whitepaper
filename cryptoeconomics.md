## Cryptoeconomics
All successful decentralised solutions need a strong incentive mechanism to keep the protocol functioning effectively. 

For simplicity, this analysis focuses on the normal functioning of the network, assuming it has reached adoption. Bootstrapping is handled separately.

### High Level Requirements
* Users have to pay for transactions a well-defined amount. The amount will cover the below two points and there will be no bidding wars.
* Node operators have to be paid for their service proportional to their costs.
* Aggregators have to be paid for the Ethereum gas fees they are spending to publish the rollup and make a profit.

### Context
The Bitcoin incentive model is very simple. Each transaction pays a fee and on top of that, each block contains a coinbase transaction, both going to the winner. If there are re-organisations of the chain, the block that makes it onto the canonical chain is the one that pays the reward, because it is in the ledger. This mechanism provides the right incentives for miners to follow the rules. One disadvantage of this model is that fees can get very high in periods of network congestion, which degrades user experience.

Ethereum builds on top of this model to handle the complexities of Turing complete smart contract execution, by introducing a notion of _gas_ and of _gas price_, but the high level mechanics remain the same.

The incentive design for a decentralised L2 protocol must also consider the problem of front-running the actual rollup. For a rollup to be final, it has to be added to an L1 block, which is where an L1 miner or staker can attempt to claim the reward that rightfully belongs to a different L2 node.

### Reward Claiming
TEN moves away from the Bitcoin/Ethereum approach and introduces the concept of _claiming rewards_ independently of the actual canonical rollup chain.

The great advantage is increased flexibility in aligning incentives, at the cost of increased complexity.

TEN nodes that are performing any activity according to the protocol have the possibility of submitting a transaction containing a proof and be rewarded accordingly. To achieve this, the protocol has to maintain a pool of tokens. Users pay fees into this pool, while nodes will be paid from it. During bootstrapping, the protocol will have the ability to add newly minted tokens to the pool. Once the network picks up, the protocol will be able to burn excess tokens.