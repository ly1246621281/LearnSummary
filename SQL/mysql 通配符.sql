-- 通配符—_ 代表任意一个字符or 汉字 %代表任意个或零个字符
-- 若_ 或者%为本意字符 则转义  使用 escape '指定的字符'。

SELECT * FROM cellselected_temp WHERE mcc LIKE '_!_1_'  ESCAPE '!';