// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GBUToken is ERC20 {
    string private Name = "GBU";
    string private Symbol = "Token";
    uint private TokenTotalSupply = 0;
    address public admin;
    //mapping (address => uint) private Tokenbalance;
    mapping (address => uint) private token_balances; 


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

    //관리자 GBU Token 잔액 조회 기능 
    function balanceOfAdmin() public view returns (uint256) {
        return balanceOf(admin);
    }

    //관리자의 토큰 잔액 조회
    function Token_Balance_Of_Admin() public view returns (uint256) {
    return balanceOf(admin);
    }

    function transferToken(address to, uint256 amount) public returns (bool) {
        require(amount > 0, "Invalid amount");
        address owner = _msgSender();
        _transfer(owner, to, amount);
        token_balances[admin] -= amount;
        token_balances[to] += amount;
        return true;
    }
}
