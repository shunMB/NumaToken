pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/NumaToken.sol";

/**
*
*@title Test Numa Token
*@dev TODO: This implementation is just testing whether contract is working or not for now,
*           so should have testing for exceptions for enough test coverage.
*/


contract TestNumaToken {

	function testInitialBalanceUsingDeployedContract() public {
		NumaToken nmt = NumaToken(DeployedAddresses.NumaToken());
		uint256 expected = 500000000000000000000000;
		Assert.equal(nmt.balanceOf(tx.origin), expected, "Owner must have 10000 NumaToken initially.");
	}

	function testInitialBalanceWithNewNumaTokens() public {
		NumaToken nmt = new NumaToken();
		address owner = nmt.getOwner();
		uint256 expected = 500000000000000000000000;
		Assert.equal(nmt.balanceOf(owner), expected, "Owner must have 10000 NumaToken initially.");
	}

	function testOwnerCanAirdropWithUserAddress() public {
		NumaToken nmt = new NumaToken();
		address userAddress = 0x6417803bB3310b900264E965ce803209EfF3f856;
		uint256 airdropAmount = 1000;
		bool isAirdropSucceeded = nmt.airdrop(userAddress, airdropAmount);
		Assert.equal(isAirdropSucceeded, true, "Owner must execute airdrop function.");
	}

	function testCanGetUserTokenBalance() public {
		NumaToken nmt = new NumaToken();
		address userAddress = 0x6417803bB3310b900264E965ce803209EfF3f856;
		uint256 airdropAmount = 1000;
		nmt.airdrop(userAddress, airdropAmount);
		uint256 expected = 1000;
		uint256 userBalance = nmt.getUserTokenBalance(userAddress);
		Assert.equal(userBalance, expected, "User token balance must be gotten by getUserTokenBalance function.");
	}

	function testUserCanHaveTokensAfterAirdrop() public {
		NumaToken nmt = new NumaToken();
		address userAddress = 0x5e8d476c3B3177D8fBFdAB0CdEAD828259e722f1;
		uint256 airdropAmount = 1000;
		uint256 expected = 1000;
		nmt.airdrop(userAddress, airdropAmount);
		Assert.equal(nmt.balanceOf(userAddress), expected, "User must receive Numa tokens after airdrop.");
	}

	function testOwnerCanBurnTokens() public {
		NumaToken nmt = new NumaToken();
		uint256 burnAmount = 1000;
		bool isBurnSucceeded = nmt.burn(burnAmount);
		Assert.equal(isBurnSucceeded, true, "Owner must execute burn function.");
	}

	function testTokensOfOwnerAfterBurn() public {
		NumaToken nmt = new NumaToken();
		uint256 burnAmount = 1000;
		nmt.burn(burnAmount);
		uint256 expected = 499999999999999999999000;
		address owner = nmt.getOwner();
		Assert.equal(nmt.balanceOf(owner), expected,  "Owner must burn total token amount with specified value.");
	}

	function testOwnerCanBurnTokensOfTargetUserWithUserAddress() public {
		NumaToken nmt = new NumaToken();
		address targetUser = 0x1134530ae7ff5C28368508cA2258fd1eee475811;
		uint256 airdropAmount = 1000;
		uint256 burnAmount = 100;
		nmt.airdrop(targetUser, airdropAmount);
		bool isBurnTergetUserSucceeded = nmt.burnTargetUserAmount(targetUser, burnAmount);
		Assert.equal(isBurnTergetUserSucceeded, true, "Owner must burn tokens of target user."); 
	}

	function testTargetUserPossessionReducedAfterBurn() public {
		NumaToken nmt = new NumaToken();
		address targetUser = 0xF889D382aA39D24bDCAC727634DE821595283f13;
		uint256 airdropAmount = 1000;
		uint256 burnAmount = 100;
		uint256 expected = 900;
		nmt.airdrop(targetUser, airdropAmount);
		nmt.burnTargetUserAmount(targetUser, burnAmount);
		Assert.equal(nmt.balanceOf(targetUser), expected, "Owner must execute burnTargetUserAmount function."); 	
	}

	function testUserCanSendTokenToOwner() public {
		NumaToken nmt = new NumaToken();
		uint256 sendTokenAmount = 100;
		bool isSendTokenToOwnerSucceeded = nmt.sendTokenToOwner(sendTokenAmount);
		Assert.equal(isSendTokenToOwnerSucceeded, true, "User must send tokens to owner.");
	}

	function testUserCanSendTokensAndMessageWithUserAddresses() public {
		NumaToken nmt = new NumaToken();
		address receiver = 0x3B1e875e66c84186643f06Ff43aE4CfCC9DCA324;
		uint256 sendTokenAmount = 100;
		bool isSendTokenAndMessageSucceeded = nmt.sendTokenAndMessage(receiver, sendTokenAmount, "Thanks!");
		Assert.equal(isSendTokenAndMessageSucceeded, true, "User must send tokens with message, using sendTokenAndMessage function.");
	}

	function testTokensOfSpenderCanBeSubstructedValueAmount() public {
		NumaToken nmt = new NumaToken();
		address receiver = 0x294efe048A5B9f2d09DA0c6dbCe9924a325009C8;
		uint256 sendTokenAmount = 100;
		uint256 expected = 499999999999999999999900;
		address owner = nmt.getOwner();
		nmt.sendTokenAndMessage(receiver, sendTokenAmount, "Thanks!");
		Assert.equal(nmt.balanceOf(owner), expected, "Token amount of spender must be reduced for tokens spender sent.");
	}

	function testTokensOfReceiverCanBeAddedValueAmount() public {
		NumaToken nmt = new NumaToken();
		address receiver = 0xE45AC256bF25a9f0F0000a4a0b524FF00457a8aE;
		uint256 sendTokenAmount = 100;
		uint256 expected =  100;
		nmt.sendTokenAndMessage(receiver, sendTokenAmount, "Thanks!");
		Assert.equal(nmt.balanceOf(receiver), expected, "Tokens amount of receiver must be added for tokens receiver received.");
	}

	function testReceivedMessageWithUserID() public {
		NumaToken nmt = new NumaToken();
		address receiver = 0x1134530ae7ff5C28368508cA2258fd1eee475811;
		uint256 sendTokenAmount = 100;
		string memory sendMessage = "Thanks!";
		string memory expected = "Thanks!";
		nmt.sendTokenAndMessage(receiver, sendTokenAmount, sendMessage);
		string memory receivedMesage = nmt.fetchReceivedMessage(receiver);
		Assert.equal(receivedMesage, expected, "Message spender sent must can be received with receiver address.");
	}

	function testSentMessageWithUserID() public {
		NumaToken nmt = new NumaToken();
		address receiver = 0x1134530ae7ff5C28368508cA2258fd1eee475811;
		uint256 sendTokenAmount = 100;
		string memory sendMessage = "Thanks!";
		string memory expected = "Thanks!";
		nmt.sendTokenAndMessage(receiver, sendTokenAmount, sendMessage);
		address owner = nmt.getOwner();
		string memory sentMessage = nmt.fetchSentMessage(owner);
		Assert.equal(sentMessage, expected, "Message spender sent must can be received with spender address.");
	}

    function testOwnerCanKillContract() public {
        NumaToken nmt = new NumaToken();
        address userAddress = 0x6417803bB3310b900264E965ce803209EfF3f856;    
        uint256 airdropAmount = 1000;
        uint256 expected = nmt.balanceOf(tx.origin);
        nmt.airdrop(userAddress, airdropAmount);
        nmt.kill();
        Assert.equal(nmt.balanceOf(tx.origin), expected, "Owner must kill contract with selfdestruct.");
    }
}
