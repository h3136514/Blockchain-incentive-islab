// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract GBUPoint {
    string private pointName = "GBU";
    string private pointSymbol = "Point";
    uint private pointTotalSupply;
    address public admin; //관리자 변수 

    function Get_Point_Name() public view returns (string memory){
        return pointName;
    }

     function Get_Point_Symbol() public view returns (string memory){
        return pointSymbol;
    }
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


}