pragma solidity ^0.5.0;

// When using with defined interface...
//import "./INumaToken.sol";
//import "./Owned.sol";

// When using with open zeppelin only...
// See node_modules/openzeppelin-solidity/~
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
* @title Numa token
* @author shunMB
* @notice オーナーによるエアドロップ、バーン、指定したユーザーのバーン、ユーザー間の送金&メッセージ送信処理
* @dev IERC20をインターフェースに持つERC20をベースとしたNumaトークンの実装
* @dev TODO: リファクタリング
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
		/**
		* @title constructor
		* @notice ERC20Detailedを用いたインスタンスの初期化とそれに伴うオーナーへのミント。
		*         また、ownerにデプロイしたアドレスを割り当てる。
		* @param "NumaToken": トークンの名前
		* @param "NMT": 銘柄コード
		* @param DECIMALS: トークンが小数点以下何桁で割れるかの情報
		*/
		_mint(msg.sender, INITIAL_SUPPLY);
		owner_ = msg.sender;
	}

	function airdrop(address _to, uint256 _value) public onlyOwner returns (bool) {
		/**
		* @title airdrop
		* @notice ユーザーへの任意の額のトークン配布
		* @param address _to: 配布するユーザーのアカウントアドレス
		* @param uint256 _value: 配布額
		* @return bool: 関数の実行成功フラグ
		*/		
		require(balances[msg.sender] >= _value);
		uint256 amountToSend = _value;
		balances[msg.sender] -= _value;
		transfer(_to, amountToSend);
		balances[_to] += _value;
		usersAddresses.push(_to);
		return true;
	}

	function burn(uint256 _burnAmount) public onlyOwner returns (bool) {
		/**
		* @title burn
		* @notice 任意の額のオーナーの持つトークン量のバーン
		* @param uint256 _burnAmount: バーンする額
		* @return bool: 関数の実行成功フラグ
		*/		
		_burn(msg.sender, _burnAmount);
		return true;
	}

	function burnTargetUserAmount(address _target, uint256 _value) public onlyOwner returns (bool) {
		/**
		* @title burnTargetUserAmount
		* @notice 任意の額のユーザーの持つトークン量のバーン
		* @param address _target: バーンする対象のユーザー
		* @param uint256 _burnAmount: バーンする額
		* @return bool: 関数の実行成功フラグ
		*/	
		require(balances[_target] >= _value);
		_burn(_target, _value);
		balances[_target] -= _value;
		return true;
	}

	function sendTokenToOwner(uint256 _value) public returns (bool) {
		/**
		* @title sendTokenToOwner
		* @notice ユーザーからオーナーにトークンを送金
		* @param uint256 _value: 送金するトークン額
		* @return bool: 関数の実行成功フラグ 
		*/
		require(balances[msg.sender] < _value);
		uint256 amountToSend = _value;
		balances[msg.sender] -= _value;
		transfer(owner_, amountToSend);
		balances[owner_] += _value;
		return true;
	}


	function getOwner() public view returns (address) {
		/**
		* @title getOwner
		* @notice オーナーのアドレスを取得
		* @return owner_ address: オーナーのアドレス値
		*/	
        return owner_;
    }

	function sendTokenAndMessage(address _to, uint256 _value, string memory _calldata) public returns (bool) {
		/**
		* @title sendTokenAndMessage
		* @notice ユーザーAがメッセージとともに任意の額をユーザーBに送金/送信する
		* @param address _to: ユーザーBのアドレス
		* @param uint256 _value: 送金するトークン額
		* @param string memory _calldata: メッセージ
		* @return bool: 関数の実行成功フラグ
		*/
		require(balances[msg.sender] < _value);
		uint256 amountToSend = _value;
		balances[msg.sender] -= _value;
		transfer(_to, amountToSend);
		balances[_to] += _value;
		sentMessage[msg.sender] = _calldata;
		receivedMessage[_to] = _calldata;
		return true;
	}

	function fetchReceivedMessage(address _to) public view returns (string memory) {
		/**
		* @title fetchReceivedMessage
		* @notice sendTokenAndMessageでトークンとメッセージを送金/送信された
		*         ユーザーBのアカウントアドレスを引数としてメッセージを取得
		* @param address _to: ユーザーBのアドレス
		* @return string memory: ユーザーAにより送信されたメッセージ
		*/
		return receivedMessage[_to];
	}

	function fetchSentMessage(address _from) public view returns (string memory) {
		/**
		* @title sendTokenAndMessage
		* @notice sendTokenAndMessageでトークンとメッセージを送金/送信された
		*         ユーザーBのアカウントアドレスを引数としてメッセージを取得		
		* @param address _from: ユーザーAのアドレス
		* @return string memory: ユーザーAにより送信されたメッセージ
		*/
		return sentMessage[_from];	
	}
}