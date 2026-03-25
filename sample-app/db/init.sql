SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

USE sample_db;

ALTER DATABASE sample_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 제조업체 테이블
CREATE TABLE manufacturer (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    code       VARCHAR(20)  NOT NULL UNIQUE,
    country    VARCHAR(50)  DEFAULT '한국',
    created_at DATETIME     DEFAULT CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 품목 테이블
CREATE TABLE item (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer_id INT           NOT NULL,
    item_code       VARCHAR(50)   NOT NULL,
    item_name       VARCHAR(200)  NOT NULL,
    category        VARCHAR(50),
    unit_price      DECIMAL(15,2) DEFAULT 0,
    unit            VARCHAR(20)   DEFAULT 'EA',
    stock_qty       INT           DEFAULT 0,
    is_active       TINYINT(1)    DEFAULT 1,
    created_at      DATETIME      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id),
    UNIQUE KEY uq_item (manufacturer_id, item_code)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 샘플 데이터: 제조업체 2개
INSERT INTO manufacturer (name, code, country) VALUES
('삼성전자', 'SAMSUNG', '한국'),
('LG전자',   'LGELEC',  '한국');

-- 삼성전자 품목
INSERT INTO item (manufacturer_id, item_code, item_name, category, unit_price, unit, stock_qty) VALUES
(1, 'SAM-TV-001', 'QLED TV 55인치',  'TV',    1500000, 'EA', 50),
(1, 'SAM-PH-001', '갤럭시 S25',      '휴대폰', 1200000, 'EA', 200),
(1, 'SAM-WS-001', '세탁기 17kg',     '가전',    890000, 'EA', 30),
(1, 'SAM-AC-001', '에어컨 15평형',   '가전',    950000, 'EA', 40);

-- LG전자 품목
INSERT INTO item (manufacturer_id, item_code, item_name, category, unit_price, unit, stock_qty) VALUES
(2, 'LG-TV-001',  'OLED TV 65인치',  'TV',    2500000, 'EA', 20),
(2, 'LG-AC-001',  '에어컨 16평형',   '가전',    980000, 'EA', 45),
(2, 'LG-RF-001',  '냉장고 870L',     '가전',   1700000, 'EA', 15),
(2, 'LG-PH-001',  'LG 벨벳 2',      '휴대폰',  850000, 'EA', 100);
