## TEE Attacks
The TEE technology and the program inside are not considered easily hackable, so the primary concern for the system is to ensure high availability.
Attacks on TEEs have occurred in laboratories, so a secondary but essential concern is to prevent ultra-sophisticated actors with the ability to hack this technology from stealing funds or breaking the integrity of the ledger.
From a high level, the solution uses an optimistic mechanism to handle such a case and penalise the culprits rather than introduce real-time delays or checks to prevent it.

There are two types of attacks that someone can execute against TEN:

1. Read-level hacks happen when the attacker can extract some information from the TEE. The only way to defend against these attacks is to carefully audit the code and keep the _Attestation Constraints_ up to date. An attacker that is careful not to reveal their advantage can remain undetected.

2. Write-level hacks are powerful since they enable the attacker to _write_ to the ledger and thus be able to break its integrity. For example, a write-level hack could happen if an attacker can extract the enclave key and sign a hand-crafted rollup containing an invalid withdrawal instruction. This type of attack is viewed as the main threat to the protocol and thus handled explicitly.
