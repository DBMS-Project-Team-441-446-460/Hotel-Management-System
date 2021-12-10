\c hotel;

/* Retrieve the names of all customers who have used more than 1 amenity. It should be sorted by number of amenities used*/
select c.fname,count(u.amenities_id),u.branch_id 
from customer as c, uses as u 
where u.customer_id=c.customer_id 
group by c.fname,u.branch_id 
having count(u.amenities_id)>1 
order by u.branch_id;

/*Retrive all branches that have more than 2 rooms available and how many rooms are available*/
select r.branch_id, count(r.av_not_av) 
from room as r 
where r.av_not_av=1 
group by (r.branch_id) 
having count(r.av_not_av)>2 
order by r.branch_id;

/*Combined into one*/
/*find billing amount for rooms for customer*/
select b.customer_id, ((co.check_out_time::date- ci.check_in_time::date) *rc.price) as "room_amt"
from booking as b, check_in as ci, check_out as co, room_category as rc, billing as bi
where b.cat_id=rc.cat_id and
	  ci.customer_id=co.customer_id and
	  ci.customer_id=b.customer_id and
	  b.booking_id=bi.booking_id;
	  
/*find amenities amount for each customer*/
select u.customer_id, sum(a.am_price::int) as am_amt
from uses as u, amenities as a 
where u.amenities_id=a.amenities_id and u.branch_id=a.branch_id 
group by u.customer_id 
order by u.customer_id;

/*Find total amount*/
select customer_id, sum(amount) as Total_Amount
from ((select customer_id, room_amt as "amount"
       from room_amount
      ) union
      (select a.customer_id, am_amt as "amount"
       from am_amount as a,room_amount as b where a.customer_id=b.customer_id
      )
     ) Amount
group by customer_id;


/*Find number of amenities in each branch*/
select branch_id, count(amenities_id) 
from amenities 
group by branch_id
order by count(amenities_id);

/*Find number of customers in each branch*/
select branch_id, count(customer_id) 
from booking 
group by branch_id 
order by branch_id;

/*Find the customers who have not used any amenities*/
select fname 
from customer 
where customer_id 
not in 
	(select customer_id from uses);
