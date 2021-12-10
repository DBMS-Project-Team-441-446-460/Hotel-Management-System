\c hotel;

create user customer with password 'cust';
grant connect on database hotel to customer;
grant select on hotel_branch, amenities, booking, billing to customer;
/*create view hb_review as select review_rating from hotel_branch;
grant all on hb_review to customer;*/
grant update(review_rating) on hotel_branch to customer;
/*grant select, insert on customer to customer;*/ /*If customer needs to update, he needs to talk to the manager, becuase he shouldn't be allowed to modify other customer's details*/


/*To test
select * from hotel_branch;
update hotel_branch set review_rating=4 where branch_id='hb1';
select * from room;
*/


create user manager with password 'man';
grant connect on database hotel to manager;

grant select, insert, update on customer to manager; /*Manager can update customer details at customer's request*/


grant select, insert, update on uses to manager; /*Manager can update, insert amentities being used by customers at customer's request*/
grant select, insert, update on check_in, check_out to manager; /*Manager can insert update customers checking in , checking out*/

grant select, update(av_not_av) on room to manager; /*He should just be able to change the availability/ non availability and not other attributes like count, category of room*/

grant select on hotel_branch, booking, billing, amenities, room_category to manager; /*Room_categoty has only select permissions because being strong entity ig room_category and it's attributes should be fixed and unchangeable just like hotel_branch as it now being a strong entity is not changing branch wise*/



create user admin with password 'admin';
grant connect on database hotel to admin;

/*administrators can manage booking details, add booking , edit reservations */
grant all on booking to admin;

/* administrator can add an unlimited number of room types, add description,change count etc*/
grant all on room_category to admin;
grant all on room to admin;

/*administrator is responsible for the billing process*/
grant all on billing to admin; 


/*administrator ia allowed to view review rating*/
create view rating as select review_rating from hotel_branch;
grant select on rating to admin;

create view branch as select branch_id , name , location from hotel_branch;
grant all on branch to admin;

/* He can alter customer_id but not the name,adress,phoneno etc.*/
create view cusid as select customer_id from customer;
grant all on cusid to admin;



