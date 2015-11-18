/* Data for LogicDemo (Oracle) */

INSERT INTO customer (name, balance, credit_limit) VALUES ('Alpha and Sons', 85, 900);
INSERT INTO customer (name, balance, credit_limit) VALUES ('Bravo Hardware', 60, 5000);
INSERT INTO customer (name, balance, credit_limit) VALUES ('Charlie''s Construction', 220, 1500);
INSERT INTO customer (name, balance, credit_limit) VALUES ('Delta Engineering', 0, 0);

INSERT INTO employee (employee_id, login) VALUES (1, 'sam');
INSERT INTO employee (employee_id, login) VALUES (2, 'mary');
INSERT INTO employee (employee_id, login) VALUES (3, 'sarah');

INSERT INTO product (product_number, name, price) VALUES (1, 'Hammer', 10);
INSERT INTO product (product_number, name, price) VALUES (2, 'Shovel', 25);
INSERT INTO product (product_number, name, price) VALUES (3, 'Drill', 315);

INSERT INTO purchaseorder (order_number, amount_total, paid, notes, customer_name, salesrep_id) VALUES (1, 35, 'N' 'This is a small order', 'Alpha and Sons', 1);
INSERT INTO purchaseorder (order_number, amount_total, paid, notes, customer_name, salesrep_id) VALUES (2, 675, 'Y', '', 'Bravo Hardware', 1);
INSERT INTO purchaseorder (order_number, amount_total, paid, notes, customer_name, salesrep_id) VALUES (3, 60, 'N', 'Please rush this order', 'Bravo Hardware', 1);
INSERT INTO purchaseorder (order_number, amount_total, paid, notes, customer_name, salesrep_id) VALUES (4, 85, 'N', 'Deliver by overnight with signature required', 'Charlie''s Construction', 2);
INSERT INTO purchaseorder (order_number, amount_total, paid, notes, customer_name, salesrep_id) VALUES (5, 135, 'N', '', 'Charlie''s Construction', 1);
INSERT INTO purchaseorder (order_number, amount_total, paid, notes, customer_name, salesrep_id) VALUES (6, 50, 'N', 'Pack with care - fragile merchandise', 'Alpha and Sons', 2);

INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (1, 1, 1, 1, 10, 10);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (2, 1, 2, 2, 10, 20);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (3, 2, 2, 1, 25, 25);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (4, 3, 2, 2, 315, 630);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (5, 1, 3, 1, 10, 10);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (6, 2, 3, 2, 25, 50);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (7, 1, 4, 1, 10, 10);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (8, 2, 4, 3, 25, 75);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (9, 1, 5, 1, 10, 10);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (10, 2, 5, 5, 25, 125);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (11, 2, 6, 2, 25, 50);
INSERT INTO lineitem (lineitem_id, product_number, order_number, qty_ordered, product_price, amount) VALUES (12, 2, 1, 1, 25, 25);
