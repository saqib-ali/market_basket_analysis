
create or replace table orders(order_number number, item string) ;

insert into orders values 
  (1, 'bread')
  , (1, 'infant formula') 
  , (2, 'bread') 
  , (2, 'infant diaper') 
  , (2, 'coffee') 
  , (2, 'eggs') 
  , (3, 'infant formula') 
  , (3, 'infant diaper') 
  , (3, 'coffee' ) 
  , (3, 'coke') 
  , (4, 'bread') 
  , (4, 'infant formula' ) 
  , (4, 'infant diaper') 
  , (4, 'coffee') 
  , (5, 'infant formula') 
  , (5, 'infant diaper') 
  , (5, 'coke')
  , (6, 'infant formula') 
  , (6, 'infant diaper') 
  , (6, 'moutnain dew')
  , (7, 'infant formula') 
  , (7, 'infant diaper') 
  , (7, 'moutnain dew')
  , (7, 'coke') 
  , (7, 'coffee') 
 ;
  
select distinct item from orders;


select * from orders;

select order_number, listagg(item, ', ') from orders
group by 1
;

set use_cached_results = false ;

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
