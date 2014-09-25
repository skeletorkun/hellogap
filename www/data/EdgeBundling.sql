select * from Periods
select * from ContientCountry;
select * from ContinentCountryNameAirline where ContinentCountryNameAirline.Airline = '6X';
select * from AMADEUSAIRLINES where airlines='6X';
select * from links where mktg = '.SS';
select * from mktgLists where OPTG like '%DL%';
select * from optgTotal where OPTG like '%DL%';
select distinct(OPTG_CARRIER_CODE) from  amadeusAirlines order by OPTG_CARRIER_CODE asc;



--delete from links;
--delete from mktgLists;
--delete from optgTotal;
--delete from amadeusAirlines;
---delete from ContinentCountryNameAirline;

--drop table links;
--drop table mktgLists;
--drop table optgTotal;
--drop table amadeusAirlines;
--drop table ContinentCountryNameAirline;

select distinct optg from links order by optg asc;

select distinct(mktg)
  from links where not exists (select distinct optg from links) order by mktg asc;
  
  
select count ( distinct mktg)  from links; -- 511, 491
select count ( distinct optg)  from links; -- 226

select distinct mktg from links where mktg not in (select  optg from links ); --375, 354
select  distinct optg from links where optg not in (select  mktg from links ); --?, 89
select count (distinct mktg) from links where mktg  in (select  optg from links );    -- 90, 137
select count (distinct optg) from links where optg  in (select  mktg from links );    -- ?, 137

---------------------------{"optg":"America.VE","count":204,"mktgs":["Europe.AF", ""Europe.AZ"]},----------------------------------
CREATE VIEW finalJson
AS
SELECT '{"name":"' + optgTotal.optg + '",size:' + CAST(optgTotal.total AS VARCHAR(10)) + ',"mktgs":["' + mktgLists.mktgs + '"]},' jsonText

SELECT count(*)
FROM mktgLists
RIGHT JOIN optgTotal ON mktgLists.optg = optgTotal.OPTG;
