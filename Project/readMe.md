
# MoaPet JSP Web Project

## 🐾 프로젝트 개요
**MoaPet**은 반려동물 상품 쇼핑과 커뮤니티 기능을 결합한 JSP 기반 웹 애플리케이션입니다.  
회원은 다양한 반려동물 관련 상품을 검색하고 장바구니에 담아 구매할 수 있으며, 게시판을 통해 정보 공유 및 커뮤니티 활동도 가능합니다.

---

## 🧰 기술 스택
- **Backend**: Java Servlet, JSP, JDBC
- **Frontend**: HTML5, CSS3, JSTL
- **Database**: MariaDB
- **IDE**: Eclipse
- **패턴**: MVC, DAO/DTO 구조

---

## 🔑 주요 기능

### 🛒 쇼핑몰 기능
- **상품 목록 (productList.jsp)**: 카테고리/검색/페이지네이션 포함
- **상품 상세 (productDetail.jsp)**: 상세 정보, 수량 조절, 장바구니 담기
- **장바구니 (cartList.jsp, cartCount.jsp)**: 수량 조절, 전체 보기

### 👤 회원 기능
- **회원가입 (register.jsp, registerCheck.jsp)**: 중복 이메일 확인 포함
- **로그인/로그아웃 (login.jsp)**: 세션 기반 로그인 처리
- **마이페이지 (mypage.jsp)**: 내 게시글, 내 댓글 확인 가능

### 📋 커뮤니티 게시판
- **게시판 목록/상세/작성 (boardList.jsp, boardDetail.jsp, boardWrite.jsp)**: CRUD 가능
- **댓글 기능**: 각 게시글에 댓글 작성/조회 가능
- **파일 첨부**: 게시글에 이미지 파일 등 업로드 가능

### 📦 공통 구성
- **공통 헤더/푸터 (header.jsp / footer.jsp)**: 사이트 전체 공통 UI 구성
- **에러 페이지 (error.jsp / error404.jsp)**: 404 및 기타 예외 처리
- **메인 페이지 (index.jsp)**: 게시판 및 상품 최신 콘텐츠 하이라이트

---

## 🗂 주요 파일 구성

| 분류 | 경로 | 설명 |
|------|------|------|
| JSP View | `/views/` | 화면 표시용 JSP |
| CSS | `/css/` | 공통 및 개별 페이지 스타일 시트 |
| DAO | `/dao/` | 데이터베이스 접근 객체 |
| DTO | `/dto/` | 데이터 전송 객체 |
| Service | `/service/` | 비즈니스 로직 처리 |
| Util | `DBUtil.java` | DB 연결 유틸리티 |

---

## 👥 팀 정보
- 팀명: **강허김**
- 팀원: 강민우, 허윤, 김건엽

---
