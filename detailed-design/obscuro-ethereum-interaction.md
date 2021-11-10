
## Obscuro and Ethereum Interaction
Obscuro is designed as a confidential extension to Ethereum. This means that assets have to move freely between the two networks.

The Bridge contract safeguards assets that are moved to the L2.

All side-chains and L2 solutions have to come up with solutions to the mismatches between the different models of the two networks.

Obscuro delegates finality and most security concerns to the Layer 1 network. There is a single situation where a Layer 1 voting based governance event has to decide between competing, persistent rollup forks.

## Deposits
At a high level, a user has to deposit ERC tokens in the Bridge contract, and the same amount has to be credited with wrapped tokens on the user's account on Obscuro. This is not straightforward since finality is probabilistic.

Typically, this problem is solved by waiting for a confirmation period. Obscuro solves this by introducing a dependency mechanism between the L2 rollup and the L1 blocks.

The L2 transaction that credits the Obscuro account will be in a L2 rollup that will only be accepted by the Bridge contract if the L1 block dependency is part of the ancestors of the current block.

In case the L1 deposit transaction is re-organised away from the current fork, it invalidates the rollup which contains the L2 deposit transaction. See the [Data model](../appendix#data-model) section and the user interaction diagram, as well as the following dependency diagram.

![deposit process](../images/deposit-process.png)

The L2 transaction that notifies an Obscuro node to update the balance cannot be encrypted because the aggregator has to make a decision whether to include it in the current rollup based on the chances of the L1 block to be final.

[TODO Is there a censorship problem to this approach?]

[TODO What is the incentive of the aggregator to add the deposit?]

## Withdrawals
There is a pool of liquidity stored in the L1 management contract, which is controlled by the group of TEEs who maintain the encrypted ledger of ownership. Some users will want to withdraw from the L2 and go back to L1, which means the Bridge contract will have to allow them to claim money from the liquidity pool.

### The Rollup-Chain
If the TEE technology was completely invulnerable, the Bridge contract could just release funds based on a signature from a valid TEE.

One attack is that one of the aggregators hacks the secure enclave, and is able to produce a proof that they own more and immediately withdraw it.

The solution to this problem makes use of the blockchain data model that was introduced already.

If an attack happened, it would manifest itself as multiple forks in the L2 chain. The Bridge contract cannot evaluate which one is correct because it can't execute the transactions inside. These could be both valid forks but some bug is preventing aggregators to agree.

The simple rule to detect an honest mistake is to wait for N blocks. If a fork does not progress for N blocks it is considered dead.

A real hack event would manifest itself as multiple forked long living chains with more than N rollups. The valid aggregators would ignore the invalid fork and continue on the valid one, while the hackers would publish rollups on the invalid fork.

This is a moment when the Network Management contract has to enter a special mode where the governance token holders will have to start aggregators with valid TEEs. These new TEEs will sign over the fork they consider valid. The result will be calculated based on the weighted stake.

### Withdrawal Process
Each TEE signed rollup will contain an unencrypted list of withdrawal requests. See: [Data Model](../appendix#data-model).

The Bridge contract will keep track of these requests and will execute them at different times, based on the status of the chain.

If at the moment of withdrawal there is only a single active head rollup, then all the system has to do is wait for a reasonable N number of blocks to ensure that there is no censorship attempt on L1. (Colluding L1 nodes could prevent a valid rollup from being published just long enough to not challenge the invalid one)

If there is a rollup fork, then the number of blocks have to be increased to allow one of the forks to die out naturally. If it doesn't then all withdrawals will be locked, and the contract will enter the special procedure described above.

This mechanism ensures that as long as there is one honest participant in the market and the L1 network is reasonably censorship resistant, the funds are safe.

The withdrawal process is indicated in the following diagram:
![deposit process](../images/deposit-process.png)