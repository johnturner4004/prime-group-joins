--Tasks
-- 0. Get all the users
  SELECT * FROM customers;

-- 1. Get all customers and their addresses.
  SELECT * FROM customers as c
  JOIN addresses as a on c.id = a.customer_id;

-- 2. Get all orders and their line items (orders, quantity and product).
  SELECT o.id, li.quantity, p.description FROM orders as o
  JOIN line_items as li on li.order_id = o.id
  JOIN products as p on p.id = li.product_id;

-- 3. Which warehouses have cheetos?
  SELECT w.warehouse FROM warehouse as w
  JOIN warehouse_product as wp on w.id = wp.warehouse_id
  JOIN products as p on p.id = wp.product_id
  WHERE p.description = 'cheetos';

-- 4. Which warehouses have diet pepsi?
SELECT w.warehouse FROM warehouse as w
JOIN warehouse_product as wp on w.id = wp.warehouse_id
JOIN products as p on p.id = wp.product_id
WHERE p.description = 'diet pepsi';

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
  SELECT c.first_name, c.last_name, COUNT(*) FROM orders as o
  JOIN addresses as a on o.address_id = a.id
  JOIN customers as c on a.customer_id = c.id
  GROUP BY c.first_name, c.last_name;

-- 6. How many customers do we have?
  SELECT COUNT(*) FROM customers;

-- 7. How many products do we carry?
  SELECT COUNT(*) FROM products;

-- 8. What is the total available on-hand quantity of diet pepsi?
  SELECT SUM(wp.on_hand) FROM products as p
  JOIN warehouse_product as wp on wp.product_id = p.id
  WHERE p.description = 'diet pepsi';

--Stretch
-- 9. How much was the total cost for each order?
  SELECT o.id, SUM(li.quantity * p.unit_price) as ordered_total FROM orders as o
  JOIN line_items as li on li.order_id = o.id
  JOIN products as p on li.product_id = p.id
  GROUP BY o.id
  ORDER BY o.id;

-- 10. How much has each customer spent in total?
  SELECT c.first_name, c.last_name, SUM(li.quantity * p.unit_price) FROM customers as c
  JOIN addresses as a on c.id = a.customer_id
  JOIN orders as o on a.id = o.address_id
  JOIN line_items as li on li.order_id = o.id
  JOIN products as p on li.product_id = p.id
  GROUP BY c.id;

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
  SELECT c.first_name, c.last_name, COALESCE(SUM(li.quantity * p.unit_price), 0) FROM customers as c
  JOIN addresses as a on c.id = a.customer_id
  LEFT JOIN orders as o on o.address_id = a.id
  LEFT JOIN line_items as li on li.order_id = o.id
  LEFT JOIN products as p on li.product_id = p.id
  GROUP BY c.id
  ORDER BY c.id;