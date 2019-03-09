# イーサリアムとの接続について

## 概要
タイトル: 
	- トークン操作モジュール作成草案?

作成日: 
	- 3/5

作成者: 
	- shunMB

バージョン: 
	- v0.0.1

タイトルの説明と目的:
	- NumaTokenスマートコントラクトを操作するjavascriptモジュール作成のために必要な知識/手順をまとめる。
	- ropstenやmainnetにデプロイにされたethereumインスタンス上の関数をトランザクションとして動かすことでブロックチェーンにトランザクション内容を保存し、それを再利用可能な状態にする。

作成にあたって考慮したこと:
	- 実際の実装手段がイメージできること。
	- 必要な知識/ツールを適宜共有可能にすること。
	- 低コストで実装できること。
	- 完璧でないこと。柔軟な更新を前提に。

もくじ: 
	- 0. 語句の説明
	- 1. ユースケース
	- 2. 関連する関数
	- 3. 外部からインスタンスに接続するには
	- 4. 外部からインスタンスの状況を確認するには
	- 5. 外部からNumaTokenコントラクトで定義した関数を実行するには
	- 6. モジュール化するためのそれぞれの処理の手順

その他:
	- 開発はまずローカルにdevelopment networkを立ち上げ、ganaacheを使いながらやるとベター。ropstenで行えるようになったときにはfaucetからropsten ethを十分保持してから行う。

## 0. 語句
Nan


## 1. ユースケース
NumaPayコンテキストマップv0.1.8/アーキテクチャーv0.1.0/API設計v0.0.1で暫定のユースケースのうちブロックチェーンでの処理が必要なものは以下:
1. 登録  
2. メッセージ付きユーザー間トランザクション  
3. 期初処理  
4. 期末処理  


## 2. 関連する関数
実際に行うことの簡潔な説明(後述する関数の内容を含みます): 
1. 登録: 
	- airdrop()
	- adminから登録したユーザーへのairdrop()  
2. メッセージ付きユーザー間トランザクション:
	- sendTokenAndAirdrop()
	- ユーザーアカウントアドレスをmsg.senderとしたsendTokenAndAirdrop()  
3. 期初処理: 
	- airdrop()
	- adminからのairdrop()  
4. 期末処理: 
	- burnTargetUserAmount()
	- 期間あたりに一番トークンを獲得したユーザーからTokenをsubする。  


## 3. 外部からインスタンスに接続するには
イーサリアムはjson rpcを受け入れる構造。そのため、なんらかのEthereumクライアントからjson rpc apiを使用して外部のノード(サーバー)に接続する。
このとき、
・infura.ioのjson rcp apiを使用する方法
・web3.jsなどのjavascript apiを使用する方法
で接続し、インスタンス(デプロイされたコントラクト)を操作することが主流。
今回はjsとNode.jsを使用することを考え、web3.jsで接続する方法でおこないます！

### Node.jsでWeb3からコントラクトを呼び出す
以下の方法で定数web3を定義しインスタンス化する。(定数でも変数でもどちらでも可能)
```
> const Web3 = require('web3');
// development環境で行う場合
> const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
// ropsten環境で行う場合
> const web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io/[infura_api_key_here]"));
```


## 4. 外部からインスタンスの状況を確認するには
詳しくは[web3のドキュメント](https://web3js.readthedocs.io/en/1.0/)より。
基本的なメソッドだけここで紹介します！

### 情報取得系処理
情報の取得はガス代がかからないこと、データがオープンなことから簡単にできる。

・アカウント情報取得
ここでaccounts[0]はコントラクトをデプロイしたアドレス(= ownerのアドレス)
```
> const accounts = web3.eth.getAccounts((error, result) => {
	console.log(result)
});

[ '0x5c51092532947f1bc18c847ee6274e56b05eaa7d',
	...
  '0xc4f7d0b688012cf8c5ad16e5476c88b2942e1f24' ]
```

・ブロック情報取得
```
> const 1400thBlock = web3.eth.getBlock(1400, (error, result) => {
    console.log(result);
});

{ number: 1400,
  hash:
   '0x84c0defc15504b14de97c6ebe86780bab8398c79e4ce7d9965b57b1182b17283',
  parentHash:
   '0x287bb5f9193c55cbc6a80a173c1fa2a655c93cead354422f825b0aa0c9fd89ec',
  mixHash:
   '0x0000000000000000000000000000000000000000000000000000000000000000',
  nonce: '0x0000000000000000',
  sha3Uncles:
   '0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347',
  logsBloom:
   '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
  transactionsRoot:
   '0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421',
  stateRoot:
   '0x7e026568b1cf1937b08d2f67a042c7f58c154d240e1859b5ce13fb6b8a389911',
  receiptsRoot:
   '0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421',
  miner: '0x0000000000000000000000000000000000000000',
  difficulty: BigNumber { s: 1, e: 0, c: [ 0 ] },
  totalDifficulty: BigNumber { s: 1, e: 0, c: [ 0 ] },
  extraData: '0x',
  size: 1000,
  gasLimit: 6721975,
  gasUsed: 1269199,
  timestamp: 1551690833,
  transactions:
   [ '0xff128190fc87d5b266e9a58951179adeb818dcae1eb0285720163132f06f344f' ],
  uncles: [] }
```

・残高情報取得
```
> const userBalance = web3.eth.getBalance('0xdc373f368024b5d0332436c4ce76f318bf96ddbb', (error, result) => {
    console.log(result);
});

BigNumber { s: 1, e: 19, c: [ 592974, 55580000000000 ] }
```

### 送金系
送金処理ではsendTransactionを行う前にユーザーアカウントのアンロックを行う必要がある。
_ただしganacheの場合はデフォルトですべてのアカウントがunlock済みなので必要なし。_

・アカウントのアンロック
```
> web3.personal.unlockAccount('0x294efe048a5b9f2d09da0c6dbce9924a325009c8', < Password >, < Unlock duration time >);

true
```

・送金処理
```
> var _sendTransaction = web3.eth.sendTransaction({from: "0xdc373f368024b5d0332436c4ce76f318bf96ddbb", to: "0xb412662ddcd7adc0bb6ccd5ab79e23fe5f7e021b", value: 1000000000000000000});	// valueのデフォルトはwei値
> console.log(_sendTransaction)
0x5dbe313130cc61f4e230323f374b4f4c97240b71a5341b7602e752ef5280e7f0	// tx hash
```


## 5. 外部からNumaTokenコントラクトで定義した関数を実行するには
ethでない自作のコントラクトメソッドの呼び出しについて、詳しくは[Ethereumのドキュメント Create Methods](https://github.com/ethereum/wiki/wiki/JavaScript-API#contract-methods)より。

例: airdropを使ってユーザーに実際にairdropしようとする
```
const contract = web3.eth.contract(< contract ABI >);
const contractInstance = contract.at(< contract address >);
const to = " address ";
const val = < value in wei >;

const transactionObject = {
  from: fromAccount,
  gas: gasLimit
  gasPrice: gasPriceInWei
};

// このように明示的に関数後にsendTransactionと書くことが多い
contractInstance.airdrop.sendTransaction(to, val, transactionObject, (error, result) => { // do something with error checking/result here });

```


## 6. モジュール化するためのそれぞれの処理の手順
それぞれの項について以下の手順を満たすことが求められる(暫定&想定):

・共通:
```
0. web3の初期化 with プロバイダ情報
```

・登録:
```
1. adminとしてアカウントをアンロック(admoin = accounts[0] = owner)
2. adminの送金額がDBに保持されているadmin残額よりも大きいかvalidation
	_実際にはこの作業はコントラクトメソッドにおいても同じ require(balances[msg.sender] >= _value); によって検証される。しかし、requireの要件を満たせずrevertした際にも関数のロールバックは行われるが、ガス代がその時点まで消費されるため事前の検証が必要になる。つまりはrevertしたときのガス代を防ぐという意味で必要。_
3. adminアカウントによる airdrop(to, val) の実行
4. 成功フラグであれば以降の処理(DB格納など) →ここで実行中のラムダに戻る
```

・メッセージ付きユーザー間トランザクション:
```
1. ユーザーA(送金側)としてアカウントをアンロック
2. ユーザーAの送金額がDBに格納されているユーザーA残高よりも大きいかvalidation
3. messageが大きすぎないかvalidation(32byteごとにガス代がかかるため、文字数の制限が必要) 
4. ユーザーAアカウントによる sendTokenAndMessage(to, val, message) の実行
5. 成功フラグであれば以降の処理 →ここで実行中のラムダに戻る
```

・期初処理
```
登録と同じ
```

・期末処理 3/9更新
更新前(deprecated)
```
1. adminとしてアカウントをアンロック
2. バーン対象ユーザーの残高がバーン額と同じかそれよりも大きいことをvalidation
3. adminアカウントによる burnTargetUserAmount(target, val) の実行
4. 成功フラグであれば以降の処理 →ここで実行中のラムダに戻る
```
更新後
```
1. ユーザーA(送金側)としてアカウントをロック
2. ユーザーAの送金額がDBに格納されているユーザーA残高よりも大きいかvalidation
3. ユーザーAアカウントによる sendTokenToOwner(val) の実行
4. 成功フラグであれば以降の処理 →ここで実行中のラムダに戻る 
```




