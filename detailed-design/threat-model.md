## Threat Model

Obscuro is different from traditional L1 or L2 solutions mostly because data is stored and processed privately in trusted execution environments, which brings a new set of threats. There are also a few novel threats from the decentralised nature of the POBI protocol.

The main threat to any ledger technology is data corruption. It could take the form of stealing assets, double spending assets, or, more generally, adding illegal entries.
Leading blockchains solve this problem by implementing a _Byzantine Fault Tolerant_ (BFT) consensus between independent parties and creating incentives to ensure that anyone who breaks the rules will not be rewarded or will even be penalized. The most extreme attack is a 51% "Sybil" attack, where the attacker somehow gains the majority of the decision power (computing power for proof of work, or staking for proof of stake) and can rewrite the history. This attack manifests as replacing an existing valid transaction with a valid competing transaction. While the ledger remains _logically_ valid, for the beneficiary of the first transaction, this is equivalent to stealing. If the attacker tried to _physically_ corrupt the ledger, everyone would ignore the invalid block.  The best defense against this attack is to ensure that multiple independent powerful actors have no incentive to collude.

The Obscuro POBI protocol delegates this threat to the underlying L1 blockchain - Ethereum, which has good enough security properties.
The general principle of the protocol is that it reverts to the behavior of a typical non-confidential blockchain in case of hacks on the TEE technology. As a result the L1 is the source of truth for the L2 network. Any L2 node with a valid TEE in possession of the shared secret is able to download all the rollups from the L1, calculate the entire state inside its encrypted memory, and at the same time validate all transactions.
The protocol ensures that an attacker has nothing to gain and is slashed if they attempt to corrupt the ledger.
This deterrent, combined with the technical difficulty and the high cost of attacking hardware security, will ensure the correct functioning of the protocol.

The core principle of the design of Obscuro is that the integrity of the ledger, and thus the possessions of the users, are not in any way depending on trusting a hardware manufacturer. In case of a severe breach, the governance model implemented by the management contract will have to select the valid ledger and freeze it such that everyone has the chance to withdraw using balance proofs.

### Threats to TEE Technology
The TEE technology and the program inside are not considered easily hackable, so the primary concern for the system is to ensure high availability.
Attacks on TEEs have occurred in laboratories, so a secondary but essential concern is to prevent ultra-sophisticated actors with the ability to hack this technology from stealing funds or breaking the integrity of the ledger. From a high level, the solution uses an optimistic mechanism to handle such a case and penalise the culprits, rather than introduce real time delays or checks to prevent it.

It is assumed that attackers run an aggregator node on a computer with a CPU they control, and then receive the secret key and the entire ledger, and then are able to run any possible attack on it, including those on the physical CPU.

Assuming that such attacks are successful, the attacker can limit themselves to read-level access or try to corrupt the ledger using a write-level attack.

#### Read-Level Attacks
There is a spectrum of attack severity. The least severe is a side-channel where the attacker can find some information about a specific transaction. The most severe is when the attacker can extract the master secret and can read all present and future transactions.

If this attacker is discreet, the information leak can continue until a software patch is published or until new hardware that removes this attack is released.

This threat is specific to confidential blockchains. The only way to defend against these attacks is to perform a careful audit of the code, and to keep the _Attestation constraints_ up to date. If the attack is successful, the protocol reverts to the behavior of a typical public blockchain where all transactions are public, and MEV is possible.

#### Write-Level Attacks
There are a few variants of this attack.

The most severe is when the attacker impersonates a TEE and signs a rollup containing illegal transactions. If there is no withdrawal attempt in the rollup, or there are no other external side effects, this attack is equivalent to an L1 node publishing an invalid block. All the honest TEEs will ignore it. Even in this case, the protocol reverts to the behavior of a typical blockchain.

If the attacker impersonating an enclave attempts to withdraw funds from the bridge contract based on invalid transactions, this is a case that needs special consideration. This is where the L1 protocol meets the L2 protocol, and the bridge contract has to decide the validity of the withdrawal request in order to execute it. The solution is described in detail in the POBI protocol.

#### Colluding Write Level Attacks
This is an extreme attack on this protocol, where all aggregators find a way to break the TEE and are colluding to steal all funds.

The defense is to have a reasonable number of active verifiers that have a stake in the good functioning of Obscuro. "Active" means that they are watching the Obscuro ledger in real time. These actors will detect if there is a malicious head rollup and no other valid fork is being aggregated.

_Note: One such actor monitoring the network will be the Obscuro Foundation, which has the mandate to keep the protocol functioning correctly. The protocol also rewards other independent parties to take on this job by assigning a small amount each rollup to a random validator if they can prove they are active._

Any one of them will be able to become an aggregator quickly, by benefiting from the censorship resistance of Ethereum.  They will have to pay the stake, and publish a correct block. This valid fork will disable withdraws, and will trigger a governance event which will most likely lead to a code or hardware fix, and new _Attestation Constraints_.

#### Invalid Rollup Attacks
Aggregators may publish invalid or empty rollups, but the management contract will only accept aggregators that can prove their TEE attestation, and only rollups signed by the TEE key of a valid aggregator. Unless the TEE itself is corrupted, it is impossible to publish invalid rollups.

An aggregator winning a round can publish empty rollups, but that would not do much harm if there are multiple independent aggregators. It will just slow down the network. This attack is dis-incentivised since the reward for the winner will be lower.


#### Sybil attacks

This section will analyze the threats that a powerful adversary able to create a large number of aggregators can pose on the protocol.
The reasoning around this attack is quite different from typical public blockchains.

There are two reasons for such an attack:
- The attackers want to steal the funds locked in the L1 Bridge. Note that this is not a problem in typical L1 chains as there are no side effects there, but it is in L2s.
- Double spending. The attacker plans a malicious re-org of the L2 ledger. This is the typical threat for sybil attacks in L1 networks.

##### The attack

There are two ways to run this attack against Obscuro:

1. The attacker sets up N CPUs with TEE, and pays the stake for each of them. Where N > Total_Number_Of_Aggregators / 2.
2. The attacker hacks the TEE and is able to impersonate as many TEEs as they can pay stake for.

All unhacked TEEs will generate a new rollup on top of the same rollup from the last L1 block presented. Which means that as long as there is a single unhacked enclave the “real canonical chain” will continue to grow.
_Note that if a host presents invalid L1 blocks to a TEE, the rollups generated will not be accepted by the management contract._

Another relevant aspect is that publishing a rollup to the main chain costs Ethereum gas. The attacker has to keep publishing rollups, otherwise the attack fails eventually. The virtuous TEEs will keep doing their job and publish rollups knowing that they will get the rewards according to the protocol. 

As long as there are forks in the rollup-chain, withdrawals are suspended on all forks.

_Note: The reward might have to be supplemented the longer the attack lasts, as aggregators will have to pay the gas from their pocket for a while, until withdrawals are re-enabled._

###### Sybil attack without hacking the TEE

If the attacker is not able to hack the TEE, they’re not able to deviate from the canonical chain or to insert illegal transactions, as the software won’t let them. 
Having a majority on the Obscuro network will not help.

To perform a double spend, the attackers have to actually perform a double spend attack on the L1 blocks themselves that contain the rollups. 


###### Sybil attack when hacking the TEE

In this scenario, the attacker is able to hack the TEE, and they setup a large number of aggregators, limited only by the stake.  Their motivation is that they want to steal the funds from the bridge – the ultimate prize.

The attack is as follows:
1. Using a script, they handcraft invalid rollups, and publish them (by paying ethereum gas). On the L1, this would show as 2 forks. One maintained by the attacker, one maintained by the valid TEEs who just ignore the invalid rollups and keep doing their job.
2. Withdrawals are stopped until one fork wins.
3. What happens next is that the governance of Obscuro, or parties with a significant stake, will quickly come together and analyze what happened. If this is a hack in the TEE,they will let Intel know about it. If it is a hack in Obscuro, the core developers will work on the fix. 
4. Until there is a fix in place, withdrawals will be suspended. There are two options to proceed next:
   - The TEE manufacturer or the Obscuro team are able to produce a quick fix and the Attestation Constraints are updated. Which means the attack will stop as the attacker will have to upgrade to the fixed version. The malicious fork will die out and withdraws will be resumed.
   - The network enters the nuclear option. It is manually frozen on the right fork by the governance board, the keys are revealed based on this freezing decision, and everyone can claim back their amounts on the L1 based on the proof generated in L2.

    
##### Economical Sybil attacks

Another type of attack, which a well resourced actor can perform is to try and control a lot of aggregators in the hope of making a good return from the rewards. The more aggregators someone controls the more chances to get winning nonces they have.

There is no risk in altering the ledger or performing double spend attacks.
There is not even a risk of denial of service, since the cryptoeconomics encourages all actors to quickly fill in gaps in published rollups.

This type of attack could lead to centralisation, but it's unclear what effects that might have.

### Front-Running Protection
A TEE that emits events and responds to balance enquires becomes vulnerable to front-running attacks. An aggregator could in theory execute a transaction from an account they control, then execute a user transaction, then execute another transaction from a controlled account, and be able to learn something.

This is much more complicated and expensive than traditional public front-running and MEV, but it doesn't solve the problem completely.

A slight delay is introduced to make this attack impractical for the aggregators, but preserve the same user experience.  The TEE will emit events and respond to balance requests only when it received proof that a rollup was included in the L1 rollup contract. That proof is easy to obtain, and it will prevent an aggregator from probing while creating a rollup.

An aggregator wishing to attack this scheme would have to quickly publish valid Ethereum blocks while executing user transactions, which is highly impractical.

### Threats to the POBI Protocol
Failure scenarios in the POBI protocol exist and the incentive rules are designed to ensure the good functioning of the protocol.

#### 1. The winning sequencer does not publish

The winning aggregator is incentivised to publish the rollup in order to receive the reward. This scenario should only occur infrequently, if the aggregator crashes or malfunctions. In case it happens, it will only be detected by the other aggregators when the round is supposed to end, and the next rollup is ready to publish. They will notice that the winning rollup was not added to the L1 block.

In this situation, every aggregator will:

* Discard the current rollup.
* Unseal the previous rollup.
* Add all current transactions to it.
* Then seal it using the last empty block.
* Gossip it.

In effect this means that the previous round is replayed. The winning aggregator of this replayed round has priority over the reward in case the previous winner is eventually added in the same block.

#### 2. The winning sequencer adds too little gas, and the rollup just sits in the mempool unconfirmed

This scenario has the exact same effect as the previous one and can be handled in the same way. If the rollup is not in the next block, the round is replayed.

Publishing with insufficient gas is in effect punished by the protocol, because it means that on top of missing the rollup reward, the aggregator will also pay the L1 gas fee, and there is no guarantee that she will receive the reward.

### Competing L1 Blockchain Forks

In theory, different L2 aggregators could be connected to L1 nodes that have different views of the L1 ledger. This will be visible in the L2 network as rollups being gossiped that point to different L1 forked blocks. Each aggregator will have to make a bet and continue working on the L1 fork which it considers to have the best chance. This is the same behaviour as any L1 node.

This is depicted in [Rollup Data Structure](detailed-design#rollup-data-structure).

In case it proves that the decision was wrong it has to roll back the state to a checkpoint and replay the winning rollups.
