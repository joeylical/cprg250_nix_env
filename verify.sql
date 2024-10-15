rem lab0test.sql
set echo on
set verify on
set pagesize 66
set linesize 132
spool /host/justLeeOutput.txt
rem Just Lee Database

rem show customers and books they have ordered
rem should return 32 rows
select firstname, lastname, title
from customers natural join orders
   natural join orderitems 
   natural join books
order by 2,1,3;

rem check Really Cheap Vacations DBA
select first_name, last_name, tour_description
from rcv_customer join rcv_tour_customer using (customer_number)
    join rcv_vacation_tour using (tour_code)
order by 1,2;

spool off
