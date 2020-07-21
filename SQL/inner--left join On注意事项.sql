SELECT * FROM A INNER JOIN B ON A.name = B.name;
SELECT * FROM A LEFT JOIN B ON A.name = B.name;
             
             
             <-- left join || right join   `ON` 关键字是必不可少的 ，如果有where筛选  也需要放在On后面  -->
             SELECT * FROM ext_ct_calltraceinfo a LEFT JOIN ext_cdt_uecapabilityinfo b ON a.Millisec= 483  WHERE a.`eNodeBID`=b.`eNodeBID` 
	     s
	     SELECT * FROM ext_ct_calltraceinfo a INNER JOIN ext_cdt_uecapabilityinfo b  WHERE a.`eNodeBID`=b.`eNodeBID` 
             