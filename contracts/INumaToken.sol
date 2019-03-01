pragma solidity >=0.4.21 <0.6.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

/**
*
* @title Numa token interface, an extension of ERC20 token standard 
* 
* @dev This is Interface for NumaToken.sol, having airdop and message send/fetch methods.
*/


contract INumaToken is ERC20 {
	function airdrop(address _to, uint256 _value) public returns(bool);
	function sendTxMessage(address _from, address _to, uint256 _value, string memory _calldata) public returns (bool);
	function fetchReceivedMessage(address _to) public view returns (string memory);
	function fetchSentMessage(address _from) public view returns (string memory);
}