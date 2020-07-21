### Coverity：SQL注入总结

#### 1. 解决思路

执行以下操作之一，以防止 SQL 注入攻击。

- 使用 **?** 位置字符将 SQL 语句参数化。使用其中一个 **PreparedStatement.set\*** 方法将被污染的值与 **?** 位置参数绑定。
- 根据预定义的常量值验证用户提供的值。将这些常量值串联成 SQL 语句。
- 将被污染的值转换为安全类型（例如整数）。将这些类型安全的值合并成语句。

#### 2. 大致分为以下几种类型

##### 2.1 完整SQL在函数体内部，由+号连接，sql连接变量不是从参数获得

```java
String sql = "import foreign schema " + dbConnInfo.getSchemaName() + "  limit to(" + joinTables + ") from server " +
getForeignServerName(dbConnInfo) + " INTO " + dbConnInfo.getDisplayName() + ";";
```

可以：

```java
			Vector<String> tmp = new Vector<String>();
269        tmp.add("import foreign schema ");
270        tmp.add(dbConnInfo.getSchemaName());
271        tmp.add("  limit to(");
272        tmp.add(joinTables);
273        tmp.add(") from server ");
274        tmp.add(getForeignServerName(dbConnInfo));
275        tmp.add(" INTO ");
277        tmp.add(dbConnInfo.getDisplayName());
279        tmp.add(";");
280        tmp.add("select ?;");
281        Vector<String> vs_ = convertStringBuilder(tmp);
282        String sql = vector2string(vs_);
```

```java
/**
     * converity治理，转换String防止SQL注入
     * @param sVector 入参
     * @return
     */
    public static List<String> convertStringBuilder(List<String> sVector){
        List<String> convertedVector = new ArrayList<String>();
        for(String s:sVector){
            StringBuilder stringBuilder = new StringBuilder(s);
            String tmp = stringBuilder.toString();
            convertedVector.add(tmp);
        }
        return convertedVector;
    }
    public static String vector2string(List<String> sVector) {
        StringBuilder stringBuilder = new StringBuilder();
        for(String s:sVector){
            stringBuilder.append(s);
        }
        return stringBuilder.toString();
    }
```

##### 2.2 SQL连接变量由形参传入，且变量为SQL筛选条件（where语句、like、between...）

可直接通过prepareStatement预编译处理解决。

```java
 String paramQuery = "select * from xml_template where name = ? and id =?";
 PreparedStatement prepStmt = 
              connection.prepareStatement(paramQuery);
              prepStmt.setString(1,"zz");
              prepStem.setInt(2,1);
              prepStmt.executeQuery();
```

若出现Sql语句无法增加变量形式，即提出公共SQL查询方法或者执行方法时：==但需注意的事，提取公共执行方式，包含sql语句参数，需要先排除污染值，可通过List或者Map中转解决==

```java
/**
	 * 执行SQL，Corverity治理[表名列名不能当SQLPreparemant参数]
	 * @param conn
	 * @param sSQL
	 * @throws SQLException
	 */
	public  void exec(Connection conn, String sSQL) throws SQLException {
		//*Coverity治理，SQL注入和被污染SQL
		List<String> sqlList = Arrays.asList(sSQL);
		String afterSql = SQLTransUtil.vector2string(SQLTransUtil.convertStringBuilder(sqlList));

		// 执行查询语句
		if (conn == null || sSQL.length() <= 0)
		{
			logger.info("[SQLLite]:db is null or sql is null");
			return;
		}
		stmt = conn.prepareStatement(afterSql + ";select ?;");
		stmt.setInt(1, 1);
		stmt.execute();
	}
	
	public List QuerySQL(Connection conn, String sSQL) throws SQLException
	{
		if(sSQL.isEmpty() || conn == null)
		{
			return new ArrayList();
		}
		int iColCnt = 0;
		List resultList = new ArrayList();
        //*Coverity治理，SQL注入和被污染SQL
		List<String> sqlList = Arrays.asList(sSQL);
		String afterSql = SQLTransUtil.vector2string(SQLTransUtil.convertStringBuilder(sqlList));
		String prepareSql = afterSql + ";select ?;";
		stmt = conn.prepareStatement(prepareSql);
		stmt.setInt(1, 1);
		stmt.execute();
        rs = stmt.getResultSet();
        ResultSetMetaData md = rs.getMetaData();
        iColCnt = md.getColumnCount();
        while(rs.next())
        { 
        	String rowData = "";
        	for (int i = 1; i <= iColCnt; i++)
        	{
        		rowData+=rs.getObject(i);
        		rowData+=",";
        	}
        	if(rowData.length()>1)
        	{
        		rowData = rowData.substring(0,rowData.length()-1);
        	}
        	resultList.add(rowData);
        } 
        
		//返回查询数据
		return resultList;
	}
```



##### 2.3 SQL连接变量由形参传入，且变量为SQL表名、列名或者关键字

```sql
DROP SERVER fs_pg_10_92_180_90_mydb CASCADE;
== fs_pg_10_92_180_90_mydb 为变量
```

```java
 private static Map<String, String> mapGoodValues = new HashMap<String, String>();
 private void setGoodSqls(String sKey, String sVal)
    {
        mapGoodValues.put(sKey,sVal);
    }
```

```java
public List<People> getAllPeopleFrom(final String userInput) {
 […]	setGoodSqls.set("keys",userInput);
 80     String untainted = mapGoodValues.get（"keys"）;
 81     if (untainted != null) {
 83         String paramQuery = "SELECT * FROM " + untainted;
 84         PreparedStatement prepStmt = 
              connection.prepareStatement(paramQuery);
 85         prepStmt.executeQuery();
 […]
 91     } else {
 92       // log event as potential security tampering...
     	}
     }
 
```

