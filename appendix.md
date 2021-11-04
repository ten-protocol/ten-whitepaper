# Appendix
## Contributors
The Obscuro project is decentralised in nature, and this whitepaper has benefited enormously with feedback from the following contributors:
* Gavin Thomas
* Neal Shah
* Richard Gendal Brown
* Mike Hearn
* Moritz Platt
* Tim Brinded
* Fred Dalibard

Additional feedback is welcome, and all reviewers will be credited.

## Glossary
**Smart Contract / Contract**
A user application running on a blockchain network which holds data or state, responds to user commands, and may store and manage assets or money.

**L1**
Layer 1, in this case the public Ethereum blockchain and network.

**L2**
Layer 2, a second network built on top of a L1 network and dependent on it. A L2 network expands on the capabilities of the L1 network by increasing capacity or enhancing functionality.

**TEE**
Trusted Execution Environment, in this case an environment where contracts may be managed in a deterministic, repeatable and auditable way, based on a set of trust dependencies. This design begins with SGX.

**SGX**
Software Guard Extensions, a technology provided by Intel, a major CPU manufacturer. An SGX CPU has an area for encrypted computation, which the operator cannot access, secured by a private key burnt into the CPU during manufacture.

**Host**
The party controlling the physical server who runs the TEE. In the threat model of typical confidential computing applications, including Obscuro, the Host is an adversary of the system.

**L1 management contract**
Part of the solution is a smart contract which runs on Ethereum and handles all L1 concerns.

**Aggregator**
A node which participates in a L2 network and collaborates with other aggregator nodes to manage the L2 contracts and confirm correctness of transactions. Specifically, it participates in transaction gossip, and may propose transaction rollups to be registered with the L1 blockchain.

**Verifier**
A _light_ L2 node which observes transaction rollups published to the L1 blockchain, and can participate in possible disputes. Any verifier can become an aggregator by registering on the L1 contract and pledging some stake.

**Rollup**
Rollups are L2 solutions that perform transaction execution outside the main L1 chain, but post transaction data on L1. A rollup is a batch of transactions that were executed by the L2 verifiers.

**Sequencer**
A sequencer is the selected aggregator which builds a rollup in a round.

## Data Model
This diagram shows the data structure for the Management contract and aggregator:
![management-contract](./images/management-contract.png)

This diagram shows the data structure for the rollup and withdrawal:
![rollup](./images/rollup.png)

This diagram shows the data structure for the transactions and account:
![transaction-account](./images/transaction-account.png)

## Design Alternatives
This section describes alternatives considered and discarded.

### Alternative L1 Deposit management
On a high level, a user has to deposit some ERC tokens on the L1 management contract, and the same amount has to be credited on the user's account on Obscuro. This is not straightforward since finality is probabilistic.
One option to achieve this is to wait a number of L1 blocks for confirmation. This has some clear disadvantages.
Another option is to introduce a dependency mechanism between the L2 rollup and the L1 blocks. Basically, the L2 transaction that credits the Obscuro account will be in a L2 rollup that will only be accepted by the management contract if the dependency is part of the ancestors of the current block.  In case the L1 deposit gets reorganised away before the rollup is created, it invalidates the rollup which contains the L2 deposit transaction.

### Alternative L1 Theft Prevention
There is a pool of liquidity stored in the L1 Bridge contract, which is controlled by the group of TEEs who maintain the encrypted ledger of ownership. Some users will want to withdraw from the L2 and go back to L1, which means the management contract will have to allow them to claim money from the liquidity pool.

In case one of the aggregators is able to hack the TEE, they will be able to produce a proof that they own much more and thus run with it.

To solve this we have a couple of options.
We could organise the aggregators in a BFT setup, and require that 2/3 of them sign over each rollup. The major disadvantage with this approach is that the finality of a L2 transaction will depend on both the BFT finality and the L1 finality. Another disadvantage is that a determined hacker with the means to break secure hardware could also amass the majority of staking power and be unchallenged.

Another option, with a better trust model is to introduce a challenge mechanism similar to the optimistic rollups. The disadvantage is that it introduces a delay, and a concept of probabilistic finality. On the other hand, as long as there is one honest participant in the market, the funds are safe.

The data structure containing the rollups is a chain that can have multiple heads. The management contract cannot evaluate which one is correct because it can't execute the transactions inside. But there are some simple rules that can be applied. For example, if a branch does not progress for N blocks it is considered dead.

If at the moment of withdrawal there is only a single active head rollup, then all the system has to do is wait for a reasonable number of blocks (20-50) to ensure that there is no censorship attempt on L1. If there is a fork, then the number of blocks have to be increased to allow one of the forks to die out naturally. If it doesn't then all withdrawals will be locked, and the contract will enter a special procedure.

### Alternative Revelation Options
The solution will reveal all transactions after one year through a key-rotation process. However, two additional policies are considered:
* The solution is designed such that secret-key sharing with law-enforcement agencies is possible. This raises two additional challenges: Firstly, a governance function must be established to weigh on the legitimacy of an agency and its request may be considered, and this would likely be a highly opinionated, protracted and politically-influenced process. Secondly, the shared secret is a singleton, regardless of user, application or geography. Either an entitled agency would immediately see all L2 data, or the governance body would itself need to provide an operation to query and extract specific data, which adds additional control and operational costs.
* The solution is designed so that a ratio of transactions (e.g., 1%) are revealed, either immediately or subsequently. Illegal transaction detection then becomes risk-based, but the ratio cannot be high enough to be a disincentive and yet still provide utility.

### Alternative Nonce Generation
A further issue is to ensure that the aggregator host will not be able to repeatedly submit the rollup proof to the TEE to get a new random nonce, and thus achieve a low nonce. The option chosen is to use monotonic counters, but an alternative is to make the nonce deterministic. The nonce is deterministically derived from the L1 block hash combined with the public key of the enclave. This achieves the same purpose of being a fair lottery assuming there is no collusion between L1 miners and L2 aggregators. Even if there was collusion, the cost of gaming the L1 hash might be too high in a proof of work network. In a _Proof of Stake_ network, on the other hand, collusion with L1 would pretty much mean that each round the L1 winner will also win the L2 round.

[Page history]({{ site.github.repository_url }}/blame/main/{{page.path}})