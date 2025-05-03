select * from payments_test.payments_transaction pt;
delete from payments_test.payments_transaction pt;
----
insert into payments_test.payments_transaction  
(payment_id,loan_id,payment_date,amount,created_at,updated_at)
values (1,1, '01-01-2025'::date, 159, now(), now());
--    start of transaction
begin;
---
insert into payments_test.payments_transaction  
(payment_id,loan_id,payment_date,amount,created_at,updated_at)
values (2,2, '01-02-2025'::date, 980, now(), now());
savepoint sp1;
update payments_test.payments_transaction 
set amount = 220
where payment_id = 1;
---
savepoint sp2;
--
update payments_test.payments_transaction 
set amount = 'двести долларов'
where payment_id = 1;
--
rollback to savepoint sp2 ;
--
update payments_test.payments_transaction 
set amount = 200
where payment_id = 1;
--
commit;
--	end of transaction



