select * from Periods
select * from ContientCountry;
select * from ContinentCountryNameAirline where ContinentCountryNameAirline.Airline = '6X';
select * from AMADEUSAIRLINES where airlines='6X';
select * from links where mktg = '.SS';
select * from mktgLists where OPTG like '%DL%';
select * from optgTotal where OPTG like '%DL%';
select distinct(OPTG_CARRIER_CODE) from  amadeusAirlines order by OPTG_CARRIER_CODE asc;


declare @carriers varchar(1000)
declare @optg varchar(2)
declare @mktg varchar(2)
set @carriers = 'AA,AF,AM,AV,BA,DL,KL,LH,LY,OS,OZ,QF,QR,SA,SK,TP,UA,US,UX'
declare @i int = 0
declare @j int

declare @sql varchar(1000)
set @sql = 'select  p.OPTG_CARRIER_CODE ,p.MKTG_CARRIER_CODE, CAST(count(*)  as varchar(5)) 
		from PersWithRoutes p 
		where OPTG_CARRIER_CODE = ' + @optg + ' and MKTG_CARRIER_CODE = ' + @mktg;


while CHARINDEX(',', @carriers, @i+1)>0
begin
	set @optg = SUBSTRING(@carriers, @i, 2)
	set @j = 0
	while CHARINDEX(',', @carriers, @j+1)>0
	begin
		set @mktg = SUBSTRING(@carriers, @j, 2)
		--exec @sql @optg, @mktg
		PRINT 'optg: '+ @optg + ' mktg: ' + @mktg
		set @j = CHARINDEX(',', @carriers, @j+2) + 1
	end
    set @i = CHARINDEX(',', @carriers, @i+2) + 1
end

select 'insert into crosstable values (''' + p.OPTG_CARRIER_CODE + ''','''+ p.MKTG_CARRIER_CODE +''',' + CAST(count(*)  as varchar(5)) + ');'
--select top 20 p.OPTG_CARRIER_CODE, MKTG_CARRIER_CODE
from PersWithRoutes p 
where p.OPTG_CARRIER_CODE in ('AA','AF','AM','AV','BA','DL','KL','LH','LY','OS','OZ','QF','QR','SA','SK','TP','UA','US','UX') 
and p.MKTG_CARRIER_CODE in ('AA','AF','AM','AV','BA','DL','KL','LH','LY','OS','OZ','QF','QR','SA','SK','TP','UA','US','UX')
group by p.OPTG_CARRIER_CODE, p.MKTG_CARRIER_CODE
order by count(*)  desc 

create table crosstable ( optg varchar(2) , mktg varchar(2), total int, CONSTRAINT pk PRIMARY KEY (optg, mktg))
drop table crosstable	

delete from crosstable
select '"' + optg + '","' + mktg + '",' + cast(total as varchar(7))  from crosstable
select * from crosstable order by optg, mktg asc
------------------------------------------------------------------------------------------------------------------------------------------------


select distinct(mktg)
  from links where not exists (select distinct optg from links) order by mktg asc;
  
  
select count ( distinct mktg)  from links; -- 511, 491
select count ( distinct optg)  from links; -- 226

select distinct mktg from links where mktg not in (select  optg from links ); --375, 354
select  distinct optg from links where optg not in (select  mktg from links ); --?, 89
select count (distinct mktg) from links where mktg  in (select  optg from links );    -- 90, 137
select count (distinct optg) from links where optg  in (select  mktg from links );    -- ?, 137

---------------------------{"optg":"America.VE","count":204,"mktgs":["Europe.AF", ""Europe.AZ"]},----------------------------------

SELECT count(*) 
FROM mktgLists
RIGHT JOIN optgTotal ON mktgLists.optg = optgTotal.OPTG;
