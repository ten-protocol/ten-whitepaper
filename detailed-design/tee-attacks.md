## TEE Attacks
The TEE technology and the program inside are not considered easily hackable, so the primary concern for the system is to ensure high availability.
Attacks on TEEs have occurred in laboratories, so a secondary but essential concern is to prevent ultra-sophisticated actors with the ability to hack this technology from stealing funds or breaking the integrity of the ledger.
From a high level, the solution uses an optimistic mechanism to handle such a case and penalise the culprits, rather than introduce real time delays or checks to prevent it.

There are two types of attacks that someone can execute against Obscuro:

1. Read-level hacks happen when the attacker is able to extract some information from the TEE. The only way to defend against these attacks is to perform a careful audit of the code, and to keep the _Attestation constraints_ up to date. An attacker that is careful not to reveal her advantage can remain undetected.

2. Write-level hacks are powerful since they enable the attacker to _write_ to the ledger and thus be able to break its integrity. A write-level hack could happen if an attacker is able to extract the enclave key and sign a hand-crafted rollup which contains an invalid withdraw instruction. This is the type of attack which is viewed as the main threat for the protocol and thus handled explicitly.