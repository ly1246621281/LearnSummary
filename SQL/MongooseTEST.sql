-- CHART
SELECT * FROM (
SELECT 1 AS NAME, 20 AS VALUE, 20 AS PDF, 20 AS CDF 
UNION 
SELECT 2 AS NAME, 10 AS VALUE, 10 AS PDF, 30 AS CDF 
UNION 
SELECT 3 AS NAME, 30 AS VALUE, 30 AS PDF, 60 AS CDF 
UNION 
SELECT 4 AS NAME, 5 AS VALUE, 5 AS PDF, 65 AS CDF  
UNION 
SELECT 5 AS NAME, 35 AS VALUE, 35 AS PDF, 100 AS CDF) t;

-- SQL
SELECT * FROM xml_test;
INSERT INTO xml_test VALUES(1,'dd');

 DROP TABLE IF EXISTS test_table;
		
-- GIS	01	
		SELECT * FROM 
		( SELECT 731850 AS enobid, 3 AS cellid, 10 AS dd
		UNION 
		SELECT 731850 AS enobid, 1 AS cellid, 200 AS kd
		UNION 
		SELECT 600868 AS enodebid, 129 AS cellid, 600 AS kpiname
		UNION 
		SELECT 405956 AS enodebid, 2 AS cellid, 1100 AS kpiname
		UNION 
		SELECT 730658 AS enodebid, 4 AS cellid, 8800 AS kpiname
		) t;
SELECT 'ENODEBID','CELLID','PointLon','PointLat','PointState','CellState','AuxValue' UNION SELECT * FROM ( SELECT 731850 AS enobid, 3 AS cellid, 121.40951100 AS LON,29.14675100 AS LAT, 10 AS kpiname, 20 AS CELLSTATE, "001" UNION SELECT 731850 AS enobid, 1 AS cellid,121.40951100 AS LON,29.14675100 AS LAT, 200 AS kpiname,200 AS CELLSTATE, "002" UNION SELECT 600868 AS enodebid, 129 AS cellid,121.40951100 AS LON,29.14675100 AS LAT, 600 AS kpiname,2000 AS CELLSTATE, "003" UNION SELECT 405956 AS enodebid, 2 AS cellid,121.40951100 AS LON,29.14675100 AS LAT, 1100 AS kpiname,1000 AS CELLSTATE, "004" UNION SELECT 730658 AS enodebid, 4 AS cellid,121.40951100 AS LON,29.14675100 AS LAT, 8800 AS kpiname,2000 AS CELLSTATE, "005" ) t;
-- GIS 02
 SELECT * FROM earthidxy_testdata;
		
-- GIS 03		
SELECT 'ENODEBID','CELLID','PointLon','PointLat','Project16_06_grid_chart_gis_GIS16_xml03','Project16_06_grid_chart_gis_GIS16_xml03','AuxValue' UNION 
SELECT * FROM 
		( SELECT 731850 AS enobid, 3 AS cellid, 121.40951100 AS LON,29.14675100 AS LAT, 10 AS kpiname, 20 AS CELLSTATE, "001" 
		UNION 
		SELECT 731850 AS enobid, 1 AS cellid,121.40951100 AS LON,29.14675100 AS LAT, 200 AS kpiname,200 AS CELLSTATE, "002"
		UNION 
		SELECT 600868 AS enodebid, 129 AS cellid,121.40951100 AS LON,29.14675100 AS LAT, 600 AS kpiname,2000 AS CELLSTATE, "003"
		UNION 
		SELECT 405956 AS enodebid, 2 AS cellid,121.40951100 AS LON,29.14675100 AS LAT, 1100 AS kpiname,1000 AS CELLSTATE, "004"
		UNION 
		SELECT 730658 AS enodebid, 4 AS cellid,121.40951100 AS LON,29.14675100 AS LAT, 8800 AS kpiname,2000 AS CELLSTATE, "005"
		) t;
		
-- gis04		
SELECT * FROM 
		( SELECT 731850 AS enobid, 3 AS cellid, 731889 AS enobid2,2 cellid2,20 AS kpiname
		UNION 
		SELECT 731850 AS enobid, 1 AS cellid, 731889 AS enobid2,2 cellid2, 200 AS kpiname
		UNION 
		SELECT 600868 AS enodebid, 129 AS cellid, 731889 AS enobid2,2 cellid2, 600 AS kpiname
		UNION 
		SELECT 405956 AS enodebid, 2 AS cellid, 731889 AS enobid2,2 cellid2, 1100 AS kpiname
		UNION 
		SELECT 730658 AS enodebid, 4 AS cellid, 731889 AS enobid2,2 cellid2, 8800 AS kpiname
		) t;
		
		SELECT 'EarthID','XOffSet','YOffSet','Project18_gis_chart_GIS18_xml01' UNION SELECT a.* FROM earthidxy_testdata a;
		SELECT a.*,b.id FROM earthidxy_testdata a LEFT JOIN xml_test b HAVING a.earthid=b.id ;
		SELECT a.*,a.earthid FROM earthidxy_testdata a;
		
		 SELECT a.`EarthID`,a.`XOffset`,a.`YOffset`,a.`EarthID` AS Project18_gis_chart_GIS18_xml01 FROM earthidxy_testdata a;
		
		
		
		