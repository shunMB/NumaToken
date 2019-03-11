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
You have to setup ganache in testing.
```
$ truffle test
Using network 'development'.

Compiling ./test/TestNumaToken.sol...


  TestNumaToken
    ✓ testInitialBalanceUsingDeployedContract (55ms)
    ✓ testInitialBalanceWithNewNumaTokens (77ms)
    ✓ testOwnerCanAirdropWithUserAddress (108ms)
    ✓ testUserCanHaveTokensAfterAirdrop (81ms)
    ✓ testOwnerCanBurnTokens (74ms)
    ✓ testTokensOfOwnerAfterBurn (80ms)
    ✓ testOwnerCanBurnTokensOfTargetUserWithUserAddress (88ms)
    ✓ testTargetUserPossessionReducedAfterBurn (86ms)
    ✓ testUserCanSendTokenToOwner (70ms)
    ✓ testUserCanSendTokensAndMessageWithUserAddresses (80ms)
    ✓ testTokensOfSpenderCanBeSubstructedValueAmount (111ms)
    ✓ testTokensOfReceiverCanBeAddedValueAmount (71ms)
    ✓ testReceivedMessageWithUserID (97ms)
    ✓ testSentMessageWithUserID (100ms)


  14 passing (8s)

```

## See EtherScan(ropsten)
https://ropsten.etherscan.io/token/0xD825cF552C59f9D309C4f04Fa4c6f84e052f4421
