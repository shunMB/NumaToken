# NumaToken
## Environment
You must use same environment, or this program will not work.
Truffle v5.0.5 (core: 5.0.5)
Solidity v0.5.0 (solc-js)
Node v10.9.0

## Compilation solidity codes and create ABI.
```
$ truffle compile
```

## Migration with truffle-config.js
### development
Comment out "development" in networks in truffle-config.js and setup ganache.
```
$ truffle migrate --network development
```
### ropsten
Comment out "ropsten" in networks in truffle-config.js and setup your mnemonic and infura access key.
```
$ truffle migrate --network ropsten
```

## Debug with truffle console
```
$ truffle console --network < your using network >
```
### examples
```
truffle(development)> const instance = await NumaToken.deployed()
truffle(development)> const accounts = await web3.eth.getAccounts()
truffle(development)> instance.airdrop(accounts[1], XXX)    //accounts[0] is contract creater address
truffle(development)> instance.balanceOf(accounts[1])
<BN: XXX>
```

## Test
```
$ truffle test
Using network 'development'.

Compiling ./contracts/NumaToken.sol...
Compiling ./test/TestNumaToken.sol...


  TestNumaToken
    ✓ testInitialBalanceUsingDeployedContract (52ms)
    ✓ testInitialBalanceWithNewNumaTokens (109ms)
    ✓ testOwnerCanAirdropWithUserAddress (102ms)
    ✓ testUserCanHaveTokensAfterAirdrop (68ms)
    ✓ testOwnerCanBurnTokens (94ms)
    ✓ testTokensOfOwnerAfterBurn (72ms)
    ✓ testOwnerCanBurnTokensOfTargetUserWithUserAddress (98ms)
    ✓ testTargetUserPossessionReducedAfterBurn (91ms)
    ✓ testUserCanSendTokensAndMessageWithUserAddresses (97ms)
    ✓ testTokensOfSpenderCanBeSubstructedValueAmount (118ms)
    ✓ testTokensOfReceiverCanBeAddedValueAmount (110ms)
    ✓ testReceivedMessageWithUserID (80ms)
    ✓ testSentMessageWithUserID (108ms)


  13 passing (8s)

```

## See EtherScan(ropsten)
https://ropsten.etherscan.io/token/0xD825cF552C59f9D309C4f04Fa4c6f84e052f4421
