/*
 * Create the tables, and load the data, for LogicDemo.
 * Microsoft SQL Server version
 */

begin try drop table purchaseorder_audit end try begin catch end catch
go
begin try drop table lineitem end try begin catch end catch
go
begin try drop table purchaseorder end try begin catch end catch
go
begin try drop table employee_picture end try begin catch end catch
go
begin try drop table employee end try begin catch end catch
go
begin try drop table customer end try begin catch end catch
go
begin try drop procedure get_employee end try begin catch end catch
go


CREATE TABLE employee (
  employee_id bigint IDENTITY PRIMARY KEY,
  login varchar(15) NOT NULL UNIQUE,
  name varchar(30) not null
)
go


CREATE TABLE customer (
  name varchar(30) PRIMARY KEY,
  balance decimal(19,4),
  credit_limit decimal(19,4) NOT NULL
)
go


CREATE TABLE product (
  product_number bigint IDENTITY PRIMARY KEY,
  name varchar(50) NOT NULL UNIQUE,
  price decimal(19,4) NOT NULL
)
go


CREATE TABLE purchaseorder (
  order_number bigint identity PRIMARY KEY,
  amount_total decimal(19,4),
  paid bit DEFAULT 0 NOT NULL,
  notes varchar(1000),
  customer_name varchar(30) NOT NULL,
  salesrep_id bigint,
  CONSTRAINT fk_customer FOREIGN KEY (customer_name) REFERENCES customer (name) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_salesrep FOREIGN KEY (salesrep_id) REFERENCES employee (employee_id) ON DELETE CASCADE ON UPDATE CASCADE
)
go

CREATE TABLE lineitem (
  lineitem_id bigint IDENTITY PRIMARY KEY,
  product_number bigint NOT NULL,
  order_number bigint NOT NULL,
  qty_ordered int NOT NULL,
  product_price decimal(19,4),
  amount decimal(19,4),
  CONSTRAINT fk_product FOREIGN KEY (product_number) REFERENCES product (product_number) ON UPDATE CASCADE,
  CONSTRAINT fk_purchase_order FOREIGN KEY (order_number) REFERENCES purchaseorder (order_number) ON DELETE CASCADE ON UPDATE CASCADE
)
go


CREATE TABLE purchaseorder_audit (
  audit_number bigint IDENTITY PRIMARY KEY,
  order_number bigint,
  amount_total decimal(19,4),
  paid bit,
  notes varchar(1000),
  audit_timestamp datetime2 default sysdatetime()
  customer_name varchar(30) NOT NULL,
  CONSTRAINT fk_purchase_order FOREIGN KEY (order_number) REFERENCES purchaseorder (order_number) ON DELETE CASCADE ON UPDATE CASCADE
)
go


CREATE TABLE employee_picture (
  employee_id bigint PRIMARY KEY
 ,icon varbinary(6000)
 ,picture image
 ,voice varbinary(MAX)
 ,resume varchar(MAX)
 ,CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES employee (employee_id) ON DELETE CASCADE ON UPDATE CASCADE
)
go


create procedure get_employee
  @given_employee_id bigint
 ,@plus_one_in bigint
 ,@plus_one_out bigint OUTPUT
  as
begin
  set @plus_one_out = 1 + @plus_one_in
  select e.employee_id
        ,@plus_one_out
        ,e.login
        ,ep.icon
        ,ep.picture
        ,ep.voice
        ,ep.resume
    from employee e
   right outer join employee_picture ep
      on e.employee_id = ep.employee_id
     and @given_employee_id = e.employee_id

  select *
    from purchaseorder
   where @given_employee_id = salesrep_id
   order by order_number
end
go
