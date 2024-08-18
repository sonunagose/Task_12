create table report_table(
	product_id varchar primary key,
	sum_of_sales float,
	sum_of_profit float
)

create or replace function update_product_report()
RETURNS Trigger as $$
declare
       sumOFSales float;
       sumOfProfit float;
       count_report int;
Begin 
    select sum(sales),sum(profit) into sumOfSales,sumOfProfit from sales
    where product_id = New.product_id;

select count(*) into count_report from report_table where product_id = NEW.product_id;

if count_report = 0 then
insert into report_table values (NEW.product_id, sumOfSales, sumOfProfit);
else

   update Report_Table set  sum_of_sales = sumOfSales, sum_of_profit = sumOfProfit
	where  product_id=NEW.product_id;
end if;
Return NEW;

END
$$ LANGUAGE plpgsql

create trigger update_report_trigger
After insert on sales
for each row 
Execute function update_product_report()
