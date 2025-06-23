-- ========================================
-- MoaPet 데이터베이스 초기화 및 설정 스크립트
-- ========================================

-- 데이터베이스 생성 및 사용자 설정
CREATE DATABASE IF NOT EXISTS moapet;
USE moapet;

-- 사용자 생성 및 권한 부여
CREATE USER IF NOT EXISTS 'moapet_admin'@'localhost' IDENTIFIED BY '1111';
CREATE USER IF NOT EXISTS 'moapet_admin'@'127.0.0.1' IDENTIFIED BY '1111';

GRANT ALL PRIVILEGES ON moapet.* TO 'moapet_admin'@'localhost';
GRANT ALL PRIVILEGES ON moapet.* TO 'moapet_admin'@'127.0.0.1';
FLUSH PRIVILEGES;

-- 기존 테이블 삭제 (초기화)
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS board_file;
DROP TABLE IF EXISTS board;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS member;

-- ========================================
-- 테이블 생성
-- ========================================

-- 회원 테이블: 사용자 정보 저장
CREATE TABLE member (
    member_id VARCHAR(100) PRIMARY KEY,        -- 이메일 주소를 ID로 사용 (로그인 ID)
    password VARCHAR(255) NOT NULL,            -- 암호화된 비밀번호
    name VARCHAR(50) NOT NULL,                 -- 사용자 이름
    phone VARCHAR(20),                         -- 전화번호
    zipcode VARCHAR(10),                       -- 우편번호
    address VARCHAR(100),                      -- 기본 주소
    detail_address VARCHAR(100),               -- 상세 주소
    status CHAR(1) DEFAULT 'A',                -- 계정 상태: 'A' = 활성, 'D' = 탈퇴
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 게시판 테이블: 입양, 돌봄, 자유게시판
CREATE TABLE board (
    id INT AUTO_INCREMENT PRIMARY KEY,
    board_type ENUM('ADOPTION', 'CARE', 'FREE') NOT NULL,  -- 입양, 돌봄, 자유게시판
    title VARCHAR(200) NOT NULL,               -- 게시글 제목
    content TEXT NOT NULL,                     -- 게시글 내용
    region VARCHAR(50),                        -- 지역 정보
    writer VARCHAR(100) NOT NULL,              -- 작성자 ID
    hit INT DEFAULT 0,                         -- 조회수
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (writer) REFERENCES member(member_id) ON DELETE CASCADE
);

-- 댓글 테이블: 게시글에 대한 댓글
CREATE TABLE comment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    board_id INT NOT NULL,                     -- 게시글 ID
    writer VARCHAR(100) NOT NULL,              -- 댓글 작성자 ID
    content TEXT NOT NULL,                     -- 댓글 내용
    parent_id INT,                             -- 대댓글용 부모 댓글 ID
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (board_id) REFERENCES board(id) ON DELETE CASCADE,
    FOREIGN KEY (writer) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES comment(id) ON DELETE CASCADE
);

-- 게시판 파일 테이블: 게시글 첨부파일
CREATE TABLE board_file (
    id INT AUTO_INCREMENT PRIMARY KEY,
    board_id INT NOT NULL,                     -- 게시글 ID
    original_name VARCHAR(255),                -- 원본 파일명
    stored_name VARCHAR(255),                  -- 저장된 파일명
    file_type VARCHAR(20),                     -- 파일 타입 (image, video, file)
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (board_id) REFERENCES board(id) ON DELETE CASCADE
);

-- 상품 테이블: 펫용품 정보
CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,                -- 상품명
    manufacturer VARCHAR(100),                 -- 제조사
    category VARCHAR(50),                      -- 카테고리 (사료, 간식, 장난감, 옷, 집)
    price INT NOT NULL,                        -- 가격
    stock INT DEFAULT 0,                       -- 재고수량
    imageUrl VARCHAR(255),                     -- 이미지 파일명
    description TEXT,                          -- 상품 설명
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ========================================
-- 인덱스 생성
-- ========================================
CREATE INDEX idx_board_type ON board(board_type);
CREATE INDEX idx_board_writer ON board(writer);
CREATE INDEX idx_comment_board_id ON comment(board_id);
CREATE INDEX idx_comment_writer ON comment(writer);
CREATE INDEX idx_board_file_board_id ON board_file(board_id);
CREATE INDEX idx_product_category ON product(category);

-- ========================================
-- 샘플 데이터 삽입
-- ========================================

-- 상품 데이터 삽입
INSERT INTO product (name, manufacturer, category, price, stock, imageUrl, description) VALUES
-- 사료 카테고리
('고급 건식 사료', '모아펫', '사료', 18000, 50, 'food01.jpproductg', '소화를 돕는 고급 원료로 만든 건식 사료입니다.'),
('프리미엄 습식 사료', '펫헬스', '사료', 22000, 30, 'food02.jpg', '기호성과 영양을 모두 잡은 습식 사료입니다.'),
('건강한 퍼피 사료', '내추럴펫', '사료', 19500, 45, 'food03.jpg', '어린 반려동물을 위한 건강한 사료입니다.'),
('알러지 케어 사료', '헬씨펫', '사료', 21000, 60, 'food04.jpg', '알러지에 민감한 반려동물을 위한 저자극 사료입니다.'),
('그레인프리 사료', '그레인제로', '사료', 23000, 40, 'food05.jpg', '곡물이 들어가지 않은 고단백 사료입니다.'),

-- 간식 카테고리
('오리 고기 간식', '더펫푸드', '간식', 6500, 100, 'snack01.jpg', '오리고기로 만든 건강한 간식입니다.'),
('닭가슴살 큐브', '츄잉펫', '간식', 5000, 120, 'snack02.jpg', '닭가슴살을 100% 사용한 고단백 간식입니다.'),
('연어 스틱 간식', '씨펫', '간식', 7500, 90, 'snack03.jpg', '연어로 만든 부드러운 반려동물 간식입니다.'),
('소고기 져키 간식', '육포왕', '간식', 8800, 70, 'snack04.jpg', '풍부한 맛의 소고기 져키 간식입니다.'),
('치킨 트릿', '츄잇츄잇', '간식', 6200, 110, 'snack05.jpg', '훈련용으로도 좋은 치킨 트릿입니다.'),

-- 장난감 카테고리
('양모 공 장난감', '토이펫', '장난감', 8500, 80, 'toy01.jpg', '양모로 만들어져 안전하고 재밌는 장난감입니다.'),
('고양이 낚싯대', '펫놀이', '장난감', 12000, 60, 'toy02.jpg', '고양이의 사냥 본능을 자극하는 낚싯대입니다.'),
('소리나는 인형', '펀펫', '장난감', 9000, 100, 'toy03.jpg', '소리로 흥미를 유도하는 귀여운 인형입니다.'),
('고무 장난감', '치아건강', '장난감', 7800, 75, 'toy04.jpg', '치아 관리에 좋은 고무 재질 장난감입니다.'),
('자동 레이저 장난감', '펫테크', '장난감', 25000, 30, 'toy05.jpg', '고양이를 위한 자동 레이저 추적 장난감입니다.'),

-- 옷 카테고리
('겨울용 방한옷', '포근펫', '옷', 15500, 40, 'cloth01.jpg', '겨울철에도 따뜻하게 지켜주는 펫 방한옷입니다.'),
('비옷 (우천용)', '펫케어', '옷', 13000, 35, 'cloth02.jpg', '비 오는 날에도 산책 가능한 방수 비옷입니다.'),
('여름용 쿨링 옷', '서머펫', '옷', 14000, 50, 'cloth03.jpg', '더운 여름에도 시원하게 입을 수 있는 쿨링 의류입니다.'),
('할로윈 의상', '코스튬펫', '옷', 17000, 25, 'cloth04.jpg', '귀여운 할로윈 테마 의상입니다.'),
('산책용 반사 조끼', '세이프펫', '옷', 16000, 45, 'cloth05.jpg', '야간 산책에 안전한 반사 기능 조끼입니다.'),

-- 집 카테고리
('2층 애완동물 하우스', '펫하우스', '집', 45000, 10, 'house01.jpg', '넓고 안락한 2층 구조의 고급 하우스입니다.'),
('휴대용 펫 텐트', '펫캠프', '집', 37000, 20, 'house02.jpg', '캠핑에 적합한 접이식 펫 전용 텐트입니다.'),
('실내용 쿠션 하우스', '펫드림', '집', 32000, 25, 'house03.jpg', '폭신하고 포근한 실내용 하우스입니다.'),
('자동 온열 하우스', '펫온', '집', 60000, 15, 'house04.jpg', '겨울철에도 따뜻하게 유지되는 온열 기능 하우스입니다.'),
('라탄 스타일 바구니 집', '에코펫', '집', 39000, 18, 'house05.jpg', '인테리어에 잘 어울리는 라탄 바구니 하우스입니다.');

-- ========================================
-- 테이블 확인
-- ========================================
SHOW TABLES;

-- 각 테이블 구조 확인
DESC member;
DESC board;
DESC comment;
DESC board_file;
DESC product;

-- 데이터 확인
SELECT COUNT(*) as total_products FROM product;
SELECT category, COUNT(*) as count FROM product GROUP BY category;