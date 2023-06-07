// SPDX-License-Identifier: GPL-3.0
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
pragma solidity >= 0.7.0 < 0.9.0;
import "./GBUToken.sol";

contract GBUPoint is ERC20 {
   
    string private pointName = "GBU";
    string private pointSymbol = "Point";
    uint private pointTotalSupply;
    address public admin; //관리자 변수 
    address public tokenAddress = 0x38cB7800C3Fddb8dda074C1c650A155154924C73; //토큰 컨트렉트 주소 
    GBUToken public token;
    uint256 public HowMuchToken;
    address[] public useraddress; 
    
     struct NftData {
        address user;
        uint get_point;
    }
//모든 point확인(관리자 전용)
    function getPoints_admin() view public returns (NftData[] memory) {
        uint256 balanceLength =useraddress.length;    //유저 수  가져오기
        //require(balanceLength != 0, "Owner did not have token.");   //토큰을 하나도 안가지고 있을때

        NftData[] memory nftData = new NftData[](balanceLength);

        //가지고 있는 토큰만큼 반복
        for(uint256 i = 0; i < balanceLength; i++) {
            address user =useraddress[i];
            uint get_point= point_balances[user];
    
            nftData[i] = NftData(user,  get_point);
        }

        return nftData;

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

    //관리자 GBU Point 잔액 조회 기능 
     function balanceOfAdmin() public view returns(uint) {
        return point_balances[admin];
    }


    //사용자 GBU Point 잔액 조회 기능 
     function balanceOfUser() public view returns(uint) {
        return point_balances[msg.sender];
    }


     //GBU Point 전송 기능
      function transferPoint(address _to, uint256 _amount) public virtual  returns (bool) {
        _transfer(admin, _to, _amount);
       point_balances[admin] -= _amount;
        point_balances[_to] += _amount;
        useraddress.push( _to);
        return true;
    }

    // 사용자의 GBU Point 요청 기능
    /* 사용자가 보상을 요청 --> 필요한 정보 입력 (주소)  --> 승인/거절 (관리자 입장) --> 전송하기*/
    event RequestSubmitted(address requester);
    event RequestApproved(address requester, uint amount);
    event RequestRejected(address requester, string reason);

    enum RequestStatus { None, Requested, RequestConfirmed , RequestApproved, RequestRejected }
    RequestStatus public requestStatus; // 요청 상태
    address public requester; // 요청자의 주소
 
    // 사용자는 포인트 요청하기 페이지에서 사용자의 지갑 주소를 입력하면 된다 --> 요청 완료  
    function pointRequest(address _addr) public {
        require(_addr != address(0), "Invalid address"); // 주소 유효성 검사

        requester = _addr;
        requestStatus = RequestStatus.Requested;
    }

    // 포인트 요청자 정보 확인하는 기능 
    function getRequesterInfo() public view returns(address,RequestStatus){
        return (requester,requestStatus) ; //튜플 사용해서 반환 값 2개 이상 가능 
    }


    // 사용자 pointRequest를 관리자가 승인하거나 거절한다. 
    event RequestRejected(string message);
    bool private AdminDecision; 
    function approveRequest(uint _amount, bool _AdminDecision) public onlyAdmin {
        // 관리자만 호출 가능
        require(msg.sender == admin, "Only admin can approve requests"); 

        AdminDecision = _AdminDecision;
        
        // 관리자가 승인을 하면 (true , false 입력한다) 요청상황 : 승인 (true)  ==> 포인트를 전송한다.
        // 관리자가 승인을 거절하면 ==> 요청상황 : 거절 (false) 
    
        if (AdminDecision == false) {
            requestStatus = RequestStatus.RequestRejected;
            emit RequestRejected("Your request has been rejected by the admin.");
        } else {
            requestStatus = RequestStatus.RequestApproved;
            transferPoint(requester, _amount);
        }
       
    }
  
     
    /* 승인된 경우 사용자들은 포인트를 얻게되고 그 포인트를 모은다. 
    어느정도 모이면 토큰으로 전환할 수 있다. (100 Point => 1 Token)*/
    
    event PointsExchanged(address user, uint256 amount);

  function exchangePointsForTokens(uint256 _amount) public {
        require(point_balances[msg.sender] >= _amount, "Insufficient point balance.");
      
        // 100 Point당 1 Token 교환 비율 계산 (해결함)
        HowMuchToken = _amount / 100; 

        // 입력된 _amount 만큼 사용자의 발란스에서 차감 (해결함)
        point_balances[msg.sender] -= _amount;
   

        //계산된 HowMuchToken 만큼 사용자의 토큰 지갑에 입금
       // 토큰을 사용자에게 전송 (여기서 문제 발생 !!!) 
       
       token.TestTransfer(msg.sender, HowMuchToken);
    }


   // 관리자의 토큰 잔액 조회
    function Token_Balance_Of_Admin() public view returns (uint256) {
    return token.balanceOf(admin);
    }


    
   // 사용자의 토큰 잔액 조회
    function Token_Balance_Of_User() public view returns (uint256) {
        return token.balanceOf(msg.sender);
    }



}
