What is the most frequently bought item with Infant Formula and Infant Diapers? Association Rule Mining is a key to Market Basket Analysis. While Association Rule Mining is a complex topic, here is a MATCH_RECOGNIZE with a Recursive CTE query to figure out what items most frequently bought together. 

Order Data:
```
select order_number, listagg(item, ', ') from orders
group by 1;
```

![image](https://user-images.githubusercontent.com/9682332/209955633-265c2fe7-4fb1-48be-bf37-957e0687dc2b.png)


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

Query output:
![image](https://user-images.githubusercontent.com/9682332/209955806-5fd762fe-27d0-4b3c-8335-bd740961f236.png)
