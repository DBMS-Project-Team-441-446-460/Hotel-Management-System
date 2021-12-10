import streamlit as st
import psycopg2
import pandas as pd


# Security
#passlib,hashlib,bcrypt,scrypt
import hashlib
def make_hashes(password):
	return hashlib.sha256(str.encode(password)).hexdigest()

def check_hashes(password,hashed_text):
	if make_hashes(password) == hashed_text:
		return hashed_text
	return False

# DB Management
conn = psycopg2.connect(database="hotel",
                        user="shree",
                        password="postgres",
                        host="localhost",
                        port="5432")
                        
c = conn.cursor()
# DB  Functions



def create_usertable():
	c.execute('CREATE TABLE IF NOT EXISTS userstable(username varchar,password varchar)')


def add_userdata(username,password):
	c.execute('INSERT INTO userstable(username,password) VALUES (%s,%s)',(username,password))
	conn.commit()

def login_user(username,password):
	c.execute('SELECT * FROM userstable WHERE username =%s AND password = %s',(username,password))
	data = c.fetchall()
	return data

def view_all_users():
	c.execute('SELECT * FROM userstable')
	data = c.fetchall()
	return data

def get_room_list(password):
	c.execute('SELECT * FROM room where branch_id = %s',(password,))
	data = c.fetchall()
	return data

def get_booking_list(password):
	c.execute('SELECT * FROM booking where branch_id = %s',(password,))
	data = c.fetchall()
	return data

def get_user_room_list(username):
	c.execute('Select branch_id from booking where customer_id = %s',(username,))
	data = c.fetchall()
	c.execute('select * from room where branch_id =%s and av_not_av = 0',(str(data[0][0]),))
	d=c.fetchall()
	return d

def get_user_amenities_list(username):
	c.execute('Select branch_id from booking where customer_id =%s',(username,))
	data=c.fetchall()
	c.execute('select * from amenities where branch_id =%s',(str(data[0][0]),))
	d = c.fetchall()
	return d

def get_manager_amenities_list(hb):
	c.execute('select * from amenities where branch_id =%s',(hb,))
	d = c.fetchall()
	return d

def add_amenities(hb,name, des, amt):
	fnf=1
	if amt==0:
		fnf=0
	
	c.execute('select amenities_id from amenities where branch_id=%s',(hb,))
	data=c.fetchall()
	data.sort()
	largest_id =data[-1][0]
	am_id= largest_id[0]+str(int(largest_id[1:])+1)
	c.execute(" INSERT INTO amenities(amenities_id, branch_id, name, description,free_not_free,am_price) VALUES ('%s','%s','%s','%s','%d','%f') " %(am_id,hb,name,des,fnf,amt))
	conn.commit()

def book_user_amenities(cust_id,am_id):
	c.execute('Select branch_id from booking where customer_id =%s',(cust_id,))
	data=c.fetchall()
	c.execute("INSERT INTO uses(customer_id, amenities_id, branch_id) VALUES ('%s','%s','%s')" %(cust_id,am_id,str(data[0][0])))
	conn.commit()

def am_already_booked_user(cust_id):
	am=[]
	c.execute('Select amenities_id from uses WHERE customer_id = %s',(cust_id,))
	for i in c.fetchall():
		am.append(i[0])
	return am
	
def get_room_amt(cid):
	c.execute('select b.customer_id, ((co.check_out_time::date- ci.check_in_time::date) *rc.price) as "room_amt" from booking as b, check_in as ci, check_out as co, room_category as rc, billing as bi where b.cat_id=rc.cat_id and ci.customer_id=co.customer_id and ci.customer_id=b.customer_id and b.booking_id=bi.booking_id and b.customer_id =%s',(cid,))	
	d = c.fetchall()
	return d

def get_am_amt(cid):

	c.execute('select u.customer_id, sum(a.am_price::int) as am_amt from uses as u, amenities as a where u.amenities_id=a.amenities_id and u.branch_id=a.branch_id and u.customer_id=%s group by u.customer_id order by u.customer_id',(cid,))	
	d = c.fetchall()
	return d

def get_amt(cid):

	c.execute('select customer_id, sum(amount) as Total_Amount from ((select customer_id, room_amt as "amount" from room_amount ) union (select a.customer_id, am_amt as "amount" from am_amount as a,room_amount as b where a.customer_id=b.customer_id )) Amount group by customer_id having customer_id=%s',(cid,))	
	d = c.fetchall()
	return d
	
def no_of_amenities(mgrid):
	c.execute('select branch_id, count(amenities_id) from amenities where branch_id=%s group by branch_id order by count(amenities_id)',(mgrid,))
	d = c.fetchall()
	return d

def no_of_customers(mgrid):
	c.execute('select branch_id, count(customer_id) from booking where branch_id=%s group by branch_id order by branch_id',(mgrid,))
	d = c.fetchall()
	return d

def name_of_customers(bid):
	c.execute('select b.branch_id, c.fname from customer as c, booking as b where b.branch_id=%s and b.customer_id=c.customer_id and c.customer_id not in (select customer_id from uses)',(bid,))
	d = c.fetchall()
	return d

def name1_of_customers(mgrid):
	c.execute('select c.fname,count(u.amenities_id),u.branch_id from customer as c, uses as u where u.customer_id=c.customer_id and u.branch_id=%s group by c.fname,u.branch_id having count(u.amenities_id)>1 order by u.branch_id',(mgrid,))
	d = c.fetchall()
	return d

def num_of_rooms(mgrid):
	c.execute('select r.branch_id, count(r.av_not_av) from room as r where r.av_not_av=1 and r.branch_id=%s group by (r.branch_id)',(mgrid,))
	d = c.fetchall()
	return d


def main():

	st.title("Hotel Management System")

	menu = ["Home","Login","SignUp"]
	choice = st.sidebar.selectbox("Menu",menu)

	if choice == "Home":
		st.subheader("Home")

	elif choice == "Login":
		st.subheader("Login Section")

		username = st.sidebar.text_input("User Name")
		password = st.sidebar.text_input("Password",type='password')
		if st.sidebar.checkbox("Login"):
			# if password == '12345':
			create_usertable()
			hashed_pswd = make_hashes(password)

			result = login_user(username,check_hashes(password,hashed_pswd))
			if result:

				st.success("Logged In As {}".format(username))

				if username=="Manager":

					task = st.selectbox("Task",["","View Rooms","View Booking","Profiles","View Amenities","Add Amenities","Search"])
					if task == "":
						st.subheader("")

					elif task == "View Rooms":
						st.subheader("Room List")
						customer_list = get_room_list(password)
						clean_db = pd.DataFrame(customer_list,columns=["Room No.","Branch ID","Av/Not Av","Category ID"])
						st.dataframe(clean_db)

					elif task == "View Booking":
						st.subheader("Booking List")
						book_list = get_booking_list(password)
						clean_db = pd.DataFrame(book_list,columns=["Booking ID","Branch ID","Customer ID","Booking Date","Category ID"])
						st.dataframe(clean_db)

					elif task == "Profiles":
						st.subheader("Signed up Users")
						user_result = view_all_users()
						clean_db = pd.DataFrame(user_result,columns=["Username","Password"])
						st.dataframe(clean_db)
						
					elif task == "View Amenities":
						st.subheader("Amenities List")
						am_list = get_manager_amenities_list(password)
						clean_db = pd.DataFrame(am_list,columns=["Amenities ID","Branch ID","Name","Description","Free/Not Free","Amount"])
						st.dataframe(clean_db)
						
					elif task == "Add Amenities":
						st.subheader("Add an amenity for your branch")
						name = st.text_input('Enter the name of the new amenity:')
						des = st.text_input('Enter the description of the amenity:')
						amt = st.number_input('Enter the amount: ')						
						if st.button("Add"):
							add_amenities(password,name,des,amt)
							st.success("You have successfully added a new amenity")
							st.info("Select View Amenities to see the updated list")
					
					elif task=="Search":
						if st.button("Number of Amenities in the Branch"):
							number1 = no_of_amenities(password)
							nof_amenitie_table= pd.DataFrame(number1,columns=["Branch ID","Number of Amenities"])
							st.dataframe(nof_amenitie_table)
						if st.button("Number of Customers in the Branch"):
							number = no_of_customers(password)
							nof_customer_table= pd.DataFrame(number,columns=["Branch ID","Number of Customers"])
							st.dataframe(nof_customer_table)
						if st.button("Name of the customers who have not used amenities"):
							name = name_of_customers(password)
							name_table= pd.DataFrame(name,columns=["Branch ID","Name of Customer"])
							st.dataframe(name_table)
						if st.button("Name of the customers who have used more that one amenities"):
							name1 = name1_of_customers(password)
							name1_table= pd.DataFrame(name1,columns=["Name of Customer","Number of amenities","Branch ID"])
							st.dataframe(name1_table)
						if st.button("Number of rooms available"):
							name2 = num_of_rooms(password)
							name2_table= pd.DataFrame(name2,columns=["Branch ID","Number of Rooms"])
							st.dataframe(name2_table)

					
				else:
					task = st.selectbox("Task",["","View Rooms","View Amenities","Search"])
					if task == "":
						st.subheader("")

					elif task == "View Rooms":
						st.subheader("Room List")
						customer_list = get_user_room_list(username)
						clean_db = pd.DataFrame(customer_list,columns=["Room No.","Branch ID","Av/Not Av","Category ID"])
						st.dataframe(clean_db)
					
					elif task=="View Amenities":
						
						am_id = st.text_input('Enter Amenity ID')
						if st.button("Book"):
							if am_id in am_already_booked_user(username):
								st.info("You have already booked this amenity! Please choose another amenity from the list")

							else:
								book_user_amenities(username,am_id)
								st.success("You have successfully booked an amenity")
						st.subheader("Amenities List")
						am_list = get_user_amenities_list(username)
						clean_db = pd.DataFrame(am_list,columns=["Amenities ID","Branch ID","Name","Description","Free/Not Free","Amount"])
						st.dataframe(clean_db)
					
					elif task=="Search":
						if st.button("Get Room Amount"):
							room_amt=get_room_amt(username)
							room_table= pd.DataFrame(room_amt,columns=["Customer ID","Room Amount"])
							st.dataframe(room_table)
						if st.button("Get Amenities Amount"):
							am_amt=get_am_amt(username)
							am_table= pd.DataFrame(am_amt,columns=["Customer ID","Amenities Amount"])
							st.dataframe(am_table)
						if st.button("Get Total Amount"):
							amt=get_amt(username)
							amt_table= pd.DataFrame(amt,columns=["Customer ID","Total Amount"])
							st.dataframe(amt_table)
							

			else:
				st.warning("Incorrect Username/Password")


	elif choice == "SignUp":
		st.subheader("Create New Account")
		new_user = st.text_input("Username")
		new_password = st.text_input("Password",type='password')

		if st.button("Signup"):
			create_usertable()
			add_userdata(new_user,make_hashes(new_password))
			st.success("You have successfully created a valid Account")
			st.info("Go to Login Menu to login")



if __name__ == '__main__':
	main()
