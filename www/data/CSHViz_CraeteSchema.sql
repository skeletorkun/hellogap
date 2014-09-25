
------------ create list "Mktg":["Europe.AF","Europe.BA","Europe.AY","NorthAmerica.QF",] ----------------------------------------

--CREATE GLOBAL TEMPORARY TABLE mktgLists ( Optg char(100) NOT NULL, mktgs char(3000) NOT NULL) ON COMMIT preserve rows
AS

--insert into mktgLists
CREATE VIEW mktgLists
AS
SELECT optg
	,STUFF((
			SELECT '", "' + mktg
			FROM AGreements a
			WHERE b.optg = a.optg
			FOR XML PATH('')
			), 1, 1, '') mktgs
FROM agreements b
GROUP BY optg;

------------ 4/  select total optg :  NorthAmerica.UA        58322 ------------------------------------------------------------------------
--CREATE GLOBAL TEMPORARY TABLE optgTotal ( Optg char(100) NOT NULL, total INT  NOT NULL) ON COMMIT preserve rows
--AS
  --insert into optgTotal
CREATE VIEW OptgTotal
AS
SELECT LTRIM(RTRIM(con.continent)) + '.' + LTRIM(RTRIM(con.country)) + '.' + LTRIM(RTRIM(con.NAME)) + '.' + LTRIM(RTRIM(res.optg)) AS optg
	,res.total
FROM (
	SELECT amadeusAirlines.airline AS optg
		,COUNT(*) AS total
	FROM PersWithRoutes perRoutes
	RIGHT JOIN amadeusAirlines ON perRoutes.OPTG_CARRIER_CODE = amadeusAirlines.airline
	GROUP BY amadeusAirlines.airline
	) res
LEFT JOIN ContinentCountryNameAirline con ON res.optg = con.AIRLINE;
   
--------------4/ Flatten periods to get agreements on unique origin-dest pairs --------------------------
  
CREATE VIEW UniquePersPerRoutes
AS
SELECT MKTG_CARRIER_CODE
	,OPTG_CARRIER_CODE
	,ORIGIN
	,DESTINATION
	,count(*) AS total
FROM PersWithRoutes per
GROUP BY MKTG_CARRIER_CODE
	,OPTG_CARRIER_CODE
	,ORIGIN
	,DESTINATION
--ORDER BY total DESC
  
--------------4/ Flatten legs and periods table to get periods with routes --------------------------
CREATE VIEW PersWithRoutes
AS
SELECT per.START_DATE
	,per.END_DATE
	,per.DAYS_OF_OPERATION
	,per.CSH_FLIGHT_PERIOD_ID
	,per.MKTG_LINE_NUMBER
	,per.MKTG_CARRIER_CODE
	,per.OPTG_CARRIER_CODE
	,per.OPTG_LINE_NUMBER
	,leg.ORIGIN
	,leg.DESTINATION
FROM periods per
LEFT JOIN legs leg ON per.CSH_FLIGHT_PERIOD_ID = leg.CSH_FLIGHT_PERIOD_ID;

--------------3/ unique pairs Optg & Mktg : Europe.Germany.Pegasus Airlines.PS    Europe.Germany.Unique Airlines.U6 ----------------------------------------
--CREATE TABLE links ( Optg char(100) NOT NULL, Mktg char(100) NOT NULL) 
-- delete from links
--insert into Agreements (optg, mktg) from
 CREATE VIEW Agreements
AS
SELECT DISTINCT LTRIM(RTRIM(c1.continent)) + '.' + LTRIM(RTRIM(c1.country)) + '.' + LTRIM(RTRIM(c1.NAME)) + '.' + LTRIM(RTRIM(OPTG_CARRIER_CODE)) AS optg
	,LTRIM(RTRIM(c2.continent)) + '.' + LTRIM(RTRIM(c2.country)) + '.' + LTRIM(RTRIM(c2.NAME)) + '.' + LTRIM(RTRIM(MKTG_CARRIER_CODE)) AS mktg
FROM Periods per
LEFT JOIN ContinentCountryNameAirline AS c1 ON per.OPTG_CARRIER_CODE = c1.AIRLINE
LEFT JOIN ContinentCountryNameAirline AS c2 ON per.MKTG_CARRIER_CODE = c2.AIRLINE;

------------- 2/ 1A total airline list  -------------------------------------------------------------
CREATE VIEW AmadeusAirlines
AS
SELECT airline
FROM
	--insert airlines into amadeusAirlines from
	(
	SELECT DISTINCT (Periods.opTG_CARRIER_CODE) AS airline
	FROM Periods
	
	UNION
	
	SELECT DISTINCT (Periods.MKTG_CARRIER_CODE) AS airline
	FROM Periods
	) AS airline
  
-------------1/ Asia, South Korea, Korean Airlines, SQ -------------------------------------------------------------
CREATE TABLE ContinentCountryNameAirline (
	Continent CHAR(50) NOT NULL
	,Country CHAR(50) NOT NULL
	,NAME CHAR(50) NOT NULL
	,Airline CHAR(2) NOT NULL
	,UNIQUE (
		Country
		,Airline
		)
	);