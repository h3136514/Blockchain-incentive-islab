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
}