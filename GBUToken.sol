// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GBUToken is ERC20 {
    string private Name = "GBU";
    string private Symbol = "Token";
    uint private TokenTotalSupply = 0;
    address public admin; //관리자 변수 
    
    mapping (address => uint) private Tokenbalance;  //토큰 양
    
    modifier onlyAdmin {
        require(msg.sender == admin, "Only admin can call this function.");
        _;
    }

    constructor (uint _totalSupply) ERC20 (Name, Symbol) {
        TokenTotalSupply = _totalSupply;
        _mint(msg.sender, _totalSupply);
        token_balances[msg.sender] = _totalSupply;
        admin = msg.sender;
    }

    function Tokenmint(address _addr, uint256 _amount) public onlyAdmin {
        _mint(_addr, _amount);
        TokenTotalSupply += _amount;
        token_balances[admin] += _amount;
        emit Transfer(address(0), _addr, _amount);
    }


    //토큰 잔액
    function balanceOfToken(address account) public view returns (uint256) {

        return Tokenbalance[account];
        }

    
    //토큰 전송
    function transferToken(address to, uint256 amount) public returns (bool) {
        require(amount > 0, "Invalid amount");
        address owner = _msgSender();
        _transfer(owner, to, amount);
        Tokenbalance[admin] -= amount;   //관리자의 토큰양 감소
        Tokenbalance[to] += amount;
        return true;
    }   


}
