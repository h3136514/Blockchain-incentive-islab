const Web3 = require("web3");
const web3Provider = new Web3.providers.HttpProvider("HTTP://127.0.0.1:7545");
const web3 = new Web3(web3Provider);

// 비동기적
const getAccounts = async () => {
  let accounts = await web3.eth.getAccounts();
  console.log(accounts);
};

//getAccounts();

const getBalance = async () => {
  let accounts = await web3.eth.getAccounts();
  let balance = await web3.eth.getBalance(accounts[0]);
  console.log(`account[0] : ${accounts[0]} balance : ${balance} `); // 백틱 ₩₩ 사용하면 변수와 문자열을 더 쉽게 출력할 수 있음
};

//getBalance();

// 100 eth == 100 * 10^18 ==> 100000000000000000000

const Send_GBU_Point = async () => {
  let accounts = await web3.eth.getAccounts();
  let balance0 = await web3.eth.getBalance(accounts[0]);
  let balance1 = await web3.eth.getBalance(accounts[1]);

  console.log(`account[0] : ${accounts[0]} balance : ${balance0} `); // 백틱 ₩₩ 사용하면 변수와 문자열을 더 쉽게 출력할 수 있음
  console.log(`account[1] : ${accounts[1]} balance : ${balance1} `); // 백틱 ₩₩ 사용하면 변수와 문자열을 더 쉽게 출력할 수 있음

  await web3.eth.sendTransaction({
    from: accounts[0],
    to: accounts[1],
    value: web3.utils.toWei("1", "ether"), // 단위 변환 기능
  });

  console.log(`account[0] : ${accounts[0]} balance : ${balance0} `); // 백틱 ₩₩ 사용하면 변수와 문자열을 더 쉽게 출력할 수 있음
  console.log(`account[1] : ${accounts[1]} balance : ${balance1} `);
};

Send_GBU_Point();
