## POSTGRESQL 时间函数总结

#### 1.timestamp

> ::timestamp ::date

#### 2.按小时、天筛选

> ```sql
> to_char( h.row_date, 'yyyy-MM-dd HH' ) AS row_date2
> GROUP BY  to_char( h.row_date, 'yyyy-MM-dd HH' )
> ```
>
> 先按格式获取然后筛选统计 
>
> --'yyyy-MM-dd HH:mm‘

#### 3.往前推指定日期

> **今日**
>
> ```sql
> select *  from "表名"
> where to_date("时间字段"::text,'yyyy-mm-dd')=current_date
> ```
>
> **昨日**
>
> ```sql
> select *  from "表名"
> where to_date("时间字段"::text,'yyyy-mm-dd')=current_date - 1
> ```
>
> **最近半个月**
>
> ```sql
> select *  from "表名"
> where to_date("时间字段"::text,'yyyy-mm-dd') BETWEEN current_date - interval '15 day'  AND current_date
> ```
>
> **最近6个月**
>
> ```sql
> `select` `*  ``from` `"表名"``where` `to_date(``"时间字段"``::text,``'yyyy-mm-dd'``) ``BETWEEN` `current_date` `- (``'6month '` `|| extract(``day` `from` `CURRENT_DATE``) -1 || ``' day'``)::interval  ``AND` `current_date`
> ```
>
> 说明：
>
> ```
> `extract(``day` `from` `CURRENT_DATE``) 提取当前时间的天数，因为查询最近六个月，比如现在2018年11月14日，查询的时间区间是`
> ```
>
> 　查询结果：2018-05-01 00:00:00

#### 4.EXTRACT 函数 

==extract （field from source）==

extract函数是从日期或者时间数值里面抽取子域，比如年、月、日等。source必须是timestamp、time、interval类型的值表达式。field是一个标识符或字符串，是从源数据中的抽取的域。--

> 等价于 date_part
>
> ```sql
> select extract (year from timestamp '2017-07-31 22:18:00');
> ```
>
> ```sql
> select date_part ('year' , timestamp '2017-07-31 22:18:00');
> ```
>
> day （本月的第几天） doy （本年的第几天）
>
> week （返回当前是几年的第几个周） dow （返回当前日期是周几，周日：0，周一：1，周二：2，...）
>
> ```sql
> select extract (dow from timestamp '2017-07-31 22:18:00');
> ```
>

#### 5 .获取当前日期的周一时间

```sql
SELECT  '2019-6-23'::date +cast(-1*(case when extract(dow from '2019-6-23'::date)=0 then 7 else extract(dow from '2019-6-23'::date) end -1) ||' days' as interval);
```

> 先获取当前日期周内序号，然后使用日期 interval相减
>
> ==dow== 周日是0！   下面是另一种表达

```sql
SELECT   to_char('2019-6-24'::timestamp +cast(-1*(TO_NUMBER(to_char('2019-6-24'::timestamp,'D'),'99')-2) ||' days' as interval),'yyyy-mm-dd');
```

>==‘D’==-- 一周里的日子(1-7；周日是1)
>select to_char(CURRENT_DATE  ,'D')
>
>DDD 一年里的日子(001-366)
>DD  一个月里的日子(01-31)
>D   一周里的日子(1-7；周日是1)
>
>select to_char (to_date('2016-06-12','yyyy-mm-dd'),'D')
>
>select to_number(‘1.1’,'9.99') from dual;
>1.1
>
>select to_number(‘1.121’,'9.99') from dual;
>
>1.12
>
>-- 将得到的字符串转换成数字
>select TO_NUMBER(to_char(CURRENT_DATE,'D'),'99')
>
>-- 因为得到的星期一为2，所以要减去2
>select TO_NUMBER(to_char(CURRENT_DATE,'D'),'99')-2
>
>-- 将得到的数字乘以 -1  比如例子中：-1*3  就是 -3  ，也就是减去 3天
>select cast(-1*3 || 'days' as interval) 
>
>-- 就是将当天减去0天 得到了星期一的日期

#### 6.获取当月一号

` select cast('2019-6'||'-01' as date)`

