## Obscuro and Ethereum Interaction

Obscuro is a confidential extension to Ethereum, and thus assets have to move freely between the two networks.

All side-chains and L2 solutions have developed solutions to the mismatches between the different models of the two networks, and typically there is a bridge contract that safeguards assets.

The difference between side-chains and L2 solutions is that mismatches are more significant for side-chains with their own finality and security mechanisms, and thus the bridge logic is either very complex or centralized.

At a high level, a user deposits ERC tokens in the Bridge contract, and the same amount will be credited with wrapped tokens on the user's account on Obscuro. The fact that the finality of L1 transactions is probabilistic makes crediting the L2 account not straightforward.

Most solutions solve this problem by waiting for a confirmation period before crediting the account. Obscuro takes a different approach and introduces a dependency mechanism between the L2 rollup and the L1 blocks.

The rule is that the L2 rollup that includes the transaction that credits the Obscuro account will have a hard dependency on an L1 block, and the Bridge contract will enforce that it is one of the ancestors of the current block.
If the L1 deposit transaction is no longer on the canonical L1 chain, it will automatically invalidate the rollup that contains the L2 deposit transaction. See the [Data model](./appendix#data-model) section and the user interaction diagram, as well as the following dependency diagram.

![deposit process](../images/deposit-process.png)

_Note: The deposit L2 transaction cannot be fully encrypted because the aggregator has to decide whether to include it in the current rollup based on the chances of the L1 block it depends on being final._

### Withdrawals
The high-level requirement for the withdrawal function is simple: allow Obscuro users to move assets back into the Ethereum network. The problem is that this is where the most significant threat against such a solution lies because there might be a large amount of locked value.

The challenge is to implement this functionality in a decentralized way by defining a protocol and economic incentives.
Due to the sensitivity of this function, many side-chains and L2 solutions rely on multi-signature technology to control the release of funds. Optimistic Rollups rely on a challenge mechanism during a long waiting period before releasing funds, powered by economic incentives.
Obscuro uses TEE technology, but it cannot leverage it for this aspect because of our threat model. The Bridge contract could release funds based on a signature from an attested TEE if it were invulnerable, but it is not, so the solution is to use economic incentives on top of the POBI protocol.

