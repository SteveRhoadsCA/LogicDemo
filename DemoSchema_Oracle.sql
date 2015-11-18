REM Create the tables, and load the data, for LogicDemo Oracle version

REM remove old objects
begin execute immediate 'drop sequence employee_seq'; exception when others then if sqlcode != -2289 then raise; end if; end;
/
begin execute immediate 'drop sequence product_seq'; exception when others then if sqlcode != -2289 then raise; end if; end;
/
begin execute immediate 'drop sequence lineitem_seq'; exception when others then if sqlcode != -2289 then raise; end if; end;
/
begin execute immediate 'drop sequence purchaseorder_seq'; exception when others then if sqlcode != -2289 then raise; end if; end;
/
begin execute immediate 'drop sequence purchaseorder_audit_seq'; exception when others then if sqlcode != -2289 then raise; end if; end;
/
begin execute immediate 'drop table purchaseorder cascade constraints purge'; exception when others then if sqlcode != -942 then raise; end if; end;
/
begin execute immediate 'drop table employee cascade constraints purge'; exception when others then if sqlcode != -942 then raise; end if; end;
/
begin execute immediate 'drop table customer cascade constraints purge'; exception when others then if sqlcode != -942 then raise; end if; end;
/
begin execute immediate 'drop table lineitem cascade constraints purge'; exception when others then if sqlcode != -942 then raise; end if; end;
/
begin execute immediate 'drop table product cascade constraints purge'; exception when others then if sqlcode != -942 then raise; end if; end;
/
begin execute immediate 'drop table purchaseorder_audit cascade constraints purge'; exception when others then if sqlcode != -942 then raise; end if; end;
/
begin execute immediate 'drop table employee_picture cascade constraints purge'; exception when others then if sqlcode != -942 then raise; end if; end;
/
begin execute immediate 'drop procedure get_employee'; exception when others then if sqlcode != -4043 then raise; end if; end;
/
create sequence employee_seq increment by 1 start with 1 nocache
/
create table employee (
  employee_id number(12,0) primary key
 ,login varchar2(15) not null unique
 ,name varchar2(30) not null
)
/
comment on table employee is 'Simple table containing the login for the employee'
/


create table customer (
  name varchar2(30) primary key
 ,balance number(19,4)
 ,credit_limit number(19,4) not null
)
/
comment on table customer is 'Contains the customer name, credit limit and current balance'
/


create sequence product_seq increment by 1 start with 1000 nocache
/
create table product (
  product_number number(12,0) primary key
 ,name varchar2(50) NOT NULL UNIQUE
 ,price number(19,4) NOT NULL
)
/
comment on table product is 'Contains a products available'
/


create sequence purchaseorder_seq increment by 1 start with 1000 nocache
/
create table purchaseorder (
  order_number number(12,0) primary key
 ,amount_total number(19,4)
 ,paid char default 'N' not null check (paid in ('Y', 'N'))
 ,notes varchar2(1000)
 ,customer_name varchar2(30) not null
 ,salesrep_id number(12,0)
)
/
alter table purchaseorder add constraint fkcustomer
  foreign key (customer_name) references customer (name)
  on delete cascade
/

alter table purchaseorder add constraint fksalesrep
  foreign key (salesrep_id) references employee (employee_id)
  on delete cascade
/


create sequence lineitem_seq increment by 1 start with 1000 nocache
/
create table lineitem (
  lineitem_id number(12,0) primary key
 ,product_number number(12,0) not null
 ,order_number number(12,0) not null
 ,qty_ordered number(9) not null
 ,product_price number(19,4)
 ,amount number(19,4)
 ,constraint fk_product foreign key (product_number) references product (product_number)
 ,constraint fk_purchaseorder foreign key (order_number) references purchaseorder (order_number) on delete cascade
)
/


create sequence purchaseorder_audit_seq increment by 1 start with 1 nocache
/
create table purchaseorder_audit (
  audit_number number(12,0) primary key
 ,order_number number(12,0)
 ,amount_total number(19,4)
 ,paid char default 'N' not null check (paid in ('Y', 'N'))
 ,notes varchar2(1000)
 ,audit_timestamp timestamp default current_timestamp
 ,customer_name varchar2(30) not null
 ,constraint fk_purchase_order foreign key (order_number) references purchaseorder (order_number) on delete cascade
)
/


create table employee_picture (
  employee_id number(12,0) primary key
 ,icon raw(6000)
 ,picture blob
 ,voice blob
 ,resume clob
 ,constraint fk_employee foreign key (employee_id) references employee (employee_id) on delete cascade
)
/
comment on table employee_picture is 'Sample table demonstrating BLOB and CLOB'
/


create view customers_owing as
 select name
       ,balance
       ,credit_limit
   from customer
  where balance > 0
/
comment on table customers_owing is 'Customers currently owing money'
/


create or replace package types
as
   type ref_cursor is ref cursor;
end;
/

create or replace procedure get_employee(
  given_employee_id in number
 ,plus_one in out number
 ,emp_cursor out types.ref_cursor
 ,sales_cursor out types.ref_cursor
)
as
begin
  plus_one := 1 + plus_one;
  open emp_cursor for
  select e.employee_id
        ,plus_one
        ,e.login
        ,ep.icon
        ,ep.picture
        ,ep.voice
    from employee e
        ,employee_picture ep
   where e.employee_id = ep.employee_id (+)
     and given_employee_id = e.employee_id;

  open sales_cursor for
  select *
    from purchaseorder
   where given_employee_id = salesrep_id
   order by order_number;
end get_employee;
/

create or replace procedure noarg_proc
as
begin
return;
end noarg_proc;
/
REM to test in SQL*Plus
REM   var results refcursor;
REM   call get_employee(1, :results);
REM   print results;
REM
REM JDBC:
REM  begin get_employee(?, ?); end;
REM OR
REM CallableStatement cs = conn.prepareCall("{ call get_employee(?, ?) }")
REM cs.registerOutParameter(2, OracleTypes.CURSOR)
REM ResultSet rs = (ResultSet)getObject(2)

REM select *
REM   from sys.all_procedures
REM  where owner = 'DEMO'
REM    and object_type = 'PROCEDURE'
REM
