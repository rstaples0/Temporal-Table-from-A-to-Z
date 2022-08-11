declare @starttime datetime,
		@endtime datetime;

set @starttime = cast((cast('2019-01-01 00:00:00' as datetime)  AT TIME ZONE 'Eastern Standard Time') AT TIME ZONE 'UTC' as datetime);
set @endtime = cast((cast('2019-02-01 00:00:00' as datetime)  AT TIME ZONE 'Eastern Standard Time') AT TIME ZONE 'UTC' as datetime);

select
t.*
,cast((t.ValidFrom  AT TIME ZONE 'UTC') AT TIME ZONE 'Eastern Standard Time' as datetime) as 'ValidFromEST'
,cast((t.ValidTo  AT TIME ZONE 'UTC') AT TIME ZONE 'Eastern Standard Time' as datetime) as 'ValidToEST'
from Transactions
for system_time from @starttime to @endtime t
order by t.ID desc, t.ValidFrom desc
