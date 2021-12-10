drop database hotel;
create database hotel;
\c hotel

create table hotel_branch(branch_id varchar, name varchar, location varchar, review_rating int);
alter table hotel_branch add constraint pk_hb primary key(branch_id);
alter table hotel_branch add constraint uq_hb UNIQUE(location);
alter table hotel_branch alter column location set not null;
alter table hotel_branch add constraint ck_hb check(review_rating between 1 and 5);

create table room_category(cat_id varchar, cat_count int, name varchar, description varchar, price float);
alter table room_category add constraint pk_rc primary key(cat_id);

create or replace function correctRoomCount()
returns integer language plpgsql as $$
declare
	cat varchar;
	begin
		for cat in (select cat_id from room_category)
		loop
			if (select count(*) from room where cat_id=cat)<=(select cat_count from room_category where cat_id like cat) then return (select (1));
			else return (select (0));
			end if;
		end loop;
	end;
$$;

create table room(room_num varchar, branch_id varchar, av_not_av int, cat_id varchar);
alter table room add constraint fk_r_hb foreign key (branch_id) references hotel_branch(branch_id) on delete cascade;
alter table room add constraint pk_r primary key(room_num, branch_id);
alter table room add constraint fk_r_rc foreign key (cat_id) references room_category(cat_id) on delete cascade;
alter table room add constraint ck_r_av check(av_not_av in (0,1));
alter table room add constraint ck_r_count check(correctRoomCount()=1);
/* av_not_av=0 means room is available*/

create table customer(customer_id varchar, fname varchar, lname varchar, email varchar, street_no varchar, area varchar, city varchar, phone_no varchar(10));
alter table customer add constraint pk_cust primary key (customer_id);
alter table customer add constraint check_cust_phone check(phone_no ~ '^[0-9]{10}$');
alter table customer add constraint check_cust_email check(email ~ '^[A-Z,a-z,0-9,.,_,%,-]+@[A-Z,a-z,0-9,.,-]+[.][A-Z,a-z]+$');

create table amenities(amenities_id varchar, branch_id varchar, name varchar, description varchar, free_not_free int, am_price float default 0);
alter table amenities add constraint fk_am_hb foreign key (branch_id) references hotel_branch(branch_id) on delete cascade;
alter table amenities add constraint pk_am primary key (amenities_id, branch_id);
alter table amenities add constraint ck_am_free check(free_not_free in (0,1));
alter table amenities add constraint ck_am_price check ((am_price>0 and free_not_free=1) or (am_price=0 and free_not_free=0)); 
/* free_not_free=0 means amenity is free*/

create table uses(customer_id varchar, amenities_id varchar, branch_id varchar);
alter table uses add constraint fk_us_cust foreign key(customer_id) references customer(customer_id) on delete cascade;
alter table uses add constraint fk_us_am foreign key(amenities_id,branch_id) references amenities(amenities_id, branch_id) on delete cascade;
alter table uses add constraint pk_uses primary key (customer_id, amenities_id, branch_id);

create table booking(booking_id varchar, branch_id varchar, customer_id varchar, booking_date date, cat_id varchar);
alter table booking add constraint fk_bo_hb foreign key(branch_id) references hotel_branch(branch_id) on delete cascade;
alter table booking add constraint fk_bo_cust foreign key(customer_id) references customer(customer_id) on delete cascade;
alter table booking add constraint fk_bo_rc foreign key(cat_id) references room_category(cat_id) on delete cascade;
/*alter table booking add constraint pk_bo primary key(booking_id, branch_id, customer_id);*/
alter table booking add constraint pk_bo primary key(booking_id, branch_id);

create table billing(billing_id varchar, payment_type varchar, booking_id varchar, branch_id varchar);
/*alter table billing add constraint fk_bi_bo foreign key(booking_id, branch_id, customer_id) references booking (booking_id, branch_id, customer_id);*/
alter table billing add constraint fk_bi_bo foreign key(booking_id, branch_id) references booking (booking_id, branch_id) on delete cascade;

/*alter table billing add constraint pk_bi primary key(billing_id, branch_id, booking_id, customer_id);*/
alter table billing add constraint pk_bi primary key(billing_id, branch_id);
alter table billing add constraint ck_pay check (payment_type in ('cash', 'credit', 'cheque'));

/*create table check_in(customer_id varchar, room_num varchar, branch_id varchar, check_in_time date);*/
create table check_in(customer_id varchar, room_num varchar, branch_id varchar, check_in_time timestamp);
alter table check_in add constraint fk_ci_cust foreign key(customer_id) references customer(customer_id) on delete cascade;
alter table check_in add constraint fk_ci_room foreign key(room_num, branch_id) references room(room_num, branch_id) on delete cascade;
alter table check_in add constraint pk_ci primary key (customer_id, room_num, branch_id);


create or replace function correctDate(x timestamp, cid varchar)
returns integer language plpgsql as $$
DECLARE
 k integer;
begin
		k=0;
		if x::timestamp>=((select check_in.check_in_time from check_in where cid=check_in.customer_id)::timestamp ) then k=1;
/*else if x<=(select check_in_time from check_in,check_out where check_out.customer_id=check_in.customer_id) then k= 0;*/
		else k=0;
		end if;
		return k;
end;
$$;

create table check_out(customer_id varchar, room_num varchar, branch_id varchar, check_out_time timestamp);
alter table check_out add constraint fk_co_cust foreign key(customer_id) references customer(customer_id) on delete cascade;
alter table check_out add constraint fk_co_room foreign key(room_num, branch_id) references room(room_num, branch_id) on delete cascade;
alter table check_out add constraint pk_co primary key (customer_id, room_num, branch_id);
alter table check_out add constraint ck_co_time check (correctDate(check_out_time,customer_id)=1);


create view room_amount(customer_id,room_amt) as
 (select b.customer_id, ((co.check_out_time::date- ci.check_in_time::date) *rc.price)
	from booking as b, check_in as ci, check_out as co, room_category as rc, billing as bi
	where b.cat_id=rc.cat_id and
	ci.customer_id=co.customer_id and
	ci.customer_id=b.customer_id and
	b.booking_id=bi.booking_id);
	
create view am_amount(customer_id,am_amt) as
(
select u.customer_id, sum(a.am_price::int) 
from uses as u, amenities as a 
where u.amenities_id=a.amenities_id and u.branch_id=a.branch_id 
group by u.customer_id 
order by u.customer_id);


