--Some Timezone Options
select top 100
t.ValidFrom as 'ValidToUTC'
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Eastern Standard Time' as datetime) as 'ValidFromEST'
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Central Standard Time' as datetime) as 'ValidFromCST'
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Mountain Standard Time' as datetime) as 'ValidFromMST'
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Pacific Standard Time' as datetime) as 'ValidFromPST'
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Alaskan Standard Time' as datetime) as 'ValidFromAlaska'
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Hawaiian Standard Time' as datetime) as 'ValidFromHawaii'
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time' as datetime) as 'ValidFromNewZealand'
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Central European Standard Time' as datetime) as 'ValidFromCentralEurope'
,t.ValidTo as 'ValidToUTC'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Eastern Standard Time' as datetime) as 'ValidToEST'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Central Standard Time' as datetime) as 'ValidToCST'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Mountain Standard Time' as datetime) as 'ValidToMST'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Pacific Standard Time' as datetime) as 'ValidToPST'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Alaskan Standard Time' as datetime) as 'ValidToAlaska'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Hawaiian Standard Time' as datetime) as 'ValidToHawaii'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time' as datetime) as 'ValidToNewZealand'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Central European Standard Time' as datetime) as 'ValidToCentralEurope'
,t.*
from History.Transactions t
order by t.CREATE_DATE desc



--Query From StartTime to EndTime with Local Time
declare @starttime datetime,
		@endtime datetime;

set @starttime = cast((cast(dateadd(minute, -5, getdate()) as datetime)  AT TIME ZONE 'Eastern Standard Time') AT TIME ZONE 'UTC' as datetime);
set @endtime = cast((cast(dateadd(minute, -2, getdate()) as datetime)  AT TIME ZONE 'Eastern Standard Time') AT TIME ZONE 'UTC' as datetime);

select
t.*
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Eastern Standard Time' as datetime) as 'ValidFromEST'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Eastern Standard Time' as datetime) as 'ValidToEST'
from Transactions
for system_time from @starttime to @endtime t
order by t.ID desc, t.ValidFrom desc




--Query the full record set
select
t.*
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Eastern Standard Time' as datetime) as 'ValidFromEST'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Eastern Standard Time' as datetime) as 'ValidToEST'
from Transactions
for system_time all t
order by t.ID desc, t.ValidFrom desc



--Query As Of Time with Local Time
declare @asoftime datetime;

set @asoftime = cast((cast(dateadd(minute, -2, getdate()) as datetime)  AT TIME ZONE 'Eastern Standard Time') AT TIME ZONE 'UTC' as datetime);

select
t.*
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Eastern Standard Time' as datetime) as 'ValidFromEST'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Eastern Standard Time' as datetime) as 'ValidToEST'
from Transactions
for system_time as of @asoftime t
order by t.ID desc, t.ValidFrom desc




--Find deleted records
select ht.*
from History.Transactions ht
left join Transactions t on ht.ID = t.ID
where t.ID is null
