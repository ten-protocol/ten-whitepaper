## Cryptography

This section will cover the various cryptographic techniques used by Obscuro.

### Master Seed
CPU manufacturers provision every TEE with one or multiple keys, the _Enclave Key_ (EK). These keys are used for digitally signing messages and identifying a TEE. They are also used for encrypting data that only that particular hardware TEE can decrypt. To achieve the goals of a collaborative, decentralized network like Obscuro, all the TEEs have to work on the same set of transactions, which means they must all decrypt them.

The first enclave, called the _Genesis Enclave_, generates a 256bit random byte array called the _Master Seed_ inside the encrypted memory space. It encrypts this seed with the _EK_ and sends it to the management contract to be stored there, as well as storing it locally on the host server.

### Sharing the Master Seed
After proving their attestation, subsequent nodes will receive that secret _Master Seed_ encrypted with their key. The medium over which they receive the data is the management contract to ensure maximum data availability.

Before obtaining the shared secret, the L2 nodes must attest that they are running a valid version of the contract execution environment on a valid CPU.

_Note: The solution assumes that attestation verification can be implemented efficiently as part of the  Management contract. This is the ideal solution since it makes the contract the root of trust for the L2 network._

The sequence for node registration is shown in the following diagram:
![node registration](./images/node-registration.png)

An L2 node invokes a method on the Management contract to submit their attestation, verifying it and saving this request. Another L2 node (which already holds the secret key inside its enclave) responds by updating this record with the shared secret encrypted using the public key of the new TEE. Whichever existing L2 node replies first, signed by the enclave to guarantee knowledge of the secret, will receive a reward.

_Note: This solves several problems; the Management contract provides a well-known central registration point on the Ethereum network, which is able to store the L2 shared secret in public with very high availability, and existing L2 nodes are compensated for their infrastructure and L1 gas costs to onboard new nodes._


### Generating Keys
The TEEs use the shared secret to generate further asymmetric and symmetric keys used by users to encrypt transactions and by the enclaves themselves to encrypt the content of the rollups.

Each enclave will use this master entropy to generate additional keys deterministically:

1. A public/private key pair will be used as the identity of the network. The public key will be published to L1 and used by clients to encrypt the signed Obscuro transactions and will be referred to as _Obscuro_Public_Key_
2. A set of symmetric keys used by the TEEs to encrypt the transactions that will be stored on the L1 blockchain.

_Note: When submitting a rollup, each enclave will sign it with the key found in their attestation (the _AK_)._

### Transaction Encryption
One of the explicit design goals of Obscuro is to help application developers achieve their privacy requirements while giving them the tooling to dis-incentivise their users from using the application for illegal behavior such as money laundering.

When deploying a contract to Obscuro, the developer has to choose one of the predefined revealing options:

* _XS_ - 12 seconds (1 block)
* _S_ - 1 hour (3600/12 = 300 blocks)
* _M_ - 1 day (24 * 3600/12 = 7200 blocks)
* _L_ - 1 month
* _XL_ - 1 year

_Note: These periods are counted in L1 blocks and are indicative._

One of these options will be chosen by default for applications that do not explicitly specify one. Based on the chosen period, transactions submitted to that application can be decrypted after that time delay.

The protocol will deterministically derive 5 symmetric encryption keys each rollup, derived from the master seed, the reveal option, the running counter for that option, and the block height, such that all TEEs in possession of the master secret will be able to calculate the same encryption key.

For example, Application _FooBar_ has a reveal setting of _M_ (1 day). Alice submits a transaction (encrypted with the _Obscuro_Public_Key_) _Tx1_ on the 1st of February and another _Tx2_ on the 2nd of February. Inside the TEE, they are decrypted and executed. When the rollup is generated, all transactions sent to applications with the same reveal option are bundled together by the Aggregator, compressed, and encrypted with the _Encryption_Key(Master_Seed, Reveal_Option, Counter, Block_Height)_. 

The transaction blob is formed by concatenating all the encrypted intervals without any delimiter to prevent the leaking of information. Separately from the transaction blob, a data structure is created containing the start (index) position of each individual option. This map is also added to the rollup after being encrypted with a separate key that is not revealed.

This is depicted in the following diagram:
![encryption options](./images/encryption-options.png)

_Note that the predefined reveal periods are preferable to each application choosing a custom period, as it simplifies computation and the number of keys that have to be managed._

### Revelation Mechanism
The mechanism described above ensures that Obscuro transactions are encrypted with different keys, which can be revealed independently.

The other piece of the puzzle is the mechanism that controls the actual reveal process. On a high level, the platform needs a reliable way to measure the time that cannot be gamed by a malicious host owner.

The L1 blocks can be used as a reliable measure of average time. The rule is that after enough blocks have been added on top of the block that includes the rollup with the encrypted transactions, any user can request the encryption key and the position of the transactions they are entitled to view from the Aggregator TEE.

There is one security measure that Obscuro adds to prevent a malicious node operator from _fast-forwarding_ time by creating an Ethereum fork and mining blocks with well-chosen timestamps such that difficulty keeps decreasing. The solution is straightforward. Obscuro TEEs fully understand the Ethereum protocol and receive all L1 blocks as part of the POBI protocol, which allows them to verify that the blocks are valid, but they cannot know if this is the canonical ethereum chain or not a malicious fork designed to fast-forward time. Obscuro hard-codes a minimum difficulty that is much lower than the average network difficulty for the last year, but it is still much higher than any single actor can achieve.


### Cryptographic algorithms

Obscuro makes the same choices as Ethereum for hashing and signing algorithms and uses the same elliptic curve. 

Communication with TEEs and the encryption algorithms are not yet defined. 

_Note: There might be a more efficient way to achieve the same high-level goals, and we are considering different other options._
