--活動留言
DROP TABLE IF EXISTS comments;

-- 插入表格
CREATE TABLE comments (
	comment_id VARCHAR(5) PRIMARY KEY comment "留言流水號",
	event_member_id VARCHAR(5) NOT NULL comment "活動參與會員",
	comment_hide INT comment "留言隱藏",
	comment_message TEXT NOT NULL comment "留言內容",
	comment_time TIMESTAMP NOT NULL comment "留言時間",
	created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP comment "建檔時間",
	CONSTRAINT fk_comments_event_member_event_member_id FOREIGN KEY (event_member_id) REFERENCES event_member (event_member_id)
	
--	EMPNO     VARCHAR(5) PRIMARY KEY,	
--	ENAME     VARCHAR(10),
--	JOB       VARCHAR(9),
--	HIREDATE  DATE,
--	SAL       DECIMAL(7,2),
--	COMM      DECIMAL(7,2),
--	DEPTNO    INT NOT NULL,    
--	CONSTRAINT EMP2_DEPTNO_FK FOREIGN KEY (DEPTNO) REFERENCES DEPT2 (DEPTNO)
);

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

---- 插入資料
--INSERT INTO EMP3 (EMPNO, ENAME, JOB, HIREDATE, SAL, COMM, DEPTNO) VALUES 
--('E001', 'KING'  ,'PRESIDENT',STR_TO_DATE('1981-11-17','%Y-%m-%d'),5000.5,0.0 ,10),
--('E002', 'BLAKE' ,'MANAGER'  ,STR_TO_DATE('1981-05-01','%Y-%m-%d'),2850.0,0.0 ,30),
--('E003', 'CLARK' ,'MANAGER'  ,STR_TO_DATE('1981-01-09','%Y-%m-%d'),2450.0,0.0 ,10),
--('E004', 'JONES' ,'MANAGER'  ,STR_TO_DATE('1981-04-02','%Y-%m-%d'),2975.0,0.0 ,20),
--('E005', 'MARTIN','SALESMAN' ,STR_TO_DATE('1981-09-28','%Y-%m-%d'),1250.0,1400,30);

--留言按讚紀錄表
DROP TABLE IF EXISTS comment_like;

-- 插入表格
CREATE TABLE comment_like (
	like_id INT PRIMARY KEY comment "按讚流水號",
	member_id VARCHAR(5) NOT NULL comment "會員流水號",
	comment_id VARCHAR(5) NOT NULL comment "留言流水號",
	created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP comment "建檔時間",
	CONSTRAINT fk_comment_like__member_member_id FOREIGN KEY (member_id) REFERENCES member (member_id),
	CONSTRAINT fk_comment_like__comments_comment_id FOREIGN KEY (comment_id) REFERENCES comments (comment_id)

INSERT INTO comments (like_id, member_id, comment_id) VALUES
(1,'M001','C001'),
(2,'M002','C002'),
(3,'M003','C003'),
(4,'M004','C004'),
(5,'M005','C005'),
(6,'M006','C006'),
(7,'M007','C007'),
(8,'M008','C008'),
(9,'M009','C009'),
(10,'M010','C010');

--留言檢舉表
DROP TABLE IF EXISTS comment_report;

-- 插入表格
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

INSERT INTO comment_report (report_id, member_id, admin_id, comment_id, manage_type, close_time, report_message, report_reason, status) VALUES
('CR001','M001','A001','C001',1,NOW(),'這活動超爛，主辦方腦子進水了吧？','涉及人身攻擊，言語不當。',1),
('CR002','M002','A002','C002',0,NOW(),'這麼簡單的問題都不會解決？主辦方是智障嗎？','使用侮辱性詞語，對特定群體不尊重。',1),
('CR003','M003','A003','C003',1,NOW(),'這活動就是給某些特定人參加的吧？其他人滾遠點！','涉及排他性歧視，違反平等原則。',0),
('CR004','M004','A004','C004',0,NOW(),'某些族群的人還是別來了，根本不適合！','含有種族歧視或排擠特定群體的意味。',0),
('CR005','M005','A005','C005',1,NOW(),'這次活動已經取消了，大家不要去！','發布虛假資訊，可能影響活動正常進行。',1),
('CR006','M006','A006','C006',0,NOW(),'這活動其實有內定名額，一般人根本沒機會！','散播謠言，影響公平性認知。',1),
('CR007','M007','A007','C007',1,NOW(),'主辦方長得醜就別辦活動了，丟人現眼！','涉及外貌羞辱，屬於惡意騷擾。',0),
('CR008','M008','A001','C008',0,NOW(),'大家來點進這個連結，可以免費拿到獎品！http://freemoney-now.com','可能涉及詐騙或惡意連結攻擊。',0),
('CR009','M009','A002','C009',1,NOW(),'講師的水準跟小學生差不多，真是笑話！','貶低他人專業能力，帶有歧視意味。',1),
('CR010','M010','A003','C010',0,NOW(),'這活動根本不該讓某某國家的人參加，浪費名額！','包含國籍歧視，違反公平參與原則。',0);

