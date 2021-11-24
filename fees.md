## Fees
Obscuro has a fee structure that delivers a steady and predictable income for node operators and a predictable fee for users proportional to the actual costs of running the network and does not rely on bidding wars or vary according to activity.

The structure also doesn't punish Aggregators that miss out on a publishing opportunity with slashing. Instead, the loss of reward should be incentive enough.

### What Fees Are For
- Operators run the network and incur operational costs by running and maintaining nodes.
- Aggregator nodes incur a cost from storing rollup data on Ethereum.
- Aggregator nodes incur a cost from the overhead in participating in publishing rollups outside of the storage cost, e.g. signing transactions

The Obscuro protocol rewards both Validators and Aggregators that actively monitor the network via a lottery. The lottery randomly rewards active nodes each round with an OBX reward for participating. Nodes prove they're alive by claiming their reward within the subsequent few blocks; else, the reward is burned. This is designed to cover the operational costs of active nodes

To incentivize nodes to join the Obscuro network, nodes must have a path to making a profit. The profit comes from rewards paid out in OBX for Aggregator nodes that successfully win the right to validate and publish a rollup. This reward covers both the L1 costs incurred and a profit margin

### Fee Mechanics
An 'expected monthly node operational costs' variable is set through the governance protocol, which is designed to reflect how much a node operator would pay for hardware, hosting etc, in a month, with a margin for profit.

What follows is a treatment of the fee mechanics

1. The monthly operational cost, which is a flat fee set to represent the monthly operational cost to run a node in OBX, and represented as:

![equation_1.png](./images/equation_1.png)

2. The cost incurred by nodes for L1 storage, represented as:

![equation_2.png](./images/equation_2.png)

3. The additional overhead cost incurred by nodes for publishing rollups is as follows:

![equation_3.png](./images/equation_3.png)

Factoring in the upper limit on gas costs within Obscuro and the current cost of storing one byte of data in Ethereum calldata as 16, this gives the fee per transaction as:

![equation_4.png](./images/equation_4.png)

The lottery payout (active node reward) amount per rollup round is represented as:

![equation_5.png](./images/equation_5.png)

### Bootstrapping the Network
When the network first spins up, it's prudent to expect low transaction volume. Low transaction volume creates a situation where:

1. Nodes can publish continually at a high cadence and absorb what might amount to a loss-making operation.
2. Nodes can throttle the rate at which rollups are published, leading to a poorer user experience.
3. Alternatively, the network can subsidize early transactions allowing both groups to succeed.

While Obscuro optimizes for end-users, early nodes should also be profitable. As such, Obscuro follows the path of option 3:

- In the young days of the network, fees will be subsidized by newly minted tokens to ensure early users do not face excessive fees. The price of a transaction is fixed at $1 in OBX until OBX establishes a stable market.
- A period of subsidizing new nodes that reduces over time until transaction volume picks up and market forces take over.

### Miscellaneous
As an alternative to setting a fixed price of $1 in OBX, the protocol could have throttled the number of rollups that could be published across a set of L1 blocks. Reducing the rate at which rollups are published reduces the overall L1 gas cost of the network and so reduces the cost passed onto early users. However, this would come at the expense of the user experience and so is ruled out.

Given that fees are expressed in ETH and Aggregators must pay gas costs in ETH on L1, there needs to exist an available exchange rate for OBX/ETH. This can be obtained from an exchange running on Obscuro and rely on normal market operations to keep the exchange rate in line with other exchanges that OBX trades on within L1, or L1 prices can be fed in via an oracle
