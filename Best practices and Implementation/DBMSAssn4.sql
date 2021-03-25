use storefront;


drop function if exists calcOrders;
DELIMITER $$ 

CREATE FUNCTION calcOrders(month int,year int) 
returns int deterministic 
begin
    DECLARE result int;
    set result=0;
    select count(o.o_id) into result from orders o where extract(year from o.time)=year and extract(month from o.time)=month;
    return result;
end; $$
DELIMITER ;


SELECT calcOrders(03,2018);




drop function if exists getOrders;
DELIMITER $$
CREATE function getOrders(year int) returns int deterministic
begin
declare month int;
select max.maxMonth into month from(select count(o.time) as count,month(o.time) as maxMonth from orders o where extract(year from o.time)=year group by month(o.time))max order by max.count desc limit 1;
return month;
end; $$
DELIMITER ;

select getOrders(2018);



drop procedure if exists averageMonthSales;
DELIMITER $$
create procedure averageMonthSales(month int,year int)
begin
select p.p_id,p.p_name,o.time,sum(o.amt) from orders o join product p on o.o_id=p.p_id where month(o.time)=month and year(o.time)=year group by p.p_id;
end; $$
DELIMITER ;
call averageMonthSales(03,2018);






drop procedure if exists ordersDetails;
DELIMITER $$
create procedure ordersDetails(startDate date,endDate date)
begin
select p.p_name,o.status from orders o join product p where o.o_id=p.p_id and o.time between startDate and endDate;
end; $$
DELIMITER ;
call ordersDetails('2018-03-01','2025-12-10');
