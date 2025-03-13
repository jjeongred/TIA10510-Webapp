CREATE DATABASE IF NOT EXISTS life_space_01;

use life_space_01;

-- Drop Tables
DROP TABLE IF EXISTS space_photo;
DROP TABLE IF EXISTS space_usage_map;
DROP TABLE IF EXISTS space_equipment;
DROP TABLE IF EXISTS favorite_space;
DROP TABLE IF EXISTS space_comment_photo;
DROP TABLE IF EXISTS public_equipment;
DROP TABLE IF EXISTS event_photo;
DROP TABLE IF EXISTS comment_like;
DROP TABLE IF EXISTS comment_report;
DROP TABLE IF EXISTS chatroom_message;
DROP TABLE IF EXISTS rental_item_details;
DROP TABLE IF EXISTS space_usage;
DROP TABLE IF EXISTS rental_item;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS faq;
DROP TABLE IF EXISTS news;
DROP TABLE IF EXISTS news_category;
DROP TABLE IF EXISTS news_status;
DROP TABLE IF EXISTS event_member;
DROP TABLE IF EXISTS event;
DROP TABLE IF EXISTS space;
DROP TABLE IF EXISTS member;
DROP TABLE IF EXISTS admin;
DROP TABLE IF EXISTS branch;

-- Create Tablesevemt
CREATE TABLE branch (
	branch_id VARCHAR(5) PRIMARY KEY,
	branch_name VARCHAR(50) NOT NULL,
	branch_addr VARCHAR(255) NOT NULL,
	space_qty INT NOT NULL,
	latitude DOUBLE NOT NULL,
	longitude DOUBLE NOT NULL,
	branchstatus INT Not Null,
	created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE space (
    space_id VARCHAR(5) PRIMARY KEY,
    branch_id VARCHAR(5) NOT NULL,
    space_name VARCHAR(50) NOT NULL,
    space_people INT NOT NULL,
    space_size DOUBLE NOT NULL,
    space_hourly_fee INT,
    space_daily_fee INT,
    space_desc VARCHAR(1000),
    space_rating DOUBLE DEFAULT 0.0,
    space_alert VARCHAR(1000),
    space_used_24hr DOUBLE DEFAULT 0.0,
    space_used_7d DOUBLE DEFAULT 0.0,
    space_status INT NOT NULL,
    space_address VARCHAR(255) NOT NULL,
    latitude DOUBLE NOT NULL,
    longitude DOUBLE NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_space_branch_branch_id FOREIGN KEY (branch_id) REFERENCES branch (branch_id)
);

CREATE TABLE member (
    member_id VARCHAR(5) PRIMARY KEY comment "會員流水號",
    member_name VARCHAR(30) NOT NULL comment "會員姓名",
    member_image BLOB comment "會員大頭貼",
    email VARCHAR(100) NOT NULL UNIQUE comment "信箱",
    registration_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    phone VARCHAR(10) NOT NULL UNIQUE comment "電話",
    account_status INT NOT NULL comment "帳號狀態",
    password VARCHAR(20) NOT NULL comment "密碼",
    birthday DATE comment "生日"
);

CREATE TABLE admin (
    admin_id VARCHAR(5) PRIMARY KEY comment "管理者流水號",
    admin_name VARCHAR(20) NOT NULL comment "管理者帳號",
    password VARCHAR(30) NOT NULL comment "管理者密碼",
    email VARCHAR(100) NOT NULL UNIQUE comment "信箱",
    status INT NOT NULL comment "帳號狀態",
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);  

CREATE TABLE event(
	event_id VARCHAR(5) NOT NULL PRIMARY KEY COMMENT '活動流水號',
	event_name VARCHAR(20) NOT NULL COMMENT '活動標題',
	event_date TIMESTAMP NOT NULL COMMENT '活動日期',
	event_start_time TIMESTAMP NOT NULL COMMENT '活動開始時間',
	event_end_time TIMESTAMP NOT NULL COMMENT '活動結束時間',
	event_category VARCHAR(20) NOT NULL COMMENT '活動類型',
	space_id VARCHAR(5) COMMENT '活動空間流水號',
	member_id VARCHAR(5) COMMENT '活動主辦者流水號',
	number_of_participants INT NOT NULL COMMENT '目前參與人數',
	maximum_of_participants INT NOT NULL COMMENT '人數上限',
	event_briefing VARCHAR(100) NOT NULL COMMENT '活動說明',
	remarks VARCHAR(100) NOT NULL COMMENT '注意事項',
	host_speaking VARCHAR(100) NOT NULL COMMENT '主辦者的話',
	created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT fk_event_space_space_id FOREIGN KEY (space_id) REFERENCES space (space_id),
	CONSTRAINT fk_event_member_member_id FOREIGN KEY (member_id) REFERENCES member (member_id)
);

CREATE TABLE orders(
	order_id VARCHAR(5) PRIMARY KEY COMMENT '訂單流水號',
    space_id VARCHAR(5) COMMENT '空間流水號',
    member_id VARCHAR(5) COMMENT '會員流水號',
    branch_id VARCHAR(5) COMMENT '分點流水號',
    total_price INT NOT NULL COMMENT '總金額',
    payment_datetime TIMESTAMP NOT NULL COMMENT '訂單付款完成日期',
    order_start TIMESTAMP NOT NULL COMMENT '開始租用時間',
    order_end TIMESTAMP NOT NULL COMMENT '結束租用時間',
    comment_time TIMESTAMP COMMENT '評論時間',
    comment_contect TEXT COMMENT '評論內容',
    satisfaction INT COMMENT '滿意度',
    accounts_payable INT NOT NULL COMMENT '實際付款金額',
    order_status INT NOT NULL DEFAULT 1 COMMENT '1=已付款 , 2=已取消',
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP comment '建檔時間',
    CONSTRAINT fk_orders_space_space_id FOREIGN KEY (space_id) REFERENCES space (space_id),
	CONSTRAINT fk_orders_member_member_id FOREIGN KEY (member_id) REFERENCES member (member_id),
	CONSTRAINT fk_orders_branch_branch_id FOREIGN KEY (branch_id) REFERENCES branch (branch_id)
);

CREATE TABLE rental_item (
	rental_item_id VARCHAR(5) PRIMARY KEY,
	rental_item_name VARCHAR(20) NOT NULL,
	rental_item_price INT NOT NULL,
	total_quanitity INT NOT NULL,
	available_rental_quantity INT NOT NULL,
	pause_rental_quantity INT NOT NULL,
	branch_id VARCHAR(5) NOT NULL,
	created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT fk_rental_item_branch_branch_id FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);


CREATE TABLE rental_item_details (
	rental_item_details_id INT PRIMARY KEY AUTO_INCREMENT,
	order_id VARCHAR(5) NOT NULL,
	rental_item_id VARCHAR(5) NOT NULL,
	rental_item_quantity INT NOT NULL,
	created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT fk_rental_item_details_orders_order_id FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_rental_item_details_rental_item_rental_item_id FOREIGN KEY (rental_item_id) REFERENCES rental_item(rental_item_id)
);

CREATE TABLE public_equipment (
	public_equip_id INT PRIMARY KEY AUTO_INCREMENT,
	branch_id VARCHAR(5) NOT NULL,
	public_equip_name VARCHAR(50) NOT NULL,
	public_equip_comment VARCHAR(255),
	created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT fk_public_equipment_branch_branch_id FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

CREATE TABLE space_comment_photo(
	space_comment_photo_id VARCHAR(5) NOT NULL PRIMARY KEY COMMENT '空間評論照片流水號',
    order_id VARCHAR(5) COMMENT '訂單流水號',
    space_photo VARCHAR(255) COMMENT '空間評論照片',
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_space_comment_photo_orders_order_id FOREIGN KEY (order_id) REFERENCES orders (order_id)
); 

CREATE TABLE event_photo(
	photo_id VARCHAR(5) NOT NULL PRIMARY KEY COMMENT '活動照片流水號',
    event_id VARCHAR(5) NOT NULL COMMENT '活動流水編號',
    photo VARCHAR(255) COMMENT '活動照片',
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_event_photo_event_event_id FOREIGN KEY (event_id) REFERENCES event (event_id)
);

CREATE TABLE event_member(
	event_member_id VARCHAR(5) NOT NULL PRIMARY KEY COMMENT '活動參與會員',
	event_id VARCHAR(5) COMMENT '活動流水號',
	member_id VARCHAR(5) COMMENT '會員流水號',
	participate_status INT DEFAULT 1 COMMENT '參與候補狀態 0 = 候補, 1 = 已參與',
	participated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_event_member_event_event_id FOREIGN KEY (event_id) REFERENCES event (event_id),
    CONSTRAINT fk_event_member_member_member_id FOREIGN KEY (member_id) REFERENCES member (member_id)
);

CREATE TABLE comments (
	comment_id VARCHAR(5) PRIMARY KEY comment "留言流水號",
	event_member_id VARCHAR(5) NOT NULL comment "活動參與會員",
	comment_hide INT comment "留言隱藏",
	comment_message TEXT NOT NULL comment "留言內容",
	comment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT fk_comments_event_member_event_member_id FOREIGN KEY (event_member_id) REFERENCES event_member (event_member_id)
);

CREATE TABLE comment_report (
	report_id VARCHAR(5) PRIMARY KEY comment "檢舉流水號",
	member_id VARCHAR(5) NOT NULL comment "會員流水號",
	admin_id VARCHAR(5) NOT NULL comment "管理者流水號",
	comment_id VARCHAR(5) NOT NULL comment "留言流水號",
	manage_type INT comment "操作類型",
	close_time TIMESTAMP NOT NULL comment "結案時間",
	report_message TEXT NOT NULL comment "檢舉內容",
	report_reason TEXT NOT NULL comment "檢舉原因",
	status INT comment "案件狀態",
	created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP comment "建檔時間",
	CONSTRAINT fk_comment_report_member_member_id FOREIGN KEY (member_id) REFERENCES member (member_id),
	CONSTRAINT fk_comment_report_admin_admin_id FOREIGN KEY (admin_id) REFERENCES admin (admin_id),
	CONSTRAINT fk_comment_report_comments_comment_id FOREIGN KEY (comment_id) REFERENCES comments (comment_id)
);

CREATE TABLE comment_like (
	like_id INT PRIMARY KEY comment "按讚流水號",
	member_id VARCHAR(5) NOT NULL comment "會員流水號",
	comment_id VARCHAR(5) NOT NULL comment "留言流水號",
	created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP comment "建檔時間",
	CONSTRAINT fk_comment_like__member_member_id FOREIGN KEY (member_id) REFERENCES member (member_id),
	CONSTRAINT fk_comment_like__comments_comment_id FOREIGN KEY (comment_id) REFERENCES comments (comment_id)
);

CREATE TABLE  chatroom_message (
	chatroom_message_id     INT AUTO_INCREMENT PRIMARY KEY COMMENT '聊天室訊息流水號',
    admin_id 	VARCHAR(5) COMMENT '管理者流水號',
    member_id 	 VARCHAR(5) COMMENT '會員流水號',
    content  	 TEXT COMMENT '訊息內容',
    status_no	 INT  NOT NULL COMMENT '訊息方向',
    chat_photo VARCHAR(255) COMMENT '可傳送照片',
    send_time  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '訊息發送時間',
	CONSTRAINT fk_chatroom_message_admin_admin_id FOREIGN KEY (admin_id) REFERENCES admin (admin_id),
    CONSTRAINT fk_chatroom_message_member_member_id FOREIGN KEY (member_id) REFERENCES member (member_id)
)COMMENT '聊天室訊息';

CREATE TABLE  faq (
	faq_id 		 VARCHAR(5) PRIMARY KEY COMMENT '常見問題流水號',
	faq_ask		 VARCHAR(255) NOT NULL COMMENT '問題標題',
	faq_answer	 VARCHAR(5000) NOT NULL COMMENT '問題回答',
	faq_sort    INT NOT NULL COMMENT '問題分類',
	faq_status  INT  NOT NULL COMMENT '問題狀態',
	admin_id 	 VARCHAR(5) NOT NULL  COMMENT '管理者流水號',
	created_time  TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '建檔時間',    
	CONSTRAINT fk_faq_admin_admin_id FOREIGN KEY (admin_id) REFERENCES admin (admin_id)
)COMMENT '常見問題';


CREATE TABLE NEWS_CATEGORY (
NEWS_CATEGORY_ID  VARCHAR(5) PRIMARY KEY, 
CATEGORY_NAME 	VARCHAR(255) NOT NULL,
CREATED_TIME TIMESTAMP	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE NEWS_STATUS (
NEWS_STATUS_ID  VARCHAR(5) PRIMARY KEY, 
STATUS_NAME 	VARCHAR(255) NOT NULL,
CREATED_TIME TIMESTAMP	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE NEWS (
    NEWS_ID 	VARCHAR(5)	PRIMARY KEY comment "最新消息流水號",
    NEWS_TITLE 	VARCHAR(20)	NOT NULL comment "消息標題",
    NEWS_CONTENT VARCHAR(500) NOT NULL comment "消息內容",
    NEWS_START_DATE	TIMESTAMP NOT NULL comment "消息起始日",
    NEWS_END_DATE TIMESTAMP	NOT NULL comment "消息結束日", 
    NEWS_IMG 	VARCHAR(255) comment "消息圖片",		
    NEWS_CATEGORY_ID VARCHAR(5) NOT NULL,
    ADMIN_ID VARCHAR(5) NOT NULL,
    NEWS_STATUS_ID VARCHAR(5) NOT NULL,
    CREATED_TIME TIMESTAMP	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP comment "建檔時間",
    CONSTRAINT NEWS_CATEGORY_ID_FK FOREIGN KEY (NEWS_CATEGORY_ID) REFERENCES NEWS_CATEGORY(NEWS_CATEGORY_ID),
    CONSTRAINT ADMIN_ID_FK FOREIGN KEY (ADMIN_ID) REFERENCES ADMIN(ADMIN_ID),
    CONSTRAINT NEWS_STATUS_ID_FK FOREIGN KEY (NEWS_STATUS_ID) REFERENCES NEWS_STATUS(NEWS_STATUS_ID)
);


CREATE TABLE favorite_space (
    favorite_space_id INT AUTO_INCREMENT PRIMARY KEY,
    space_id VARCHAR(5) NOT NULL,
    member_id VARCHAR(5) NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_favorite_space_space_space_id FOREIGN KEY (space_id) REFERENCES space (space_id)
);

CREATE TABLE space_usage (
    space_usage_id VARCHAR(5) PRIMARY KEY,
    space_usage_name VARCHAR(10) NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE space_usage_map (
    usage_mapping_id INT AUTO_INCREMENT PRIMARY KEY,
    space_id VARCHAR(5) NOT NULL,
    space_usage_id VARCHAR(5) NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_space_usage_map_space_space_id FOREIGN KEY (space_id) REFERENCES space (space_id),
    CONSTRAINT fk_space_usage_map_space_usage_space_usage_id FOREIGN KEY (space_usage_id) REFERENCES space_usage (space_usage_id)
);

CREATE TABLE space_equipment (
    space_equip_id INT AUTO_INCREMENT PRIMARY KEY,
    space_id VARCHAR(5) NOT NULL,
    space_equip_name VARCHAR(50) NOT NULL,
    space_equip_comment VARCHAR(255),
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_space_equipment_space_space_id FOREIGN KEY (space_id) REFERENCES space (space_id)
);

CREATE TABLE space_photo (
    space_photo_id INT AUTO_INCREMENT PRIMARY KEY,
    space_id VARCHAR(5) NOT NULL,
    photo VARCHAR(255) NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_space_photo_space_space_id FOREIGN KEY (space_id) REFERENCES space (space_id)
);

-- Insert Data

INSERT INTO branch (branch_id, branch_name, branch_addr, space_qty, latitude, longitude, branchStatus) VALUES 
('B001', '松江南京', '台北市松江南京區北平西路3號1樓', 1,25.033964, 121.564468, 1),
('B002', '東門', '台北市東門區北平西路3號1樓', 2,25.034496,121.521984, 1),
('B003', '南京復興', '台北市南京復興區北平西路3號1樓', 3,25.087562,121.525450, 1),
('B004', '台北車站', '台北市中正區北平西路3號1樓', 4,25.047760, 121.517050, 1),
('B005', '西門町', '台北市西門區北平西路3號1樓', 5,25.137792,121.506510, 0);

INSERT INTO space (space_id, branch_id, space_name, space_people, space_size, space_hourly_fee, space_daily_fee, space_desc, space_alert, space_status, space_address, latitude, longitude) VALUES 
('S001','B001','Cozy 601',4,20.0,200,1200,'這個空間環境優美，設備齊全且現代化，非常適合家庭聚會與創意工作，讓人感受到溫馨舒適的氛圍。',null,1,'台北市中正區北平西路12號6樓',25.048,121.517),
('S002','B001','Cozy 602',15,32.5,400,2000,'溫馨舒適的環境，適合舉辦中型會議與各類培訓活動，更能營造專業氛圍。',null,1,'台北市中正區北平西路12號6樓',25.048,121.517),
('S003','B001','Cozy 603',20,40.0,500,3000,'採光充足並配備先進設備，激發團隊創意與靈感，適合不同規模交流。',null,1,'台北市中正區北平西路12號6樓',25.048,121.517),
('S004','B001','Cozy 604',8,20.0,300,1800,'提供專業辦公環境與安靜氛圍，能有效提升工作效率，助您專心投入。',null,1,'台北市中正區北平西路12號6樓',25.048,121.517),
('S005','B001','Cozy 605',50,100.0,1000,6000,'寬敞開闊的場地，能靈活布置各式佈景，特別適合舉辦成果發表或大型演出。',null,1,'台北市中正區北平西路12號6樓',25.048,121.517),

('S006','B002','Energy 801',4,20.0,250,1400,'該空間設計雅致，設備完善，能滿足商務洽談及會議需求，環境舒適且極具現代感。',null,1,'台北市中山區中山北路三段57號8樓',25.064,121.522),
('S007','B002','Energy 802',2,18.5,150,900,'寧靜舒適的空間設計，適合小規模會議及私密討論，環境溫馨且設備完善。',null,1,'台北市中山區中山北路三段57號8樓',25.064,121.522),
('S008','B002','Energy 803',4,25.0,200,1200,'明亮現代的工作室環境，適宜創意思考及小組討論，提供舒適又實用的設施。',null,1,'台北市中山區中山北路三段57號8樓',25.064,121.522),
('S009','B002','Energy 901',6,30.0,250,1500,'多功能展示間提供靈活空間佈局，適合產品發布與品牌推廣，環境優雅具現代感。',null,1,'台北市中山區中山北路三段57號9樓',25.064,121.522),
('S010','B002','Energy 902',3,22.0,180,1100,'精緻接待室設計精心打造，環境幽雅適合舉辦商務洽談及私人會議，服務細緻周到。',null,1,'台北市中山區中山北路三段57號9樓',25.064,121.522),
('S011','B002','Energy 903',8,28.0,300,1300,'溫馨家庭會客室設計充滿親和力，適合小家庭聚會與輕鬆交談，空間布置充滿生活情趣。',null,1,'台北市中山區中山北路三段57號9樓',25.064,121.522),

('S012','B003','Chill 401',10,30.0,300,1500,'此空間裝潢典雅，環境舒適，配置完善且光線充足，非常適合舉辦各種小型會議與休閒聚會。',null,1,'台北市內湖區內湖路一段445號4樓',25.083,121.575),
('S013','B003','Chill 402',8,25.0,250,1400,'空間設計精緻，提供高品質設備與舒適環境，適合小規模會議及創意思考的場所。',null,1,'台北市內湖區內湖路一段445號4樓',25.083,121.575),
('S014','B003','Chill 403',15,35.0,350,1600,'室內空間裝潢現代化，採光良好且通風順暢，能滿足團隊討論和創意發想的需要。',null,1,'台北市內湖區內湖路一段445號4樓',25.083,121.575),
('S015','B003','Chill 404',50,50.0,500,3000,'展演廳空間寬敞，聲光設備先進，適合各類表演和展示活動，營造出極佳的藝術氛圍。',null,1,'台北市內湖區內湖路一段445號4樓',25.083,121.575),
('S016','B003','Chill 1001',100,80.0,2000,15000,'空間內部裝潢豪華，空間布局合理，提供頂級服務與完善設施，適合舉辦大型慶典及商務活動。',null,1,'台北市內湖區內湖路一段445號10樓',25.083,121.575),

('S017','B004','Focus 1501',1,10.0,100,600,'這個空間小巧精緻，適合個人或雙人小會議，環境安靜舒適，設施完善可靠。',null,1,'台北市文山區木柵路二段88號15樓',24.988,121.569),
('S018','B004','Focus 1502',1,12.0,120,700,'單人工作室提供靜謐環境，適合個人專注工作，空間布局合理，讓人心情舒暢安心。',null,1,'台北市文山區木柵路二段88號15樓',24.988,121.569),
('S019','B004','Focus 1503',2,15.0,150,800,'微型洽談室設計精緻，適合一對一或小型會面，營造私密氛圍，讓交流更加順暢自在。',null,1,'台北市文山區木柵路二段88號15樓',24.988,121.569),
('S020','B004','Focus 1504',2,18.0,130,750,'靜謐小書房提供溫馨閱讀環境，適合靜心研讀與思考，空間小巧卻充滿文藝氣息。',null,1,'台北市文山區木柵路二段88號15樓',24.988,121.569),
('S021','B004','Focus 1505',3,20.0,150,900,'此空間設計優雅，設備先進，適合舉辦小型會議與私人聚會，環境安靜宜人。',null,1,'台北市文山區木柵路二段88號15樓',24.988,121.569),
('S022','B004','Focus 1506',6,25.0,180,1000,'空間明亮寬敞，佈局合理，專為中小規模聚會及商務洽談設計，創造舒適交流環境。',null,1,'台北市文山區木柵路二段88號15樓',24.988,121.569),
('S023','B004','Focus 1507',10,30.0,200,1200,'設施完善且現代化，空間氣氛溫馨，特別適合家庭聚會或小型工作坊，令人印象深刻。',null,1,'台北市文山區木柵路二段88號15樓',24.988,121.569),

('S024','B005','Life 801',20,50.0,400,2500,'此會議室設計現代化，空間寬敞明亮，適合舉辦中大型會議與各類活動，並提供先進設備，讓參與者倍感舒適。',null,1,'台北市中正區漢口街一段36號8樓',25.045,121.514),
('S025','B005','Life 802',4,10.0,200,1200,'該空間寬敞設計現代，提供全面服務，環境安全舒適。',null,1,'台北市中正區漢口街一段36號8樓',25.045,121.514);

INSERT INTO member(member_id,member_name,email,registration_time,phone,account_status,password,birthday)VALUES
  ("M001","小明","abc@gmail.com",NOW(),"0912345678",0,"123","1988-09-08"),
  ("M002","小花","def@gmail.com",NOW(),"0912345679",0,"456","1988-04-08"),
  ("M003","小犬","ghi@gmail.com",NOW(),"0912345670",1,"789","1988-09-010"),
  ("M004","小綠","jkl@gmail.com",NOW(),"0912345671",0,"789","1988-011-08"),
  ("M005","小象","mno@gmail.com",NOW(),"0912345672",1,"234","1988-012-08");


INSERT INTO admin(admin_id,admin_name,password,email,status,created_time)VALUES
("A001","大明","321","cba@gmail.com",1,NOW()),
("A002","大花","654","wfew@gmail.com",0,NOW()),
("A003","大犬","321","qwefwef@gmail.com",0,NOW()),
("A004","大綠","987","fewfw@gmail.com",1,NOW()),
("A005","大象","210","efef@gmail.com",1,NOW());

INSERT INTO event (event_id, event_name, event_date, event_start_time, event_end_time, event_category, space_id, member_id, number_of_participants, maximum_of_participants, event_briefing, remarks, host_speaking)
VALUES
('E001','狼人殺', '2025-02-22 14:00:00', '2025-02-22 14:00:00', '2025-02-22 16:00:00', '桌遊', 'S001', 'M001', 5, 10, '經典社交推理遊戲，適合多人參與', '請準時到場', '歡迎大家一起來挑戰邏輯與膽識'),
('E002','阿瓦隆', '2025-02-23 18:00:00', '2025-02-23 18:00:00', '2025-02-23 20:00:00', '桌遊', 'S002', 'M002', 4, 8, '另一種推理遊戲，包含秘密角色和任務', '請提前了解遊戲規則', '這場將會有不少出奇不意的反轉'),
('E003','機密代號', '2025-02-24 10:00:00', '2025-02-24 10:00:00', '2025-02-24 12:00:00', '桌遊', 'S003', 'M003', 4, 8, '團隊合作解謎遊戲，訓練邏輯與溝通能力', '最好能組成兩隊參與', '大家加油，合作無間才能獲勝'),
('E004','矮人礦坑', '2025-02-25 15:00:00', '2025-02-25 15:00:00', '2025-02-25 17:00:00', '桌遊', 'S004', 'M004', 3, 6, '冒險性強的桌遊，玩家們探索礦坑與資源', '適合多人一起參加', '準備好你的探險裝備，發掘珍貴寶物'),
('E005','盜夢都市', '2025-02-26 20:00:00', '2025-02-26 20:00:00', '2025-02-26 22:00:00', '桌遊', 'S005', 'M005', 4, 8, '桌上遊戲，玩家在夢境中進行盜竊任務', '謎題密集，請務必集中精神', '一起挑戰最深層的夢境謎題');

INSERT INTO orders (order_id, space_id, member_id, branch_id, total_price, payment_datetime, order_start, order_end, comment_time, comment_contect, satisfaction, accounts_payable)
VALUES
('OR001', 'S001', 'M001', 'B001', 1000, '2025-02-22 14:30:00', '2025-02-22 14:00:00', '2025-02-22 16:00:00', '2025-02-22 16:30:00', '遊戲非常有趣，活動氣氛熱烈，大家玩得很開心！', 5, 1000),
('OR002', 'S002', 'M002', 'B002', 1200, '2025-02-23 18:30:00', '2025-02-23 18:00:00', '2025-02-23 20:00:00', '2025-02-23 20:30:00', '活動非常順利，主持人很有耐心，讓我們都很享受', 4, 1200),
('OR003', 'S003', 'M003', 'B003', 1500, '2025-02-24 12:00:00', '2025-02-24 10:00:00', '2025-02-24 12:00:00', '2025-02-24 12:30:00', '遊戲規則簡單，適合全家一起玩，氣氛也很輕鬆', 4, 1500),
('OR004', 'S004', 'M004', 'B004', 800, '2025-02-25 17:30:00', '2025-02-25 15:00:00', '2025-02-25 17:00:00', '2025-02-25 17:45:00', '非常好玩的冒險遊戲，團隊合作非常重要！', 5, 800),
('OR005', 'S005', 'M005', 'B005', 1100, '2025-02-26 22:30:00', '2025-02-26 20:00:00', '2025-02-26 22:00:00', '2025-02-26 22:45:00', '遊戲設計很巧妙，玩得非常過癮，難度適中！', 5, 1100);

INSERT INTO rental_item (rental_item_id, rental_item_name, rental_item_price, total_quanitity, available_rental_quantity, pause_rental_quantity, branch_id) VALUES 
('RI001', '白板',30,5,3,2,'B001'),
('RI002', '鉛筆',20,6,1,5,'B001'),
('RI003', '電扇',50,7,4,3,'B001'),
('RI004', '抹布',10,8,2,6,'B001'),
('RI005', '彩色筆',20,9,8,1,'B001'),
('RI006', '白板',30,5,3,2,'B002'),
('RI007', '鉛筆',20,6,1,5,'B002'),
('RI008', '電扇',50,7,4,3,'B002'),
('RI009', '抹布',10,8,2,6,'B002'),
('RI010', '彩色筆',20,9,8,1,'B002'),
('RI011', '白板',30,5,3,2,'B003'),
('RI012', '鉛筆',20,6,1,5,'B003'),
('RI013', '電扇',50,7,4,3,'B003'),
('RI014', '抹布',10,8,2,6,'B003'),
('RI015', '彩色筆',20,9,8,1,'B003'),
('RI016', '白板',30,5,3,2,'B004'),
('RI017', '鉛筆',20,6,1,5,'B004'),
('RI018', '電扇',50,7,4,3,'B004'),
('RI019', '抹布',10,8,2,6,'B004'),
('RI020', '彩色筆',20,9,8,1,'B004'),
('RI021', '白板',30,5,3,2,'B005'),
('RI022', '鉛筆',20,6,1,5,'B005'),
('RI023', '電扇',50,7,4,3,'B005'),
('RI024', '抹布',10,8,2,6,'B005'),
('RI025', '彩色筆',20,9,8,1,'B005');

INSERT INTO rental_item_details (order_id, rental_item_id, rental_item_quantity)  VALUES 
('OR001','RI001', 1),
('OR002','RI007', 1),
('OR003','RI012', 1),
('OR004','RI018', 1),
('OR005','RI023', 1);

INSERT INTO public_equipment (branch_id, public_equip_name, public_equip_comment)  VALUES 
('B001' ,'廁所','位於電梯旁'),
('B002' ,'飲水機','位於9樓廁所旁邊'),
('B003' ,'紙杯','需跟櫃檯索取'),
('B004' ,'衛生紙',null),
('B005' ,'垃圾桶','位於9樓電梯旁邊');

INSERT INTO space_comment_photo (space_comment_photo_id, order_id, space_photo) VALUES
('SC001', 'OR001', "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_comment_1.jpg"),
('SC002', 'OR002', "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_comment_2.png"),
('SC003', 'OR003', "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_comment_3.jpg"),
('SC004', 'OR004', NULL),
('SC005', 'OR005', NULL);

INSERT INTO event_photo (photo_id, event_id, photo) VALUES
('P001', 'E001', "/Users/ryuryu4211/Desktop/LifeSpace/photo/event_1_1.jpg"),
('P002', 'E001', "/Users/ryuryu4211/Desktop/LifeSpace/photo/event_1_2.jpg"),
('P003', 'E002', "/Users/ryuryu4211/Desktop/LifeSpace/photo/event_2_1.jpg"),
('P004', 'E002', "/Users/ryuryu4211/Desktop/LifeSpace/photo/event_2_2.jpg"),
('P005', 'E003', "/Users/ryuryu4211/Desktop/LifeSpace/photo/event_3_1.jpg"),
('P006', 'E003', "/Users/ryuryu4211/Desktop/LifeSpace/photo/event_3_2.jpg"),
('P007', 'E004', "/Users/ryuryu4211/Desktop/LifeSpace/photo/event_4_1.jpeg"),
('P008', 'E004', "/Users/ryuryu4211/Desktop/LifeSpace/photo/event_4_2.jpg"),
('P009', 'E005', "/Users/ryuryu4211/Desktop/LifeSpace/photo/event_5_1.jpg"),
('P010', 'E005', "/Users/ryuryu4211/Desktop/LifeSpace/photo/event_5_2.png");

INSERT INTO event_member (event_member_id, event_id, member_id, participate_status) VALUES
('EM001', 'E001', 'M001', DEFAULT),
('EM002', 'E002', 'M002', 1),
('EM003', 'E003', 'M003', 1),
('EM004', 'E004', 'M004', 0),
('EM005', 'E005', 'M005', 1);

INSERT INTO comments (comment_id, event_member_id, comment_hide, comment_message, comment_time) VALUES
('C001','EM001',1,'這種活動也值得參加?浪費時間!',NOW()),
('C002','EM002',1,'誰會想參加這麼無聊的活動?',NOW()),
('C003','EM003',0,'活動地點安排很方便，活動氣氛很好，認識了很多志同道合的朋友',NOW()),
('C004','EM004',0,'主辦方非常用心，感謝這次的安排!',NOW()),
('C005','EM001',1,'活動設計得像兒戲，笑死我了！',NOW()),
('C006','EM002',1,'參加一次就再也不想來了。',NOW()),
('C007','EM003',0,'這次活動辦得非常好，真的受益良多！',NOW()),
('C008','EM004',0,'活動內容豐富有趣，還想再參加一次！',NOW()),
('C009','EM002',1,'主辦方根本不專業，建議解散。',NOW()),
('C010','EM003',0,'這活動超出我的期待，真的太棒了！',NOW());

INSERT INTO comment_report (report_id, member_id, admin_id, comment_id, manage_type, close_time, report_message, report_reason, status) VALUES
('CR001','M001','A001','C001',1,NOW(),'這活動超爛，主辦方腦子進水了吧？','涉及人身攻擊，言語不當。',1),
('CR002','M002','A002','C002',0,NOW(),'這麼簡單的問題都不會解決？主辦方是智障嗎？','使用侮辱性詞語，對特定群體不尊重。',1),
('CR003','M003','A003','C003',1,NOW(),'這活動就是給某些特定人參加的吧？其他人滾遠點！','涉及排他性歧視，違反平等原則。',0),
('CR004','M004','A004','C004',0,NOW(),'某些族群的人還是別來了，根本不適合！','含有種族歧視或排擠特定群體的意味。',0),
('CR005','M005','A005','C005',1,NOW(),'這次活動已經取消了，大家不要去！','發布虛假資訊，可能影響活動正常進行。',1),
('CR006','M001','A001','C006',0,NOW(),'這活動其實有內定名額，一般人根本沒機會！','散播謠言，影響公平性認知。',1),
('CR007','M002','A002','C007',1,NOW(),'主辦方長得醜就別辦活動了，丟人現眼！','涉及外貌羞辱，屬於惡意騷擾。',0),
('CR008','M003','A003','C008',0,NOW(),'大家來點進這個連結，可以免費拿到獎品！http://freemoney-now.com','可能涉及詐騙或惡意連結攻擊。',0),
('CR009','M004','A004','C009',1,NOW(),'講師的水準跟小學生差不多，真是笑話！','貶低他人專業能力，帶有歧視意味。',1),
('CR010','M005','A005','C010',0,NOW(),'這活動根本不該讓某某國家的人參加，浪費名額！','包含國籍歧視，違反公平參與原則。',0);

INSERT INTO comment_like (like_id, member_id, comment_id) VALUES
(1,'M001','C001'),
(2,'M002','C002'),
(3,'M003','C003'),
(4,'M004','C004'),
(5,'M005','C005'),
(6,'M001','C001'),
(7,'M002','C002'),
(8,'M003','C003'),
(9,'M004','C004'),
(10,'M005','C005');

INSERT INTO chatroom_message (admin_id, member_id, content, status_no, chat_photo)  VALUES 
-- 會員 M001 問，管理員 A001 回答
('A001', 'M001', '請問這裡有 Wi-Fi 嗎？', 0, NULL),
('A001', 'M001', '有的，每間房間都提供高速 Wi-Fi。', 1, NULL),

-- 會員 M002 問，管理員 A002 回答
('A002', 'M002', '請問可以延長時間嗎？', 0, NULL),
('A002', 'M002', '可以的，請至訂單按"延長時間"，並於租用時間前30分鐘完成；如停留空間未加時則額外收取費用。', 1, NULL),

-- 會員 M003 問，管理員 A003 回答
('A003', 'M003', '有提供垃圾處理嗎？', 0, NULL),
('A003', 'M003', '我們有垃圾集中區，請按照分類規定丟棄。', 1, NULL),

-- 會員 M004 問兩個問題，管理員 A004 依序回覆
('A004', 'M004', '請問可以帶微波爐嗎？', 0, NULL),
('A004', 'M004', '您好，不行攜帶喔!若有另外特殊需求可再詢問。', 1, NULL),
('A004', 'M004', '有停車場可以使用嗎？', 0, NULL),
('A004', 'M004', '部分空間附近有停車場，可先於地圖附近查看喔!', 1, NULL),

-- 會員 M005 問，管理員 A005 回答
('A005', 'M005', '請問可以帶寵物嗎？', 0, NULL),
('A005', 'M005', '部分空間可攜帶寵物，請於預訂前確認。', 1, NULL),

-- 會員 M006 問，管理員 A002 回答
('A002', 'M001', '如何聯絡客服？', 0, NULL),
('A002', 'M001', '您可透過客服聊天室或撥打客服專線與我們聯繫。', 1, NULL),

-- 會員 M007 問，管理員 A003 回答
('A003', 'M002', '租金怎麼支付？', 0, NULL),
('A003', 'M002', '我們接受信用卡支付方式。', 1, NULL);


-- 插入資料
INSERT INTO faq (faq_id, faq_ask, faq_answer, faq_sort, faq_status, admin_id )  VALUES 
('FAQ01','LifeSpace入住與離場',
'房間密碼將於預訂時間前5分鐘 生效，若提早進入，將收取 NT$1,000 罰款。
預訂時間結束後，請準時離場，若超時 10 分鐘內將不另收費，但超過 15 分鐘則以半小時為單位計費。
若需延長使用時間，請提前於 30 分鐘前聯繫客服，以確保場地可延長使用。'
, 0, 1, 'A001'),

('FAQ02','LifeSpace 空間介紹',
'LifeSpace 是一個多功能彈性租賃空間，適合 辦公、娛樂、會議、創作，或任何你需要專屬空間的時刻！
透過線上預訂，即可輕鬆入場，無需繁瑣對接，讓你隨時擁有一個自在、靈活的專屬空間，盡情享受你的 Life Space！'
, 3, 1, 'A005'),

('FAQ03','租賃空間如何計價',
'ifeSpace 採時計計費，最低租用時間為 1 小時，之後以 30 分鐘為單位計費。
平日 / 假日：費用可能不同，詳細費率可於預訂頁面 查詢。
超時費用：超時10分鐘內不加收，超過15分鐘依半小時計費。
延長租用：請於30分鐘前 聯繫客服確認是否可延長。'
, 1, 1, 'A004'),

('FAQ04','自助式空間如何清潔？',
'使用結束後，請遵守「使用後恢復原狀」原則，讓下一位使用者也能擁有舒適的環境！
清潔步驟如下：
垃圾分類丟棄（垃圾桶位置請參考現場指引）。
擦拭桌面 & 白板，恢復使用前狀態。
歸位家具 & 設備（如桌椅、遙控器等）。
關閉電燈 & 冷氣，節約能源。
📌若未完成清潔，可能會收取 NT$600-NT$5,000清潔費，請共同維護空間品質！'
, 0, 1, 'A001'),

('FAQ05','如要辦活動如何場勘？',
'1.如何預約場勘？
透過官方網站 / 客服提前預約場勘時間。
場勘時長約30分鐘，免費參觀與測試場地設備;如超過30分鐘則酌收額外費用。
2.場勘時可確認的事項：
空間大小、可容納人數；設備（投影機、音響、桌椅擺設等）；是否有額外需求（餐飲、垃圾處理等）。
📌 建議提前3-5天預約場勘，以確保有空檔安排！'
, 1, 1, 'A001'),

('FAQ06','LifeSpace 提供哪些公用設備與設施？',
'1.基本設備
高速 Wi-Fi：穩定網路，方便工作與娛樂。
空調與暖氣：維持舒適的室內溫度。
電源插座與 USB 充電站：隨時為設備充電。
智慧門禁系統：電子門鎖，安全有保障。
監視系統：公共區域監控，提升安全性。
2.公共空間:
有公共廁所，但衛生紙需自行攜帶。
設有垃圾桶或垃圾集中區。 若垃圾量較多，請自備垃圾袋並放置於集中區。
垃圾處理規範：部分垃圾可能有丟棄限制，詳情請參閱使用規範。若擔心垃圾超過限制，請於預訂前確認是否可代收或需額外清潔費用。
部分空間提供飲水機，部分則需自行攜帶飲水。 詳情請參閱各空間說明。'
, 3, 1, 'A003'),

('FAQ07','使用規範',
'保持適當音量，避免大聲喧嘩、跑跳，以維護場地周邊環境安寧。使用空間時，請妥善愛惜場地設施，避免破壞裝潢與家具，如有損毀，將依照損害程度酌收維修費用。
使用後請恢復原狀，物品歸位、擦拭桌面、白板擦除，丟棄垃圾請參考現場使用須知，留給下一位使用者乾淨舒適的環境。離開時，請關閉電燈、冷氣，確保所有設備皆已關閉，以節約能源。'
, 0, 1, 'A002'),

('FAQ08','注意事項',
'由於空間使用者的故意或過失，導致LifeSpace遭受損害時，LifeSpace將向該使用者要求賠償。空間使用者於租用開始之前、中、後，任何放置於LifeSpace空間內、公共區域之物品，LifeSpace將不負責任何保管及賠償責任。
LifeSpace保留主動刪除空間使用者預訂之權利。
📌 若違反上述規定，LifeSpace 有權立即終止租賃，並取消未來預約，且不退費！'
, 0, 1, 'A002'),

('FAQ09','安全與保險',
'LifeSpace不負責租用者在場內的個人物品，如有遺失、被竊或損壞，本公司不承擔任何保管及賠償責任。
LifeSpace 已投保公共意外責任險，若因場地問題導致意外，我們將依保險規範提供理賠服務。
其他使用規範與罰則，請參考使用者條款。'
, 3, 1, 'A001'),

('FAQ10','付款以及發票的開立方式？',
' 一般租用，有提供線上刷卡、街口支付、AFTEE先享後付。若有企業月結需求，請與LifeSpace客服聯繫。
儲值點數，以點數租用空間，則提供網路刷卡、ATM轉帳、超商繳納等多元付款方式。
發票僅提供「雲端發票」，請您在儲值點數、預訂付款時確認資料無誤或輸入統編，付款完成後，系統會自動寄送給您。'
, 2, 1, 'A003'),

('FAQ11','防詐騙資訊提醒',
' 提醒您，請警惕以下常見詐騙手法：
1.訂單設定錯誤或金額異常；
2.利用分期付款、每月扣款誘使您修改付款方式；
3.重複訂購多筆商品；
4-故意製造宅配或超商配送、簽收文件錯誤（如簽收單誤簽為簽帳單、條碼刷錯、重複扣款）；
5.詐騙分子往往以“更改訂單並要求退費”為藉口，要求您操作 ATM 進行資金轉移。
若接獲可疑來電，請立即撥打 165 反詐騙諮詢專線求助。'
, 3, 1, 'A003'),

('FAQ12','使用加時、超時規則說明',
' 若需延長使用時間，請在活動結束前，前往「密碼頁面」或「我的訂單頁面」，點選延長加時。
若未及時加時，導致影響下一位使用者或管家清潔作業，將收取超時費用。未於規範時間內完成延長加時，將無法繼續使用空間，請準時離場。若需再次使用，請重新預約場地。
超時費用以每 30 分鐘為單位計算，並收取2 倍的該空間租賃費用。詳細規範請參閱**「使用者條款」第66條超時費用**。'
, 1, 1, 'A005');

INSERT INTO NEWS_CATEGORY (NEWS_CATEGORY_ID, CATEGORY_NAME, CREATED_TIME) VALUES 
('NC001', '重要公告'  ,NOW()),
('NC002', '活動' ,NOW()),
('NC003', '空間' ,NOW());

INSERT INTO NEWS_STATUS (NEWS_STATUS_ID, STATUS_NAME, CREATED_TIME) VALUES 
('NS001', '過期'  ,NOW()),
('NS002', '上架中' ,NOW()),
('NS003', '即將發布' ,NOW());

INSERT INTO NEWS (NEWS_ID, NEWS_TITLE, NEWS_CONTENT, NEWS_START_DATE, NEWS_END_DATE, NEWS_IMG, NEWS_CATEGORY_ID, ADMIN_ID, NEWS_STATUS_ID) VALUES 
('N001', '最新優惠'  ,'優惠優惠優惠優惠優惠',STR_TO_DATE('2025-02-18','%Y-%m-%d'),STR_TO_DATE('2025-03-18','%Y-%m-%d'),0.0 ,'NC001','A001','NS002'),
('N002', '裝潢公告' ,'公告公告公告公告公告'  ,STR_TO_DATE('2025-02-19','%Y-%m-%d'),STR_TO_DATE('2025-03-18','%Y-%m-%d'),0.0,'NC003','A001','NS002'),
('N003', '優惠券發放' ,'發放發放發放發放發放'  ,STR_TO_DATE('2025-02-01','%Y-%m-%d'),STR_TO_DATE('2025-02-05','%Y-%m-%d'),0.0,'NC001','A001','NS001'),
('N004', '徵才消息' ,'消息消息消息消息消息'  ,STR_TO_DATE('2025-02-21','%Y-%m-%d'),STR_TO_DATE('2025-03-18','%Y-%m-%d'),0.0,'NC001','A001','NS003'),
('N005', '春節優惠','春節春節春節春節春節' ,STR_TO_DATE('2025-02-03','%Y-%m-%d'),STR_TO_DATE('2025-02-05','%Y-%m-%d'),0.0,'NC002','A001','NS001');

INSERT INTO favorite_space(space_id, member_id) VALUES ("S001", "M001");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S001", "M003");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S002", "M002");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S003", "M001");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S003", "M005");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S005", "M002");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S006", "M004");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S009", "M003");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S011", "M001");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S013", "M001");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S013", "M005");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S014", "M004");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S015", "M002");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S015", "M003");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S015", "M005");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S016", "M002");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S016", "M001");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S017", "M004");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S018", "M004");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S020", "M003");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S022", "M005");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S023", "M002");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S023", "M003");
INSERT INTO favorite_space(space_id, member_id) VALUES ("S024", "M004");

INSERT INTO space_usage(space_usage_id, space_usage_name) VALUES ("SU001", "遠距辦公");
INSERT INTO space_usage(space_usage_id, space_usage_name) VALUES ("SU002", "自修");
INSERT INTO space_usage(space_usage_id, space_usage_name) VALUES ("SU003", "會議");
INSERT INTO space_usage(space_usage_id, space_usage_name) VALUES ("SU004", "講座");
INSERT INTO space_usage(space_usage_id, space_usage_name) VALUES ("SU005", "聚會");

INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S001", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S001", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S002", "SU003");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S002", "SU004");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S002", "SU005");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S003", "SU004");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S003", "SU005");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S004", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S004", "SU003");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S005", "SU004");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S005", "SU005");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S006", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S006", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S007", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S007", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S008", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S008", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S009", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S009", "SU003");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S010", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S011", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S011", "SU003");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S011", "SU005");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S012", "SU003");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S012", "SU005");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S013", "SU003");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S014", "SU003");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S015", "SU005");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S016", "SU005");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S017", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S017", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S018", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S018", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S019", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S019", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S020", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S020", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S021", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S021", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S022", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S022", "SU003");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S023", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S023", "SU003");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S023", "SU004");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S023", "SU005");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S024", "SU004");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S024", "SU005");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S025", "SU001");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S025", "SU002");
INSERT INTO space_usage_map(space_id, space_usage_id) VALUES ("S025", "SU003");

INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S001", "舒適座椅", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S001", "會議桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S001", "白板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S001", "投影機", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S001", "高速WiFi", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S002", "長桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S002", "投影設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S002", "環繞音響", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S002", "冷氣", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S002", "無線麥克風", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S003", "沙發", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S003", "燈光設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S003", "白板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S003", "會議桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S003", "茶水機", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S004", "可調式辦公桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S004", "人體工學椅", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S004", "多功能插座", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S004", "吸音牆", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S004", "會議視訊設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S005", "舞台燈光", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S005", "高功率音響", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S005", "無線麥克風", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S005", "LED螢幕", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S005", "活動佈景", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S006", "高級辦公桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S006", "高背椅", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S006", "視訊會議設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S006", "檯燈", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S006", "會議電話", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S007", "沙發區", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S007", "小圓桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S007", "咖啡機", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S007", "書架", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S007", "立燈", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S008", "共享辦公桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S008", "會議區", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S008", "高速WiFi", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S008", "藍牙喇叭", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S008", "USB充電座", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S009", "展示架", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S009", "燈光聚焦", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S009", "LED螢幕", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S009", "觸控面板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S009", "產品展示台", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S010", "高檔沙發", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S010", "商務投影儀", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S010", "迷你吧", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S010", "會議桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S010", "無線充電座", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S011", "長桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S011", "冷氣", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S011", "高速WiFi", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S011", "互動白板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S011", "音響設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S012", "會議桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S012", "白板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S012", "視訊設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S012", "USB插座", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S012", "立燈", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S013", "會議桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S013", "多功能白板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S013", "藍牙音響", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S013", "記錄設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S013", "高速WiFi", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S014", "藍牙音響", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S014", "可移動白板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S014", "桌上型麥克風", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S014", "高解析度螢幕", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S014", "USB充電站", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S015", "舞台燈光", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S015", "環繞音響", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S015", "麥克風", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S015", "大型投影布幕", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S015", "直播設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S016", "LED螢幕", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S016", "高功率音響", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S016", "投影機", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S016", "可移動桌椅", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S016", "無線控制系統", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S017", "小型會議桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S017", "雙人沙發", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S017", "白板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S017", "立燈", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S017", "高速WiFi", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S018", "單人辦公桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S018", "辦公椅", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S018", "高速WiFi", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S018", "靜音耳機", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S018", "可調式檯燈", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S019", "小型圓桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S019", "兩人座沙發", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S019", "無線電話", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S019", "USB充電口", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S019", "LED檯燈", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S020", "書架", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S020", "閱讀燈", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S020", "舒適單人椅", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S020", "茶几", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S020", "音樂播放器", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S021", "會議桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S021", "白板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S021", "視訊設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S021", "無線投影儀", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S021", "會議電話", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S022", "長桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S022", "吸音板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S022", "高速WiFi", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S022", "互動螢幕", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S022", "USB插座", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S023", "會議桌", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S023", "多功能白板", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S023", "無線簡報器", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S023", "HDMI輸入", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S023", "環繞音響", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S024", "演講台", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S024", "LED螢幕", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S024", "高功率音響", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S024", "無線麥克風", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S024", "投影設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S025", "舞台設備", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S025", "大型LED屏幕", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S025", "音響系統", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S025", "無線控制燈光", null);
INSERT INTO space_equipment(space_id, space_equip_name, space_equip_comment) VALUES ("S025", "無線麥克風", null);

INSERT INTO space_photo(space_id, photo) VALUES ("S001", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_1_1.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S002", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_2_1.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S002", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_2_2.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S002", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_2_3.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S002", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_2_4.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S003", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_3_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S004", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_4_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S004", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_4_2.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S004", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_4_3.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S005", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_5_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S005", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_5_2.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S005", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_5_3.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S006", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_6_1.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S007", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_7_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S008", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_8_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S009", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_9_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S009", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_9_2.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S010", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_10_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S011", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_11_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S011", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_11_2.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S012", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_12_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S013", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_13_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S013", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_13_2.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S013", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_13_3.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S014", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_14_1.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S014", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_14_2.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S014", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_14_3.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S014", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_14_4.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S015", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_15_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S016", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_16_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S016", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_16_2.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S017", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_17_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S018", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_18_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S019", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_19_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S020", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_20_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S021", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_21_1.jpeg");
INSERT INTO space_photo(space_id, photo) VALUES ("S022", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_22_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S023", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_23_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S024", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_24_1.jpg");
INSERT INTO space_photo(space_id, photo) VALUES ("S025", "/Users/ryuryu4211/Desktop/LifeSpace/photo/space_25_1.jpg");