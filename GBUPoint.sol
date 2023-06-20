// SPDX-License-Identifier: GPL-3.0
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
pragma solidity >= 0.7.0 < 0.9.0;
import "./GBUToken.sol";

contract GBUPoint is ERC20 {
   
    string private pointName = "GBU";
    string private pointSymbol = "Point";
    uint private pointTotalSupply = 0;

    ERC20 instance= new ERC20(pointName,pointSymbol);

    mapping (address => uint) private balances; 

 
    //포인트 이름
    function PointName() public view returns (string memory) {

        return pointName;
    }
    //포인트 Symbol
    function PointSymbol () public view returns (string memory) {

        return pointSymbol ;
    }
    //포인트 초기화   
    function clearPoint(address _addr) public onlyAdmin {

        balances[_addr]=0;

    }

    mapping (address => uint) private point_balances; 
    

    //관리자만 실행할 수 있음 
    modifier onlyAdmin {
        require(msg.sender == admin, "Only admin can call this function.");
        _;
    }

  
    constructor (address _GBUTokenAddress, uint _totalSupply) ERC20 (pointName, pointSymbol) {
        tokenAddress = _GBUTokenAddress;
        token = GBUToken(tokenAddress);
        pointTotalSupply = _totalSupply; // 발행된 포인트 총 합계 
        _mint(msg.sender, _totalSupply); //totalSupply 초기화
        point_balances[msg.sender] = _totalSupply; //관리자의 포인트 잔액   
        admin = msg.sender; //관리자 지정 
    }

   

    
    //관리자 권한으로 GBU Point 발행 기능 
    function mint(address _addr, uint256 _amount) public onlyAdmin {
        //require(_addr != address(0), "Invalid address");
        //require(_amount > 0, "Invalid amount");

        _mint(_addr, _amount);
        pointTotalSupply += _amount;
        point_balances[admin] += _amount;

       emit Transfer(address(0), _addr, _amount);
   }


    //decimals 수정함.
    function decimals() public pure override returns (uint8) {
        return 0;
    }


    //GBU Point 적립 기능 
}
