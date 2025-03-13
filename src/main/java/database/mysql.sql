CREATE DATABASE IF NOT EXISTS life_space_01;

use life_space_01;

-- Drop Tables
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS event_member;

-- Create Tablesevemt
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

-- Insert Data
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

