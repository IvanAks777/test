CREATE TABLE IF NOT EXISTS staging.film
(
    film_id integer NOT NULL,
    title character varying(255),
    description text ,
    release_year int2,
    language_id smallint ,
    rental_duration smallint,
    rental_rate numeric(4,2),
    length smallint,
    replacement_cost numeric(5,2),
    rating varchar,
    last_update timestamp,
    special_features text,
    fulltext varchar 
);
create or replace procedure staging.film_load()
as $$
	begin
		truncate table staging.film;
		insert
	into
	staging.film
		(film_id,
			title,
			description,
			release_year,
			language_id,
			rental_duration,
			rental_rate,
			length,
			replacement_cost,
			rating,
			last_update,
			special_features,
			fulltext)
		select film_id,
			title,
			description,
			release_year,
			language_id,
			rental_duration,
			rental_rate,
			length,
			replacement_cost,
			rating,
			last_update,
			special_features,
			fulltext
from film_src.film;
	end;
$$ language plpgsql;
CREATE TABLE if not exists staging.inventory (
	inventory_id int,
	film_id int2 ,
	store_id int2,
	last_update timestamp 
);
create or replace procedure staging.inventory_load() as 
$$
	begin
		truncate table staging.inventory;
	INSERT INTO staging.inventory
(inventory_id, film_id, store_id, last_update)
select 
inventory_id, film_id, store_id, last_update from film_src.inventory;
	end
$$ language plpgsql;
drop table if exists staging.rental;
CREATE table if not exists staging.rental (
	rental_id int,
	rental_date timestamp,
	inventory_id int4,
	customer_id int2,
	return_date timestamp ,
	staff_id int2,
	last_update timestamp
);
create or replace procedure staging.rental_load()
as $$
	begin
		truncate table staging.rental;
		insert into staging.rental (
		rental_id,
		rental_date,
		inventory_id,
		customer_id,
		return_date,
		staff_id,
		last_update
		)
		select 
			rental_id,
			rental_date,
			inventory_id,
			customer_id,
			return_date,
			staff_id,
			last_update
		from film_src.rental;
	end;
$$ language plpgsql;
drop table if exists staging.payment;
CREATE TABLE if not exists staging.payment (
	payment_id int,
	customer_id int2,
	staff_id int2,
	rental_id int4 ,
	amount numeric(5, 2),
	payment_date timestamp 
);
create or replace procedure staging.payment_load() as 
$$
	begin
		truncate table staging.payment;
		insert into staging.payment (
			payment_id,
			customer_id,
			staff_id,
			rental_id,
			amount,
			payment_date
			)
		select 
			payment_id,
			customer_id,
			staff_id,
			rental_id,
			amount,
			payment_date
		from film_src.payment;
	end
$$ language plpgsql;
create table if not exists staging.address (
	address_id int,
	address varchar(50) ,
	address2 varchar(50),
	district varchar(20) ,
	city_id int2 ,
	postal_code varchar(10) ,
	phone varchar(20) ,
	last_update timestamp 
);
create or replace procedure staging.address_load()
as $$ 
begin
	truncate table staging.address;
	insert into staging.address
	(
	address_id,
	address,
	address2,
	district,
	city_id,
	postal_code,
	phone,
	last_update
	)
	select 
address_id, address, address2, district, city_id, postal_code, phone, last_update
from film_src.address;
end;
$$ language plpgsql;
drop table if exists staging.city;
create table if not exists  staging.city (
			city_id int,
	city varchar(50) ,
	country_id int2,
	last_update timestamp 
);
create or replace  procedure staging.city_load()
as $$
	begin
	truncate table staging.city;
	insert into staging.city 
(
city_id, city, country_id, last_update
)
select city_id, city, country_id, last_update from film_src.city;
	end;
$$ language plpgsql;
create table if not exists staging.staff (
	staff_id int,
	first_name varchar(45) ,
	last_name varchar(45),
	email varchar(50),
	store_id int2 ,
	active bool ,
	username varchar(16) ,
	"password" varchar(40) ,
	last_update timestamp ,
	picture bytea 
);
create or replace procedure staging.staff_load()
as $$
	begin
       truncate table staging.staff;
		insert into staging.staff (staff_id, first_name, last_name, email, store_id, active, username, "password", last_update, picture)
select staff_id, first_name, last_name, email, store_id, active, username, "password", last_update, picture from film_src.staff;
    end;
$$ language plpgsql;
create table if not exists staging.store
(
	store_id int,
	manager_staff_id int2,
	address_id int2 ,
	last_update timestamp 
);
create or replace procedure staging.store_load() as
$$
BEGIN
	TRUNCATE table staging.store;
	insert into staging.store 
	(
	store_id, manager_staff_id, address_id, last_update
	) 
	select store_id, manager_staff_id, address_id, last_update from film_src.store;
end 
$$ language plpgsql;
-------------------------------------------------
call staging.film_load();
call staging.inventory_load();
call staging.rental_load();
call staging.payment_load();
call staging.address_load();
call staging.city_load();
call staging.staff_load();
call staging.store_load();

