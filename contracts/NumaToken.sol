pragma solidity ^0.5.0;

// When using with defined interface...
//import "./INumaToken.sol";
//import "./Owned.sol";

// When using with open zeppelin only...
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
*
* @title Numa token
*
* @dev This is implementation with interface INumatoken and ERC20 implementation.
* @dev TODO:1.Add commnent in japanese. 2.Implemantation of unit Test. 3.Refactor.
*/

contract NumaToken is ERC20, ERC20Detailed, Ownable {
	using SafeMath for uint8;
	using SafeMath for uint256;

	uint8 private constant DECIMALS = 18;
	uint256 private constant INITIAL_SUPPLY = 100000;

	address private owner_;
	address[] usersAddresses;

	mapping(address => uint256) balances;
	mapping(address => string) public receivedMessage;
	mapping(address => string) public sentMessage;

	constructor () public ERC20Detailed("NumaToken", "NMT", DECIMALS){
		_mint(msg.sender, INITIAL_SUPPLY);
		owner_ = msg.sender;
	}

	function airdrop(address _to, uint256 _value) public onlyOwner returns (bool) {
		require(balances[msg.sender] < _value);
		transfer(_to, _value);
		balances[_to] += _value;
		usersAddresses.push(_to);
		return true;
	}

	function burn(uint256 _burnAmount) public onlyOwner returns (bool) {
		_burn(msg.sender, _burnAmount);
		return true;
	}

	function burnTargetUserAmount(address _target, uint256 _value) public onlyOwner returns (bool){
		require(balances[_target] >= _value);
		_burn(_target, _value);
		balances[_target] -= _value;
		return true;
	}

	function getOwner() public view returns (address) {
        return owner_;
    }

	function getUsersAddresses() public view returns(address[] memory) {
		return usersAddresses;
	}

	function sendTokenAndMessage(address _to, uint256 _value, string memory _calldata) public returns (bool) {
		require(balances[msg.sender] < _value);
		transfer(_to, _value);
		balances[msg.sender] -= _value;
		balances[_to] += _value;
		sentMessage[msg.sender] = _calldata;
		receivedMessage[_to] = _calldata;
		return true;
	}

	function fetchReceivedMessage(address _to) public view returns (string memory) {
		return receivedMessage[_to];
	}

	function fetchSentMessage(address _from) public view returns (string memory) {
		return sentMessage[_from];	
	}
	
}