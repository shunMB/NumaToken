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
    ✓ testInitialBalanceUsingDeployedContract (41ms)
    ✓ testInitialBalanceWithNewNumaTokens (73ms)
    ✓ testOwnerCanAirdropWithUserAddress (61ms)
    ✓ testUserCanHaveTokensAfterAirdrop (60ms)
    ✓ testOwnerCanBurnTokens (48ms)
    ✓ testTokensOfOwnerAfterBurn (51ms)
    ✓ testOwnerCanBurnTokensOfTargetUserWithUserAddress (61ms)
    ✓ testTargetUserPossessionReducedAfterBurn (61ms)
    ✓ testUserCanSendTokenToOwner (53ms)
    ✓ testUserCanSendTokensAndMessageWithUserAddresses (59ms)
    ✓ testTokensOfSpenderCanBeSubstructedValueAmount (61ms)
    ✓ testTokensOfReceiverCanBeAddedValueAmount (59ms)
    ✓ testReceivedMessageWithUserID (81ms)
    ✓ testSentMessageWithUserID (71ms)
    ✓ testOwnerCanKillContract (58ms)


  15 passing (7s)

```

## See EtherScan(ropsten)
https://ropsten.etherscan.io/token/0x6F6b5721F9514061f6a89a113A9F1261718e7270
