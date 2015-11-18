-- Create the tables, and load the data, for LogicDemo (MySQL)
-- ***** NOTE delimiter MUST be / on its own line - build scripts depend on this as we have ';' in stored procs

-- Need this to get metadata
-- grant select on mysql.proc to 'dblocal_admin'@'%'


drop view if exists customers_owing
/

drop view if exists LineItemJoinProduct
/

drop view if exists employee_with_picture
/

drop procedure if exists get_employee
/

DROP TABLE IF EXISTS employee_picture
/

DROP TABLE IF EXISTS purchaseorder_audit
/

DROP TABLE IF EXISTS LineItem
/

DROP TABLE IF EXISTS PurchaseOrder
/

DROP TABLE IF EXISTS product
/

DROP TABLE IF EXISTS customer
/

DROP TABLE IF EXISTS employee
/

CREATE TABLE employee (
  employee_id bigint AUTO_INCREMENT PRIMARY KEY,
  login varchar(15) NOT NULL UNIQUE,
  name varchar(30) not null
)
ENGINE=InnoDB DEFAULT CHARSET=latin1
/


CREATE TABLE customer (
  name varchar(30) PRIMARY KEY,
  balance decimal(19,4),
  credit_limit decimal(19,4) NOT NULL
)
ENGINE=InnoDB DEFAULT CHARSET=latin1
/


CREATE TABLE product (
  product_number bigint AUTO_INCREMENT PRIMARY KEY,
  name varchar(50) NOT NULL UNIQUE,
  price decimal(19,4) NOT NULL,
  icon blob,
  full_image mediumblob
)
ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT = 1000
/


CREATE TABLE PurchaseOrder (
  order_number bigint AUTO_INCREMENT PRIMARY KEY,
  amount_total decimal(19,4),
  paid boolean DEFAULT FALSE NOT NULL,
  notes varchar(1000),
  customer_name varchar(30) NOT NULL,
  salesrep_id bigint,
  CONSTRAINT customer FOREIGN KEY (customer_name) REFERENCES customer (name) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT salesrep FOREIGN KEY (salesrep_id) REFERENCES employee (employee_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT = 1000
/


CREATE TABLE LineItem (
  lineitem_id bigint AUTO_INCREMENT PRIMARY KEY,
  product_number bigint NOT NULL,
  order_number bigint NOT NULL,
  qty_ordered int NOT NULL,
  product_price decimal(19,4),
  amount decimal(19,4),
  CONSTRAINT product FOREIGN KEY (product_number) REFERENCES product (product_number) ON UPDATE CASCADE,
  CONSTRAINT lineitem_purchaseorder FOREIGN KEY (order_number) REFERENCES PurchaseOrder (order_number) ON DELETE CASCADE ON UPDATE CASCADE
)
ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT = 1000
/


CREATE TABLE purchaseorder_audit (
  audit_number bigint AUTO_INCREMENT PRIMARY KEY,
  order_number bigint,
  amount_total decimal(19,4),
  paid boolean,
  notes varchar(1000),
  audit_time datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  customer_name varchar(30) NOT NULL,
  CONSTRAINT purchaseorder_audit FOREIGN KEY (order_number) REFERENCES PurchaseOrder (order_number) ON DELETE CASCADE ON UPDATE CASCADE
)
ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT = 1000
/


CREATE TABLE employee_picture (
  employee_id bigint PRIMARY KEY
 ,icon varbinary(6000)
 ,picture longblob
 ,voice mediumblob
 ,resume longtext
 ,CONSTRAINT employee_picture FOREIGN KEY (employee_id) REFERENCES employee (employee_id) ON DELETE CASCADE ON UPDATE CASCADE
)
ENGINE=InnoDB DEFAULT CHARSET=latin1
/


create procedure get_employee(
    IN given_employee_id BIGINT
   ,INOUT plus_one BIGINT
)
comment 'given an employee id and a number ''plus_one'', adds one to the number and returns the employee info as well as picture, voice and icon'
begin
 set plus_one = plus_one + 1;
 select e.employee_id
       ,plus_one
       ,e.login
       ,ep.icon
       ,ep.picture
       ,ep.voice
   from employee e
  right outer join employee_picture ep
     on e.employee_id = ep.employee_id
  where given_employee_id = e.employee_id;

 select *
   from PurchaseOrder
  where given_employee_id = salesrep_id
  order by order_number;
end
/

create view customers_owing as
select name
      ,balance
      ,credit_limit
  from customer
 where balance > 0
/


create view LineItemJoinProduct as
select l.lineitem_id  LineItemId
      ,l.product_number ProductNumber
      ,l.order_number OrderNumber
      ,l.qty_ordered QuantityOrdered
      ,l.product_price ProductPriceCopy
      ,p.price ProductPrice
      ,p.name ProductName
  from LineItem l
  join product p
    on l.product_number = p.product_number
/


create view employee_with_picture as
select e.employee_id
      ,e.login, ep.picture
  from employee e 
  left outer join employee_picture ep
    on e.employee_id = ep.employee_id
/

