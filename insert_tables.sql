\c hotel

insert into hotel_branch 
values
	('hb1', 'Lakeside Castle', 'Bengaluru'),
	('hb2', 'Lakeside Castle', 'Hyderabad'),
	('hb3', 'Lakeside Castle', 'Chennai'),
	('hb4', 'Lakeside Castle', 'Tiruvananthapuram'),
	('hb5', 'Lakeside Castle', 'Mysore');
	
insert into room_category
values
	('rc1', 7, 'Single Bedroom', '1 bed, 1 bathroom', 4999),
	('rc2', 5, 'Double Bedroom', '2 beds, 1 bathroom', 5999),
	('rc3', 5, 'Adjoining Bedrooms', '2 rooms with connecting door, each room has 1 bed, 1 bathroom', 7999),
	('rc4', 5, 'Suite', '3 rooms each with 1 bed, 1 bathroom and 1 sitting room', 19999),
	('rc5', 4, 'Presidential Suite', '2 suites with connecting door,each suite has 2 rooms each with 1 bed, 1 bathroom and 1 sitting room', 34999);
	
/*only those rooms marked 1 in which customers 1 to 8 have checked in cust 9 and 10 checked out so so their alloted room back to 0(available)*/
insert into room
values
	('001', 'hb1', 0, 'rc1'),
	('002', 'hb1', 1, 'rc1'),
	('003', 'hb1', 0, 'rc2'),
	('004', 'hb1', 1, 'rc3'),
	('005', 'hb1', 0, 'rc4'),
	('006', 'hb1', 1, 'rc5'),
	('001', 'hb2', 0, 'rc1'),
	('002', 'hb2', 1, 'rc4'),
	('003', 'hb2', 0, 'rc2'),
	('004', 'hb2', 1, 'rc3'),
	('005', 'hb2', 0, 'rc5'),
	('001', 'hb3', 1, 'rc1'),
	('002', 'hb3', 0, 'rc2'),
	('003', 'hb3', 1, 'rc3'),
	('004', 'hb3', 0, 'rc4'),
	('005', 'hb3', 1, 'rc5'),
	('001', 'hb4', 0, 'rc1'),
	('002', 'hb4', 1, 'rc2'),
	('003', 'hb4', 0, 'rc4'),
	('004', 'hb4', 1, 'rc3'),
	('001', 'hb5', 0, 'rc1'),
	('002', 'hb5', 1, 'rc1'),
	('003', 'hb5', 0, 'rc2'),
	('004', 'hb5', 1, 'rc3'),
	('005', 'hb5', 0, 'rc4'),
	('006', 'hb5', 1, 'rc5');

/*customer 9 and 10 checked out also*/
insert into customer
values
	('C01', 'Sneha','Saha','sneha@gmail.com','ST006','Mahatma Cross', 'Kolkata', '8909065467'),
	('C02', 'Sham','Bhavi','sham@gmail.com','ST109','Sam Road','Bengaluru','9655465467'),
	('C03', 'Shree','RT','shree@gmail.com','A231','Church Circle','Bengaluru','9999756677'),
	('C04', 'Sejal','Priya','sej45@gmail.com','BU8','Robert Street','Haridwar','9598786756'),
	('C05', 'Amar','Singh','rob.junior@gmail.com','S45Y','East Circle','Ranchi','9964655667'),
	('C06', 'Arjun','Kapoor','pk@gmail.com','U8OP','Jawahar Road','Shimla','8976756554'),
	('C07', 'Jhanvi','TM','parms6@gmail.com','PL09','Marks Crossing','Kashmir','9123456780'),
	('C08', 'Kushal','R','kitty78@gmail.com','ER55','Saint Park','Assam','8123547698'),
	('C09', 'Raj','Kapoor','raj8978@gmail.com','ST09','High Road Park','Delhi','8889087698'),
	('C10', 'Mukesh','SH','mukeshsh@gmail.com','FG78','Fountain Alley', 'Mumbai', '8235699088');
	
insert into amenities
values
	('A11','hb1','Coffee Kit','coffee maker, coffee and creamer',0,0),
	('A12','hb1','Personal care','combs, shaving cream, razor, shower cap, hair dryer',0,0),
	('A13','hb1','Netflix access','Stream your favorite shows through Netflix via your hotel room TVs',0,0),
	('A14','hb1','Gym and fitness center','24 hours gym service with trainer guidance',1,1999),
	('A15','hb1','Spa','24 hours spa service with experts helping you relax yourself',1,2999),
	('A11','hb2','Coffee Kit','coffee maker, coffee and creamer',0,0),
	('A12','hb2','Personal care','combs, shaving cream, razor, shower cap, hair dryer',0,0),
	('A14','hb2','Gym and fitness center','24 hours gym service with trainer guidance',1,1999),
	('A15','hb2','Spa','24 hours spa service with experts helping you relax yourself',1,2999),
	('A12','hb3','Personal care','combs, shaving cream, razor, shower cap, hair dryer',0,0),
	('A13','hb3','Netflix access','Stream your favorite shows through Netflix via your hotel room TVs',0,0),
	('A14','hb3','Gym and fitness center','24 hours gym service with trainer guidance',1,1999),
	('A15','hb3','Spa','24 hours spa service with experts helping you relax yourself',1,2999),
	('A16','hb3','Swimming Pool','24 hours use of swimming pool with lifeguards',0,0),
	('A11','hb4','Coffee Kit','coffee maker, coffee and creamer',0,0),
	('A12','hb4','Personal care','combs, shaving cream, razor, shower cap, hair dryer',0,0),
	('A13','hb4','Netflix access','Stream your favorite shows through Netflix via your hotel room TVs',0,0),
	('A14','hb4','Gym and fitness center','24 hours gym service with trainer guidance',1,1999),
	('A15','hb4','Spa','24 hours spa service with experts helping you relax yourself',1,2999),
	('A16','hb4','Swimming Pool','24 hours use of swimming pool with lifeguards',0,0),
	('A11','hb5','Coffee Kit','coffee maker, coffee and creamer',0,0),
	('A12','hb5','Personal care','combs, shaving cream, razor, shower cap, hair dryer',0,0),
	('A13','hb5','Netflix access','Stream your favorite shows through Netflix via your hotel room TVs',0,0),
	('A14','hb5','Gym and fitness center','24 hours gym service with trainer guidance',1,1999);
	
/*c01,3--hb1    c02,4--hb2   co5,7--hb3   c06--hb4   co8--hb5   --cust 9,10 checked out so entry for them*/
insert into uses
values
	('C01','A11','hb1'),
	('C02','A12','hb2'),
	('C05','A13','hb3'),
	('C06','A11','hb4'),
	('C08','A13','hb5'),
	('C03','A14','hb1'),
	('C06','A12','hb4'),
	('C04','A14','hb2'),
	('C08','A14','hb5'),
	('C01','A15','hb1'),
	('C07','A16','hb3'),
	('C07','A13','hb3'),
	('C09','A14','hb5'),
	('C02','A11','hb2');

/*c01--hb1--rc1   c03--hb1--rc3    c02--hb2--rc2  c04--hb2--rc4   co5--hb3--rc5   c07--hb3--rc2   c06--hb4--rc3   co8--hb5--rc1   c09--*/
insert into booking 
values
	('BK010','hb1','C01','2021-10-01','rc1'),
	('BK020','hb2','C02','2021-09-11','rc2'),
	('BK030','hb1','C03','2021-09-21','rc3'),
	('BK040','hb2','C04','2021-10-09','rc4'),
	('BK050','hb3','C05','2021-10-05','rc5'),
	('BK060','hb4','C06','2021-09-19','rc3'),
	('BK070','hb3','C07','2021-10-09','rc2'),
	('BK080','hb5','C08','2021-08-20','rc1'),
	('BK090','hb5','C09','2021-07-01','rc5'),
	('BK091','hb4','C10','2021-02-28','rc4');
	
insert into billing
values
/* only cust 9 and 10 checked out now so bill generated for those 2 only now .. these for later use     
	('b991','cash','BK010','hb1','C01'),
	('b992','credit','BK020','hb2','C02'),
	('b993','cheque','BK030','hb1','C03'),
	('b994','credit','BK040','hb2','C04'),
	('b995','credit','BK050','hb3','C05'),
	('b996','cheque','BK060','hb4','C06'),
	('b997','credit','BK070','hb3','C07'),
	('b998','cash','BK080','hb5','C08');*/
	('b899','cash','BK090','hb5'),
	('b990','credit','BK091','hb4');
	


insert into check_in
values
	('C01','002','hb1','2021-10-01 06:23:54'),
	('C02','003','hb2','2021-09-11 09:07:23'),
	('C03','004','hb1','2021-09-21 10:39:14'),
	('C04','002','hb2','2021-10-09 11:13:06'),
	('C05','005','hb3','2021-10-05 04:53:54'),
	('C06','004','hb4','2021-09-19 06:23:37'),
	('C07','002','hb3','2021-10-09 06:12:57'),
	('C08','001','hb5','2021-08-20 08:56:54'),
	('C09','006','hb5','2021-07-01 11:11:09'),
	('C10','003','hb4','2021-02-02 09:09:59');
	
insert into check_out
values
	('C09','006','hb5','2021-07-29 10:06:03'),
	('C10','003','hb4','2021-02-06 10:07:45');

	
	
	
	
	
