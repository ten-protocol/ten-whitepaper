# Threat Model
Obscuro is different from traditional L1 or L2 solutions primarily because data is stored and processed privately in trusted execution environments, which brings a new set of threats. Compared to other L2 solutions, the decentralised nature of the POBI protocol also brings some new threats.

The main threat to any ledger technology is data corruption, also known as a safety failure. It could take the form of stealing assets, double spending assets, or, more generally, adding illegal entries. Leading blockchains solve this problem by implementing a _Byzantine Fault Tolerant_ (BFT) consensus between independent parties and creating incentives to ensure that anyone who breaks the rules will not be rewarded or will even be penalized. The most extreme attack is a 51% _Sybil_ attack, where the attacker somehow gains the majority of the decision power (computing power for _proof of work_ or stake for _proof of stake_) and can rewrite the history. This attack manifests as replacing an existing valid transaction with a valid competing transaction. While the ledger remains _logically_ valid, this is equivalent to stealing for the beneficiary of the first transaction. If the attacker tried to _physically_ corrupt the ledger, everyone would ignore the invalid block.  The best defense against this attack is to ensure that multiple independent powerful actors have no incentive to collude.

The general principle of the Obscuro protocol is that it reverts to the behavior of a typical non-confidential blockchain in case of hacks on the TEE technology. In other words, the safety of the ledger does not depend on the hardness of the TEEs; instead, what happens is that attackers can read transactions and data. Also, Obscuro does not delegate safety to a single actor by planning to support TEEs from multiple hardware manufacturers. In case of severe attacks, there are multiple mitigation mechanisms in place, the ultimate being that the L2 ledger is frozen, and everyone has the chance to withdraw using balance proofs.

Obscuro achieves data availability in the same way as all the other rollup solutions; the L1 is the source of data truth for the L2 network. Any L2 node with a valid TEE in possession of the shared secret can download the rollup chain from the L1, calculate the entire state inside its encrypted memory, and at the same time validate all transactions.

The following sections will analyse the different threats against the Obscuro protocol.

## Threats to the TEE Technology
The Obscuro design considers that the TEE technology and the program inside are not easily hackable, so the protocol is not optimised to handle them. Attacks on TEEs have occurred in laboratories, so a secondary but essential concern is to prevent ultra-sophisticated actors with the ability to hack this technology from stealing funds or breaking the integrity of the ledger.

_The threat model of Obscuro is that sophisticated attackers run an aggregator node on a machine with a TEE they control, have access to the master seed and the entire ledger, and run any possible attack on it, including attacks on the physical CPU._

Assuming that such attacks are successful, the attacker can limit themselves to read-level access or an attempt to corrupt the ledger using a write-level attack.

### Read-level attacks
Read-level hacks happen when the attacker can extract some information from the TEE. This threat is specific to confidential blockchains.

The only way to defend against these attacks is to carefully audit the code and keep the _Attestation Constraints_ up to date. If this attacker is discreet, the information leak can continue until a software patch is published or until new hardware that removes this attack is released.

Another way to defend against it which will be considered in future versions is to implement a scheme similar to key rotations.

The least severe read attack is a side-channel where the attacker can find information about a specific transaction. The most severe is when the attacker can extract the master secret and read all present and future transactions.

If such an attack is successful, the network is equivalent to the behavior of a typical public blockchain where all transactions are public, and MEV is possible.

### Write-level attacks
Write-level hacks are powerful in theory since they could enable the attacker to _write_ to the ledger and thus be able to break its integrity if there were no other protections.

A write-level hack could happen if an attacker extracts the enclave key and signs hand-crafted rollups that contain invalid transactions or balances.

_Note: This type of attack is viewed as the main threat to the protocol and thus handled explicitly._

The mechanism to prevent this attack is described in detail in the [Withdrawals](./obscuro-ethereum-interaction.md#withdrawals) section.

The high-level goal of the protections is to transform such an attack into a liveness attack on the withdrawal function.

### Colluding write level attacks
An extreme variant of the _Write-level attack_ is performed by a powerful group that hacked the TEE and was able to take complete control of all the aggregator nodes.

The defense against this attack is to incentivise a reasonable number of verifiers to watch the Obscuro ledger in real-time. These actors will detect a malicious head rollup and notice that no other valid fork is being published.

_Note: One such actor monitoring the network will be the Obscuro Foundation, which has the mandate to keep the protocol functioning correctly. The protocol also rewards other independent parties to take on this job by assigning random rewards to verifiers who can prove they are active._

Any L2 node can become an aggregator quickly by benefiting from the censorship resistance of Ethereum.  To counter the attack, they will have to pay the stake and publish a correct rollup.

### Attacks against the fair lottery that designates the winner of the round
The POBI protocol assigns a leader each round by using random numbers generated inside the TEE. An attacker that can hack the technology could generate a well-chosen number and thus win each round. This is not an attack against the safety of the ledger and is not of great concern.

If some aggregator wins statistically many more rounds than they should, it will highlight the problem to the community.

A more dangerous variation of the attack is when the attacker can also read transactions and thus front-run and extract value.

_Note: This area is under research_.

A variation of this attack is when the attacker cannot directly hack the TEE, but it is restarting the TEE in the hope of generating a lower nonce and thus improving their chances. This threat is mitigated by a delay introduced at the startup of the OVM, which will cause the attacker to miss out on that rollup cycle.

## Other threats to the protocol
This section analyses threats not directly linked to the TEE, although a hack against the TEEs might amplify them.

### Invalid rollup attacks
The _Rollup Contract_ only accepts signed rollups from aggregators that can prove their TEE attestation, and unless the TEE itself is corrupted, it is impossible to publish invalid rollups. This means that such an attack will become a liveness attack when forks are detected in the rollup chain.

### Empty rollup attacks
An aggregator winning a round can freely publish empty rollups, but that would not harm the system if there were multiple independent aggregators. It will just slow down the network. Obscuro disincentivises this attack since the reward for the publisher is linked to the fees collected from the included transactions.

## Sybil Attacks
This section will analyse the threats that a powerful adversary who can create many aggregators can pose on the protocol.
The reasoning around this attack is quite different from typical public blockchains.

There are two ways to run this attack against Obscuro depending on the capabilities of the attacker:

1. The attacker sets up N CPUs with TEE and pays the stake for each of them, where (N > Total_Number_Of_Aggregators / 2).
2. The attacker hacks the TEE and can impersonate many TEEs limited only by the stake. This attack has been analysed in the "Colluding write-level attack".

### Sybil attack without hacking the TEE
If the attacker cannot hack the TEE, they cannot deviate from the canonical chain or insert illegal transactions, as the attested software will not let them. Having a majority on the Obscuro network will not help with this. An attacker who wants to perform a double-spend attack on Obscuro will have to change the canonical chain already published in L1 blocks. To perform a double spend, the attackers have to perform a double-spend attack on the L1 blocks themselves that contain the rollups.

### Economical Sybil attacks
Another type of attack, which a well-resourced actor can perform, is controlling many aggregators to make a good return from the rewards. The more aggregators someone controls, the more chances to get winning nonces they have.

There is no risk in altering the ledger or performing double-spend attacks. There is no risk of a Denial of Service attack either, by refusing to publish winning rollups since the incentives encourage other actors to quickly fill in gaps and publish rollups.

There are no risks of driving other aggregators out of business by denying them the chance to win rollups since they will get the reward of being active nodes.

### Catastrophic events
One crucial challenge of such a system is ensuring that some catastrophic event cannot leave all the value locked.
[todo tudor]

## Front-Running by Aggregators
[todo tudor - this is duplicated]
A TEE that emits events and responds to balance enquires becomes vulnerable to front-running attacks. An Aggregator could, in theory, execute a transaction from an account they control, then execute a user transaction, then execute another transaction from a controlled account, and be able to learn something.

This process is much more complicated and expensive than traditional public front-running and MEV, but it does not solve the problem completely.

Obscuro introduces a slight delay to make this attack impractical for the aggregators but still preserve the same user experience.  The TEE will emit events and respond to balance requests only after proof that the rollup was successfully published in an L1 block. This mechanism will prevent an aggregator from probing for information while creating a rollup.

An aggregator wishing to attack this scheme would have to quickly create valid Ethereum blocks while executing user transactions, which is highly impractical since there is a hardcoded minimum value for the mining difficulty.

## Threats to the POBI Protocol
The POBI protocol handles most failure scenarios using a set of incentive rules.

#### 1. The winning sequencer does not publish
The winning aggregator is incentivised to publish the rollup in order to receive the reward, which means this scenario should only occur infrequently if the aggregator crashes or malfunctions. If it happens, it will only be detected by the other aggregators when the next L1 block does not contain the winning rollup that was gossiped about.

In this situation, every aggregator will:

* Discard the current rollup.
* Unseal the previous rollup.
* Add all current transactions to it.
* Then seal it using the last empty block.
* Gossip it.

In effect, this means that the previous round is replayed. The winning aggregator of this new round has priority over the reward in case the previous winner is added in the same block.

#### 2. The winning sequencer adds too little gas, and the rollup sits in the mempool unconfirmed
This scenario has the same effect as the previous one is handled in the same way. If the rollup is not in the next block, the round is replayed.

Publishing with insufficient gas is, in effect, punished by the protocol because it means that on top of missing the rollup reward, the aggregator will also pay the L1 gas fee, and there is no guarantee that they will receive the reward.

## Competing L1 Blockchain Forks
In theory, different L2 aggregators could be connected to L1 nodes that have different views of the L1 ledger. This will be visible in the L2 network, as gossiped rollups pointing to L1 blocks from the two forks. Each aggregator will have to make a bet and continue working on the L1 fork that it considers to be legitimate, the same behavior as any L1 node.

This is depicted in [Rollup Data Structure](./rollup-data-structure.md).

If it proves that the decision an aggregator made was wrong, it has to roll back the state to a checkpoint and replay the winning rollups.

## Trust Model
The analysis in this section is based on a [framework](https://vitalik.ca/general/2020/08/20/trust.html) defined by Vitalik Buterin, the creator of Ethereum.

Obscuro is slightly different from typical blockchains or L2s because it introduces another actor into the trust model, the hardware manufacturer.

These are the questions that will be answered using the terminology from the framework.

1. How many people do you need to behave as you expect? Out of how many?
2. What kinds of motivations are needed for those people to behave? Do they need to be altruistic, or just profit seeking? Do they need to be uncoordinated?
3. How badly will the system fail if the assumptions are violated?

### Actors
The following groups are actors in the system.
1. The Obscuro network may contain a few thousand nodes, from which a minority core set will be _Aggregators_, and the rest _Verifiers_. The governance body can control this number by setting some parameters. 
2. Another important group in this is the token holders, who have governance powers. 
3. The supported hardware TEE manufacturers.
4. The auditors.

### Notation
1. Obscuro_N - number of Obscuro nodes ~ 1000 
2. Ethereum_N - number of Ethereum nodes 
3. TEE_Manufacturer_N - number of manufacturers. Small number, but composed of large reputable companies. 
4. Token_Holders_N - number of Obscuro token holders. Many thousands

### Liveness
There are multiple aspects to consider when analysing the liveness trust model. Since Obscuro is fully decentralised at the network level, as long as one single aggregator is alive, the network is alive and processing user transactions.

For transaction processing: 1 of Obscuro_N, where the motivation of nodes is profit seeking.

For processing withdrawals, and thus reaching finality the analysis is more complex. Since withdrawals are processed automatically from the instructions found in the rollups, the trust model for the liveness of this feature is the model for the safety.

### Safety
The safety of Obscuro is based on a couple of layers, which transform a safety attack into a liveness attack.

Note that the safety of the ledger is at risk only if there are hacks in the confidential hardware technology.

Given that hardware manufacturers are generally large and reputable companies, they act as the first barrier. Their motivation is ultimately profit seeking, because vulnerabilities in the hardware they create will lead to lower sales and reputational damage.

Hardware layer: 1 of TEE_Manufacturer_N, where the motivation is profit seeking. Note that this assumes that the hardware manufacturer introduces a bug in the TEE implementation to attack the ledger. Normally the threat is lower since a single user with a valid TEE by any manufacturer will be able to stop an attack.

If there is a successful attack against the TEE, the next defense is a single active L2 node that publishes a valid rollup.
1 of Obscuro_N, where the motivation of nodes is profit seeking.

The next line of defense are the token holders, who will vote on L1 to update the Attestation Constraints, to fix the vulnerability. They are invested in the community, because they hold the token, which means they profit if it functions correctly: Token_Holders_N/2 of Token_Holders_N, where motivation is profit seeking

Note that the attacker is not directly profit seeking, because there is no possibility to withdraw assets until the fork is resolved.
