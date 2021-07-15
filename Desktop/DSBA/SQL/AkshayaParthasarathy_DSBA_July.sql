# 7. Write a query to display carton id, (len*width*height) as carton_vol and identify the  optimum carton (carton with the least volume whose volume 
# is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, 
# Assume all items of an order are packed into one single carton (box).

select carton_id, (len * width * height) as carton_vol 
from carton 
having carton_vol > (select sum(len * width * height * product_quantity) as tot_vol
from product p 
inner join order_items o on p.PRODUCT_ID = o.PRODUCT_ID
where o.ORDER_ID = '10006')
order by carton_vol limit 1;

#  8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten 
# (i.e. total order qty) products per shipped order.

select c.customer_id, concat(c.customer_fname, ' ' ,c.customer_lname) as "Full_Name", o.ORDER_ID, sum(oi.PRODUCT_QUANTITY) as total_qty
from order_header o 
join order_items oi on (o.ORDER_ID = oi.ORDER_ID)
join online_customer c on (c.CUSTOMER_ID = o.CUSTOMER_ID)
where o.ORDER_STATUS = 'Shipped'
group by oi.ORDER_ID
having total_qty > 10;

# 9. Write a query to display the order_id, customer id and cutomer full name of customers along with (product_quantity) as total quantity
# of products shipped for order ids > 10060.

select o.order_id, c.customer_id, concat(c.customer_fname, ' ' ,c.customer_lname) as "Full_Name", sum(oi.product_quantity) as total_qty
from order_header o 
left join order_items oi on (o.ORDER_ID = oi.ORDER_ID)
left join online_customer c on (c.CUSTOMER_ID = o.CUSTOMER_ID)
where o.ORDER_STATUS = 'Shipped' and o.ORDER_ID > '10060'
group by oi.order_id;

# 10. Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) 
# and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? 
# Also show the total value of those items

select p.PRODUCT_CLASS_CODE, pc.product_class_desc, sum(o.product_quantity) as total_qty, sum(o.product_quantity * p.product_price) as total_value
from product p
inner join order_items o on o.PRODUCT_ID = p.PRODUCT_ID
inner join product_class pc on p.PRODUCT_CLASS_CODE = pc.PRODUCT_CLASS_CODE
inner join order_header oh on o.ORDER_ID = oh.ORDER_ID
inner join online_customer oc on oc.CUSTOMER_ID = oh.CUSTOMER_ID
inner join address a on oc.ADDRESS_ID = a.ADDRESS_ID
where oh.ORDER_STATUS = 'Shipped' and a.COUNTRY not in ('India','USA')
group by pc.product_class_desc
order by total_qty desc limit 1;










