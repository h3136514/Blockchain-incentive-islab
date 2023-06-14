// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GBUToken is ERC20 {
    string private Name = "GBU";
    string private Symbol = "Token";
    uint private TokenTotalSupply = 0;
    address public admin;
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

    // 관리자의 토큰 잔액 조회
    function Token_Balance_Of_Admin() public view returns (uint256) {
        return balanceOf(admin);
    }


    // 토큰 전송 메소드 
    function GBU_Token_Transfer(address _to, uint256 _amount) public virtual returns (bool) {
        _transfer(admin, _to, _amount);
        token_balances[admin] -= _amount;
        token_balances[_to] += _amount;
        return true;
    }

 
}
