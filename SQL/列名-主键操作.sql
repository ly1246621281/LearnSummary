DESCRIBE ext_ct_calltraceinfo_temp;
<-- 添加列 -->
ALTER TABLE ext_ct_calltraceinfo_temp ADD COLUMN xx VARCHAR(10);
-- 删除列 --
ALTER TABLE ext_ct_calltraceinfo_temp DROP COLUMN xx;
<-- 修改列名 -->
ALTER TABLE ext_ct_calltraceinfo_temp CHANGE COLUMN xx x_x INT;
-- 修改列属性 --
ALTER TABLE ext_ct_calltraceinfo_temp MODIFY COLUMN x_x VARCHAR(10);

SHOW CREATE TABLE ext_ct_calltraceinfo_temp;

SHOW INDEX FROM ext_ct_calltraceinfo_temp;
ALTER  TABLE ext_ct_calltraceinfo_temp ADD INDEX `index` (`eNodeB ID`,`Cell ID`) ;

ALTER TABLE ext_ct_calltraceinfo_temp DROP INDEX `index`;


添加主键约束：alter TABLE 表名 ADD CONSTRAINT 主键 （形如：PK_表名） PRIMARY KEY 表名(主键字段);       ALTER TABLE 表名 ADD PRIMARY KEY(列1,列2....);  
添加外键约束：alter TABLE 从表 ADD CONSTRAINT 外键（形如：FK_从表_主表） FOREIGN KEY 从表(外键字段) REFERENCES 主表(主键字段);
删除主键约束：alter TABLE 表名 DROP PRIMARY KEY;

DESC xml_template

ALTER TABLE xml_template ADD  PRIMARY KEY (`id`);
ALTER TABLE xml_template DROP PRIMARY KEY;