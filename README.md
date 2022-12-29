What is the most frequently bought item with Infant Formula and Infant Diapers? Association Rule Mining is a key to Market Basket Analysis. While Association Rule Mining is a complex topic, here is a MATCH_RECOGNIZE with a Recursive CTE query to figure out what items most frequently bought together. 

Order Data:
```
select order_number, listagg(item, ', ') from orders
group by 1;
```

![image](https://user-images.githubusercontent.com/9682332/209955633-265c2fe7-4fb1-48be-bf37-957e0687dc2b.png)
