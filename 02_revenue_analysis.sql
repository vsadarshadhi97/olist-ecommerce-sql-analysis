
-- =====================================================
-- OLIST E-COMMERCE ANALYSIS
-- FILE: 02_revenue_analysis.sql
-- PURPOSE: Analyze revenue, orders, and sales performance
-- DATABASE: olist_ecommerce
-- =====================================================

-- ============================================
-- QUERY 1: TOTAL REVENUE
-- ============================================

select 
	round(sum(payment_value),2) as total_recorded_payment_value 
from order_payments;

-- ============================================
-- QUERY 2: TOTAL NUMBER OF ORDERS
-- ============================================

select 
	count(distinct order_id) 
from orders;

-- ============================================
-- QUERY 3: MONTHLY REVENUE ANALYSIS
-- ============================================

select 
	DATE_TRUNC('month', o.order_purchase_timestamp) as order_month,
	round(sum(op.payment_value),2) as total_revenue
from orders o
left join order_payments op
	on o.order_id=op.order_id
group by DATE_TRUNC('month',o.order_purchase_timestamp)
order by order_month;

-- ============================================
-- QUERY 4: AVERAGE ORDER VALUE (AOV)
-- ============================================
select
	round(avg(order_total),2) as average_order_value
from(
	select
		order_id,
		sum(payment_value) as order_total
	from order_payments
	group by order_id
)as order_value;

-- ============================================
-- QUERY 5: REVENUE BY PAYMENT TYPE
-- ============================================

select
	payment_type,
	count(*) as payment_records,
	sum(payment_value) as total_payment_value
from order_payments
group by payment_type
order by total_payment_value desc;


-- ============================================
-- QUERY 6: TOP 10 PRODUCT CATEGORIES BY REVENUE
-- ============================================

select
	coalesce(
		pct.product_category_name_english,
		'Unknown/Untranslated'
		) as product_category,
			round(sum(oi.price),2) as product_sales
from order_items oi
join orders o
	on oi.order_id=o.order_id
join products p
	on oi.product_id=p.product_id
left join product_category_translation pct
	on p.product_category_name=pct.product_category_name
group by 
	coalesce(
			pct.product_category_name_english, 
			'Unknown/Untranslated'
			)
order by product_sales desc
limit 10;

-- ============================================
-- QUERY 7: TOP 10 BEST-SELLING PRODUCTS
-- ============================================

select
	oi.product_id,
	coalesce(
		pct.product_category_name_english,
		'Unknown/Untranslated'
		)as product_category,
			count(*) as units_sold,
			round(sum(oi.price),2) as total_sales
from order_items oi
join products p
	on oi.product_id=p.product_id
left join product_category_translation pct
	on p.product_category_name=pct.product_category_name
group by 
	oi.product_id,
	coalesce(
			pct.product_category_name_english,
		'Unknown/Untranslated'
			)
order by units_sold desc, total_sales desc
limit 10;

-- ============================================
-- QUERY 8: PAYMENT VALUE BY ORDER STATUS
-- ============================================

select
	o.order_status,
	count(distinct o.order_id) as total_orders,
	round(sum(op.payment_value),2) as total_payment_value
from orders o
join order_payments op
	on o.order_id=op.order_id
group by o.order_status
order by total_payment_value desc;

-- ============================================
-- QUERY 9: MONTHLY ORDER VOLUME
-- ============================================

select
	DATE_TRUNC('month',order_purchase_timestamp) as order_month,
	To_char(order_purchase_timestamp,'FMMonth') as month_name,
	To_char(order_purchase_timestamp,'YYYY') as year,
	count(distinct order_id) as total_orders
from orders
where order_purchase_timestamp is not null
group by DATE_TRUNC('month',order_purchase_timestamp),
		 To_char(order_purchase_timestamp,'FMMonth'),
		 To_char(order_purchase_timestamp,'YYYY')
order by order_month;

-- ============================================
-- QUERY 10: TOP 10 ORDERS BY PAYMENT VALUE
-- ============================================

select 
	order_id,
	round(sum(payment_value),2) as order_payment_value
from order_payments
group by order_id
order by order_payment_value desc
limit 10;

-- ============================================
-- QUERY 11: INVESTIGATE HIGHEST-VALUE ORDER
-- =========================================

select 
	oi.order_id,
	oi.product_id,
	coalesce(
		pct.product_category_name_english,
        'Unknown / Untranslated'
    	) AS product_category,
			oi.price as product_price,
			oi.freight_value
from order_items oi
join products p
	on oi.product_id=p.product_id
left join product_category_translation pct
    on p.product_category_name = pct.product_category_name
where oi.order_id='03caa2c082116e1d31e67e9ae3700499'
order by oi.price desc;

-- ============================================
-- QUERY 12: VERIFY HIGH-VALUE ORDER ITEMS
-- ============================================
select
    order_id,
    count(*) as order_item_rows,
    count(distinct product_id) as distinct_products,
    sum(price) as total_product_value,
    sum(freight_value) as total_freight
from order_items
where order_id = '03caa2c082116e1d31e67e9ae3700499'
group by order_id;


-- ============================================
-- QUERY 13: REVENUE BY CUSTOMER STATE
-- ============================================

select 
	c.customer_state,
	count(distinct o.order_id) as total_orders,
	round(sum(oi.price),2) as product_sales
from orders o
join customers c
	on o.customer_id=c.customer_id
join order_items oi
	on o.order_id=oi.order_id
group by c.customer_state
order by product_sales desc
limit 10;

-- ============================================
-- QUERY 14: AVERAGE ORDER VALUE BY STATE
-- ============================================

with order_totals as(
	select
		o.order_id,
		c.customer_state,
		sum(op.payment_value) as order_value
	from orders o
	join customers c
		on o.customer_id=c.customer_id
	join order_payments op
		on o.order_id=op.order_id
	group by o.order_id,
			 c.customer_id
)
select
	customer_state,
	count(*) as total_orders,
	round(avg(order_value),2) as average_order_value
from order_totals
group by customer_state
order by average_order_value desc;



-- ============================================
-- QUERY 15: MONTH-OVER-MONTH REVENUE GROWTH
-- ============================================

with monthly_revenue as(
	select 
		DATE_TRUNC('month', o.order_purchase_timestamp) as order_month,
		sum(op.payment_value) as revenue
	from orders o
	join order_payments op
		on o.order_id=op.order_id
	where o.order_purchase_timestamp is not null
	group by date_trunc('month',o.order_purchase_timestamp)
),

revenue_with_previous_month as(
	select 
		order_month,
		revenue,
		lag(revenue) over(order by order_month) as previous_month_revenue
	from monthly_revenue
)

select 
	To_char(order_month, 'FMmonth YYYY') as month,
	round(revenue,2 ) as revenue,
	round(previous_month_revenue,2) as previous_month_revenue,
	round(
		   100.0*(revenue - previous_month_revenue)
		   / nullif(previous_month_revenue,0),2
		  )as growth_percentage
from revenue_with_previous_month
order by order_month;

-- ============================================
-- QUERY 16: REVENUE CONTRIBUTION BY PRODUCT CATEGORY
-- ============================================

with category_sales as(
	select 
		coalesce(
				pct.product_category_name_english,
				'Unknown/Untranslated'
				) as product_category,
		sum(oi.price) as product_sales
	from order_items oi
	join products p
		on oi.product_id=p.product_id
	left join product_category_translation pct
		on p.product_category_name = pct.product_category_name 
	group by 
		coalesce(
				pct.product_category_name_english,
				'Unknown/Untranslated'
				)
)

select 
	product_category,
	round(product_sales::NUMERIC,2) as product_sales,
	round(
		  product_sales*100
		  /sum(product_sales) over(),2) as revenue_contribution_pct
from category_sales
order by product_sales desc;

-- ============================================
-- QUERY 17: MONTHLY ORDER CANCELLATION RATE
-- ============================================

select 
	DATE_TRUNC('month', order_purchase_timestamp) as order_month,
	count(*) as total_orders,
	count(*) filter(
			where order_status='canceled'
	)as canceled_orders,
	round(
		count(*)filter(
			where order_status='canceled'
		)*100.0/nullif (count(*),0),2
	)as cancellation_rate_pct

from orders
where order_purchase_timestamp is not null
group by date_trunc('month', order_purchase_timestamp)
order by order_month;

-- ============================================
-- QUERY 18: AVERAGE DELIVERY TIME BY CUSTOMER STATE
-- ============================================

select
	c.customer_state,
	count(*) as delivered_orders,

	round( avg(
				extract(
						EPOCH from(
								o.order_delivered_customer_date
								- o.order_purchase_timestamp
								)
								)/86400
							)::NUMERIC,2) 
							as avg_delivery_days
from orders o
join customers c
	on o.customer_id=c.customer_id

where o.order_status='delivered'
	  and o.order_purchase_timestamp is not null
	  and o.order_delivered_customer_date is not null

group by c.customer_state
order by avg_delivery_days desc;

-- ============================================
-- QUERY 19: LATE DELIVERY RATE BY CUSTOMER STATE
-- ============================================

select
	c.customer_state,
	count(*) as delivered_orders,
	count(*) filter(
					where o.order_delivered_customer_date>
					o.order_estimated_delivery_date
					) as late_deliveries,
	round(count(*) filter(
						where o.order_delivered_customer_date>
								o.order_estimated_delivery_date
								)*100.0 / nullif(count(*),0),2
								)as late_delivery_rate_pct
from orders o
join customers c
	 on o.customer_id=c.customer_id
where o.order_status='delivered'
	  and o.order_delivered_customer_date is not null
	  and o.order_estimated_delivery_date is not null
group by c.customer_state
order by late_delivery_rate_pct desc;

-- ============================================
-- QUERY 20: REVIEW SCORE VS DELIVERY DELAY
-- ============================================

with order_review_scores as (
    select
        order_id,
        avg(review_score) as avg_review_score
    from order_reviews
    where review_score between 1 and 5
    group by order_id
),
delivery_status as (
    select
        order_id,
        case
            when order_delivered_customer_date >
                 order_estimated_delivery_date
            then 'Late'
            else 'On-time'
        end as delivery_category
    from orders
    where order_status = 'delivered'
      and order_delivered_customer_date is not null
      and order_estimated_delivery_date is not null
)
select
    d.delivery_category,
    count(*) as reviewed_orders,
    round(avg(r.avg_review_score)::NUMERIC, 2) as avg_review_score
from delivery_status d
join order_review_scores r
    on d.order_id = r.order_id
group by d.delivery_category
order by avg_review_score;


-- ============================================
-- QUERY 21: CUSTOMER REVIEW SCORE DISTRIBUTION
-- ============================================
select 
	review_score,
	round(
			count(*)*100.0/ sum(count(*)) over(),2
	)as review_percentage
from order_reviews
where review_score between 1 and 5
group by review_score
order by review_score;

-- ============================================
-- QUERY 22: TOP 10 SELLERS BY PRODUCT SALES
-- ============================================

select 
	oi.seller_id,
	count(distinct oi.order_id) as total_orders,
	count(*) as items_sold,
	round(sum(oi.price)::NUMERIC,2) as product_sales
from order_items oi
group by oi.seller_id
order by product_sales desc
limit 10;

-- ============================================
-- QUERY 23: REPEAT CUSTOMER ANALYSIS
-- ============================================

with customer_orders as(
		select
				c.customer_unique_id,
				count(distinct o.order_id) as total_orders
		from customers c
		join orders o
			on c.customer_id=o.customer_id
		group by c.customer_unique_id
						)

select 
	count(*) as total_unique_customers,
	count(*) filter(
				where total_orders>1
					) as repeat_customers,
	round( count(*) filter (
				where total_orders>1
		)*100.0 / nullif(count(*),0),2
	) as repeat_customer_pct
from customer_orders;

-- ============================================
-- QUERY 24: FREIGHT COST ANALYSIS BY CUSTOMER STATE
-- ============================================
select 	
	c.customer_state,
	count(distinct o.order_id)as total_orders,
	round( 
		  avg(oi.freight_value)::NUMERIC,2
				
	      )as avg_freight_per_item,
	round(
		  sum(oi.freight_value)::NUMERIC,2
		  )as total_freight 

from orders o
join customers c
	on o.customer_id=c.customer_id
join order_items oi
	on o.order_id=oi.order_id

group by c.customer_state
order by avg_freight_per_item desc;

-- ============================================
-- QUERY 25: SELLER REVENUE VS CUSTOMER SATISFACTION
-- ============================================
with seller_sales as(
	 select 
	 		seller_id,
			sum(price) as total_product_sales,
			count(distinct order_id) as total_orders
	from order_items
	group by seller_id
					),

order_review_scores as(
	select 
			order_id,
			avg(review_score) as order_review_score
	from order_reviews
	where review_score between 1 and 5
	group by order_id
),

seller_order_reviews as(
	select distinct
		oi.seller_id,
		oi.order_id,
		r.order_review_score
	from order_items oi
	join order_review_scores r
		on oi.order_id=r.order_id
		
),

seller_reviews as(
	select 
			seller_id,
			count(distinct order_id) as reviewed_orders,
			round(avg(order_review_score)::NUMERIC,2) as avg_review_score
	from seller_order_reviews 
	group by seller_id
				)

select
	ss.seller_id,
	ss.total_orders,
	round(
			ss.total_product_sales::NUMERIC,2) as total_product_sales,
	sr.reviewed_orders,
	sr.avg_review_score
from seller_sales ss
join seller_reviews sr
	on ss.seller_id=sr.seller_id
where sr.reviewed_orders>=20
order by sr.avg_review_score desc, ss.total_product_sales desc
limit 10;





