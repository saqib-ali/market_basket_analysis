# Association Rule Mining
What is the most frequently bought item with Infant Formula and Infant Diapers? Association Rule Mining is a key to Market Basket Analysis. While Association Rule Mining is a complex topic, here is a MATCH_RECOGNIZE with a Recursive CTE query to figure out what items most frequently bought together. 


Order Data:
```
select order_number, listagg(item, ', ') from orders
group by 1;
```
![image](https://user-images.githubusercontent.com/9682332/209956032-ec19cb2c-1826-4ffc-bec0-e65e04003e62.png)


# MATCH_RECOGNIZE query 
```
with recursive r(n, order_number, item) as (
    select 1, order_number, item from orders
    union all
    select n+1, order_number, item from r where n <= 100
)
select third_item, count(distinct order_number) as frequency 
from r
match_recognize (
    partition by order_number  order by n
    measures
      item3.item as third_item
    after match skip to next row
    pattern (permute(item1, item2, item3*))
    define item1 as item = 'infant diaper'
    , item2 as item = 'infant formula'
    , item3 as item not in ('infant formula', 'infant diaper')
)
where third_item is not null
group by third_item;
```

Frequency of items bought together with Infant Formula and Infant Diapers:
![image](https://user-images.githubusercontent.com/9682332/209956337-446a56dc-1574-4ff6-a90e-aa79b4eaf155.png)
