# 지비유데이터링크스 프로젝트
해당 프로젝트는  (주)지비유데이터링크스에서 사용자들이 함께 참여하는 인공지능 서비스를 기획 중 시스템의 지속적 운영 및 발전을 위해서는 사용자들에게 보상을 지급할 수 있는 방안의 필요성을 느꼈고
이에 대한 보상을 주는 방식을 GBU Point, GBU Token으로 나누어 관리자 관점에서 보상을 주는 방식(포인트를 주는)과 사용자 관점에서 보상을 받는 방식(포인트를 요청하는)으로 기획하여 프로토타입을 개발 하였다.


## <프로토타입 구현내용>		
해당 프로토타입의 스마트 컨트랙트는 Solidity로 작성되었으며 ERC-20 표준을 준수하여 GBU Point.sol, GBU Token.sol 두개의 파일을 작성하였고 Remix IDE에서 컴파일 및 테스트를 하고 Sepolia Testnet에서 배포를 하였다.
Server는 Web 폴더파일들을 vscode 프로그램에서 Live Server (Five Server)라는 확장 프로그램을 사용하여 웹페이지 서버 역할을 하였다.
Web폴더에 안에 있는 user.html 파일은 사용자의 웹페이지 파일로 사용자들이 각자 자신의 포인트를 관리자에게 요청하여 받을 수 있고 이 포인트를 모아서(토큰=포인트X10개) 토큰으로 전환할 수 있다.  
admin.html 파일은 관리자의 웹페이지 파일로 관리자가 사용자의 포인트 요청을 확인하여 포이트를 발급해 줄 수 있고 모든 사용자들의 포인트와 토큰을 관리한다.


## <실행방법>
1. 본 시스템은 메타마스크(Metamask)를 이용하여 접근하기 때문에 메타마스크를 다운 받아야한다. (https://metamask.io/download/)
2. Remix IDE에서 메타마스크 계정을 이용하여 제일 먼저 GBU Token.sol 파일을 컴파일 및 배포를 하고 그다음 해당 스마트 컨트랙트 주소를 이용해서 GBU Point.sol 파일을 컴파일 및 배포한다. (https://remix.ethereum.org/)
3. Web/js/abi.js경로에 가서 contractAddress_ETH_Sepolia 변수에 배포한 스마트컨트랙트 주소(GBU Point.sol)를 입력한다.
4. 이제 서버를 이용해서 사용자는 user.html 웹페이지를 이용하고 관리자는 admin.html 웹페이지를 이용하면 된다. (본 프로토타입에서는 Live Server (Five Server)사용)


## <보안 검사>
본 스마트 컨트랙트에 보안 취약점을 찾아내고 해결하기 위해서 Remix-IDE(Solidity Static Analysis Plugin)과 Slither 보안 툴을 사용해서 Solidity코드를 보다 안전하게 수정 및 개선했다.


## <구성도>

  <img width="80%" src="https://github.com/h3136514/Blockchain-incentive-islab/assets/125268228/e26fb54f-d7d4-4550-b18e-edf2175ca5c4" />

## <흐름도>

<img width="80%" src="https://github.com/h3136514/Blockchain-incentive-islab/assets/125268228/4eb44cdd-4793-4b07-b76c-e8a75ee118b3" />

## <스마트 컨트랙트 클래스다이어그램>
<img width="80%" src="https://github.com/h3136514/Blockchain-incentive-islab/assets/125268228/69db59d9-260f-4c27-b90d-ab5412bc95bc" />
<img width="80%" src="https://github.com/h3136514/Blockchain-incentive-islab/assets/125268228/7187869c-bf42-4f3e-bed0-863d91b68a0a" />

