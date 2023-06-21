// SPDX-License-Identifier: GPL-3.0
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
pragma solidity >= 0.7.0 < 0.9.0;
import "./GBUToken.sol";

contract GBUPoint is ERC20 {
   
    string private pointName = "GBU";
    string private pointSymbol = "Point";
    uint private pointTotalSupply;
    address public admin; //관리자 변수 
    address public tokenAddress; //토큰 컨트렉트 주소 
    GBUToken public token;
    address public user = 0xf8990788E46b5411281Ac51d6cb8E32F732d8DB0; // 사용자 변수 

    address[] public useraddress;  //사용자 지갑 주소들(포인트 받은 사용자)
    
    //사용자 정보 저장(지갑주소, 포인트)
    struct UserData {
        address user;
        uint get_point;
    }

    // 사용자의 요청 정보를 저장하기 위한 구조체
    struct Request {
    address requester;
    bool approved;
    }

    //Request 구조체를 사용하여 요청 정보를 저장하기 위한 매핑 
    mapping(uint256 => Request) public requests;
    uint256 public requestId;
    
    
  //모든 포인트 확인(관리자 전용)
    function getPoints_admin() view public returns (UserData[] memory) {
        uint256 balanceLength =useraddress.length;    //유저 수  가져오기
        //require(balanceLength != 0, "Owner did not have token.");   //토큰을 하나도 안가지고 있을때

        UserData[] memory userData = new UserData[](balanceLength);

        //가지고 있는 토큰만큼 반복
        for(uint256 i = 0; i < balanceLength; i++) {
            address user =useraddress[i];
            uint get_point= point_balances[user];
    
            userData[i] = UserData(user,  get_point);
        }

        return userData;

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
 
  ////////////////////////////////////////////////////////////////////////////////////////////
  // [ 포인트 요청 기능 ] 

    // 사용자의 포인트 요청 기록 구조체 
    struct Record_User_Point_Request {
        uint index; // 인덱스
        address point_requester; // 주소
        bool status; // 요청 상태 
        
    }

    Record_User_Point_Request[] public pointRequests;
    uint public pointRequestCount = 0;

    // 사용자는 포인트 요청하기 페이지에서 사용자의 지갑 주소를 입력하면 된다 --> 요청 완료  
    function pointRequest(address _addr) public returns (address){ 
       
        Record_User_Point_Request memory request;
        request.index = pointRequestCount;
        request.point_requester = _addr;
        request.status = false;
        pointRequests.push(request);
        pointRequestCount++;

        return _addr;
    }



    // 사용자 포인트 요청 확인용 
    function getPointRequest(uint index) public view returns (uint256, address, bool){
    return (pointRequests[index].index, pointRequests[index].point_requester, pointRequests[index].status);
}

   // getPointRequestCount()
    function getpointRequestCount() public view returns (uint256){
        return pointRequestCount;
    }

////////////////////////////////////////////////////////////////////////////////////////////


    // 포인트 요청자 정보 확인하는 기능 
   function getRequestInfo(uint256 _requestId) public view returns (Request memory) {
    require(_requestId < requestId, "Invalid requestId"); // 요청 ID 유효성 검사

    return requests[_requestId];
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
    어느정도 모이면 토큰으로 전환할 수 있다. (1Point => Point * 10 Token)*/

   ////////////////////////////////////////////////////////////////////////////////////////////
   // [ 포인트 -> 토큰 전환 ] 

    uint256 public HowMuchToken;
    uint256 public getResult;


    // 사용자의 포인트 요청 기록 구조체 
    struct Record_User_Token_Exchange {
        uint t_index; // 인덱스
        uint t_howmuch; // 전환된 토큰양
    }

     Record_User_Token_Exchange[] public tokenExchanges;
     uint public tokenExchangeCount = 0;


    function exchangePointsForTokens(uint256 _amount) public {
    

        // 포인트 * 10 환율
        HowMuchToken = _amount * 10; // 계산까지는 잘 됨 (해결)
        getResult = HowMuchToken;


        Record_User_Token_Exchange memory exchange;
        exchange.t_index = tokenExchangeCount;
        exchange.t_howmuch = getResult;
        tokenExchanges.push(exchange);
        tokenExchangeCount++;

        // 계산된 토큰 양 만큼 전송 토큰 balances로 전송 !
        token.GBU_Token_Transfer(user, HowMuchToken);

        _burn(user, _amount);
    
    }
   

   function getHowMuchToken() public view returns(uint256) {
       return getResult;
   }


    // 사용자 포인트 요청 확인용 
    function getTokenExchange(uint index) public view returns (uint256, uint256){
    return (tokenExchanges[index].t_index, tokenExchanges[index].t_howmuch);
    }



   // tokenExchangeCount()
    function getTokenExchangeCount() public view returns (uint256){
        return tokenExchangeCount;
    }

   ////////////////////////////////////////////////////////////////////////////////////////////
   // [ 포인트 , 토큰 잔액 조회 ] 

   // 관리자의 포인트 잔액 조회
    function Point_Balance_Of_Admin() public view returns (uint256) {
        return balanceOf(admin);
    }



    // 사용자의 포인트 잔액 조회 
    function Point_Balance_Of_User() public view returns (uint256) {
        return balanceOf(user);
    }


   // 관리자의 토큰 잔액 조회
    function Token_Balance_Of_Admin() public view returns (uint256) {
    return token.balanceOf(admin);
    }


    
   // 사용자의 토큰 잔액 조회
    function Token_Balance_Of_User() public view returns (uint256) {
        return token.balanceOf(user);
    }



}