# Association Rule Mining
What is the most frequently bought item with Infant Formula and Infant Diapers? Association Rule Mining is a key to Market Basket Analysis. While Association Rule Mining is a complex topic, here is a MATCH_RECOGNIZE with a Recursive CTE query to figure out what items most frequently bought together. 


Order Data:
```sql
select order_number, listagg(item, ', ') from orders
group by 1;
```

| ORDER_NUMBER | LISTAGG(ITEM, ', ')                                       |
|--------------|-----------------------------------------------------------|
| 3            | infant formula, infant diaper, coffee, coke               |
| 7            | infant formula, infant diaper, moutnain dew, coke, coffee |
| 1            | bread, infant formula                                     |
| 4            | bread, infant formula, infant diaper, coffee              |
| 6            | infant formula, infant diaper, moutnain dew               |
| 5            | infant formula, infant diaper, coke                       |
| 2            | bread, infant diaper, coffee, eggs                        |


# MATCH_RECOGNIZE for Market Basket Analysis
```sql
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

| THIRD_ITEM   | FREQUENCY |
|--------------|-----------|
| moutnain dew | 2         |
| coke         | 3         |
| coffee       | 3         |
| bread        | 1         |
