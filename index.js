'use strict';

const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));

const abiSource =require('./build/contracts/NumaToken');
const abi = abiSource.abi;
const contractAddress = "0xC013640a376fe14f83e14B8fCD3257b671d07A3c"; 

const numaToken = web3.eth.contract(abi);
const instance = numaToken.at(contractAddress);

const res = instance.getOwner()
console.log(res);


/*
const transferAddress = '0xE45AC256bF25a9f0F0000a4a0b524FF00457a8aE';
//const transferAddress = '6f99811cb867519dfc25bce74d8a275e847e0325';
const airdropTokenAmount = 10;
//let ownerAddress;

let airdropResult;
//let numaTokenDeployed;
try{
	//airdropResult = numaToken.methods
    //airdropResult = numaToken.methods.airdrop(transferAddress, airdropTokenAmount);
    airdropResult = instance.airdrop(transferAddress, airdropTokenAmount);
    //if(airdropResult == true) console.log("succeeded");
    //else console.log(airdropResult);
    console.log(airdropResult);
}catch(error){
    console.log(error);
}
*/