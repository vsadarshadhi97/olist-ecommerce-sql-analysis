-- ============================================
-- QUERY 1: TABLE RECORD COUNT VALIDATION
-- ============================================

select 
	'customers' as table_name, 
	count(*) 
from customers

union all

select 
	'sellers',
	count(*)
from sellers

union all

select 
	'products',
	count(*)
from products

union all

select 
	'orders',
	count(*)
from orders

union all

select 
	'order_items',
	count(*)
from order_items

union all

select 
	'order_payments',
	count(*)
from order_payments

union all

select 
	'order_reviews',
	count(*)
from order_reviews

union all

select 
	'geolocation',
	count(*)
from geolocation

union all

select 
	'category_translation',
	count(*)
from product_category_translation;



-- ============================================
-- QUERY 2: DUPLICATE RECORD VALIDATION
-- ============================================

--Customers
select 
	'customers' as table_name,
	count(*) as duplicate_records
from(
	select 
		customer_id from customers
	group by customer_id
	having count(*)>1
) as duplicates

union all

--Sellers
select 
	'sellers', count(*)
from(
	select 
		seller_id from sellers
	group by seller_id
	having count(*)>1
) as duplicates

union all

--Products
select 
	'products',
	count(*)
from(
	select 
		product_id from products
	group by product_id
	having count(*)>1
)as duplicates

union all

-- Orders
select
    'orders',
    count(*)
from (
    select
		order_id
    from orders
    group by order_id
    having count(*) > 1
)as duplicates;


-- ============================================
-- QUERY 3: NULL VALUE VALIDATION
-- ============================================

select 
	'customers.customer_id' as column_name,
	count(*) filter(where customer_id is null) as null_count
from customers

union all

select 
	'customers.customer_state', 
	count(*) filter (where customer_state is null) 
from customers

union all

select
    'orders.customer_id',
    count(*) filter (where customer_id is null)
from orders

union all

select 
    'orders.order_purchase_timestamp',
    count(*) filter (where order_purchase_timestamp is null)
from orders

union all

select
    'order_items.product_id',
    count(*) filter (where product_id is null)
from order_items

union all

select 
    'order_items.seller_id',
    count(*) filter (where seller_id is null)
from order_items

union all

select
    'order_items.price',
   	count(*) filter (where price is null)
from order_items

union all

select
    'order_payments.payment_value',
    count(*) filter (where payment_value is null)
from order_payments

union all

select
    'order_reviews.review_score',
    count(*) filter (where review_score is null)
from order_reviews;


-- ============================================
-- QUERY 4: REFERENTIAL INTEGRITY VALIDATION
-- ============================================

-- Orders without a matching customer
select 
count(*) as orders_without_customer
from orders o
left join customers c
on o.customer_id=c.customer_id
where c.customer_id is null;

-- Order items without a matching product
select 
count(*) as items_without_products
from order_items oi
left join products p
on oi.product_id=p.product_id
where p.product_id is null;

-- Order items without a matching seller
select 
count(*) as items_without_seller
from order_items oi
left join sellers s
on oi.seller_id=s.seller_id
where s.seller_id is null;

-- Payments without a matching order
select
count(*) as payments_without_order
from order_payments op
left join orders o
on op.order_id=o.order_id
where o.order_id is null;

-- Reviews without a matching order
select 
count(*) as reviews_without_order
from order_reviews r
left join orders o
on r.order_id=o.order_id
where o.order_id is null;


-- ============================================
-- QUERY 5: ORDER STATUS VALIDATION
-- ============================================

select 
	order_status, 
	count(*) as order_count, 
	round(100.0*count(*)/sum(count(*)) over(),2) as percentage_of_orders
from orders
group by order_status
order by order_count desc;

-- ============================================
-- QUERY 6: PRICE AND PAYMENT VALIDATION
-- ============================================

-- Check invalid product prices

select
	count(*) filter(where price<=0) as non_positive_prices,
	count(*) filter(where price< 0) as negative_prices,
	min(price) as minimum_price,
	max(price) as maximum_price
from order_items;

-- Check invalid payment values

select
	count(*) filter(where payment_value<0) as negative_payments,
	count(*) filter(where payment_value=0) as zero_payment,
	min(payment_value) as minimum_payment,
	max(payment_value) as maximum_payment
FROM order_payments;

-- ============================================
-- QUERY 7: INVESTIGATE ZERO-VALUE PAYMENTS
-- ============================================

select
	op.order_id,
	op.payment_sequential,
	op.payment_type,
	op.payment_installments,
	op.payment_value,
	o.order_status
from order_payments op
left join orders o
	on op.order_id=o.order_id
where op.payment_value=0
order by op.order_id;

-- ============================================
-- QUERY 8: INVESTIGATE OTHER PAYMENTS
-- FOR ORDERS WITH ZERO-VALUE PAYMENTS
-- ============================================

select
	op.order_id,
	op.payment_type,
	op.payment_value,
	sum(op.payment_value) over(partition by  op.order_id) as total_order_payment,
	count(*) over(partition by op.order_id) as payment_records
from order_payments as op
where op.order_id in(
	select 
		distinct order_id 
	from order_payments
	where payment_value=0
)
order by op.order_id, op.payment_sequential;

-- FINDING:
-- Nine zero-value payment records were identified.
-- Three belong to canceled orders with no positive payment records.
-- The remaining zero-value records occur alongside positive payments.
-- These records are flagged for investigation and are not deleted.

-- ============================================
-- QUERY 9: REVIEW SCORE VALIDATION
-- ============================================

select
	count(*) filter(where review_Score<1 or review_score>5) as invalid_scores,
	min(review_score) as minimum_score,
	max(review_score) as maximum_score
from order_reviews;

-- ============================================
-- QUERY 10: ORDER DATE VALIDATION
-- ============================================

select 
	count(*) filter(where order_estimated_delivery_date< order_purchase_timestamp) 
		as estimated_before_purchase,

	count(*) filter(where order_delivered_customer_date<order_purchase_timestamp) 
		as delivered_before_purchase,

count(*) filter(where order_delivered_customer_date is not null
					  and order_delivered_carrier_date is not null
					  and order_delivered_customer_date< order_delivered_carrier_date
				) as delivered_before_carrier 
from orders;

-- ============================================
-- QUERY 11: INVESTIGATE DELIVERY DATE ANOMALIES
-- ============================================

select
	order_id,
	order_status,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date
from orders
where order_delivered_customer_date
          < order_delivered_carrier_date
order by order_delivered_customer_date;


-- ============================================
-- QUERY 12: MISSING DELIVERY TIMESTAMP CHECK
-- ============================================

select
	count(*)filter(where order_status ='delivered'
			   and order_delivered_customer_date is null
			   ) as delivered_orders_missing_delivery_date,
	count(*) filter(where order_status='delivered'
			    and order_delivered_carrier_date is null
    			) as delivered_orders_missing_carrier_date,
	count(*) filter(where order_status = 'delivered'
          		and order_estimated_delivery_date is null
    		    ) as delivered_orders_missing_estimated_date
from orders;

-- ============================================
-- QUERY 13: DUPLICATE ORDER ITEM VALIDATION
-- ============================================
select
	count(*) as duplicate_order_item_keys
from(
	select
		order_id, order_item_id
	from order_items
	group by order_id,order_item_id
	having count(*)>1
)as duplicate_items;


-- ============================================
-- QUERY 14: PAYMENT TYPE VALIDATION
-- ============================================

select
	payment_type,
	count(*) as payment_records,
	count(*) filter(where payment_value=0) as zero_value_records,
	count(*) filter(where payment_value<0) as negative_records
from order_payments
group by payment_type
order by payment_records desc;


-- ============================================
-- QUERY 15: PRODUCT CATEGORY MAPPING VALIDATION
-- ============================================

select 
	count(*) as total_products,
	count(*) filter(where p.product_category_name is null)
		as product_without_category,
	count(*) filter(where p.product_category_name is not null
			    and pct.product_category_name is null
				) as category_without_translation
from products p
left join product_category_translation pct
	on p.product_category_name=pct.product_category_name;


-- ============================================
-- QUERY 16: DUPLICATE CATEGORY TRANSLATION CHECK
-- ============================================

select 
	product_category_name,
	count(*) as record_count
from product_category_translation
group by product_category_name
having count(*)>1;

-- ============================================
-- QUERY 17: PRODUCT DIMENSION AND WEIGHT VALIDATION
-- ============================================

select 
	count(*) filter(where product_weight_g<=0)
		as invalid_weight,
	count(*) filter(where product_length_cm<=0)
		as invalid_lenght,
	count(*) filter(where product_height_cm<=0)
		as invalid_height,
	count(*) filter (where product_width_cm<=0)
		as invalid_width
from products;

-- ============================================
-- QUERY 18: INVESTIGATE INVALID PRODUCT WEIGHTS
-- ============================================

select 
	product_id,
	product_category_name,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
from products
where product_weight_g<=0;

-- ============================================
-- QUERY 19: MISSING PRODUCT MEASUREMENTS
-- ============================================

select 
	count(*) filter(where product_weight_g is null)
		as missing_weight,
	count(*) filter(where product_length_cm is null)
		as missing_length,
	count(*) filter(where product_height_cm is null)
		as missing_height,
	count(*) filter(where product_width_cm is null)
		as missing_width
from products;


-- ============================================
-- QUERY 20: INVESTIGATE MISSING PRODUCT MEASUREMENTS
-- ============================================

select 
	product_id,
	product_category_name,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
from products
where product_weight_g is null
	or product_length_cm is null
	or product_height_cm is null
	or product_width_cm is null;