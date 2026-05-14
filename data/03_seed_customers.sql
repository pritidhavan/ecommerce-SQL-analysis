-- =====================================================
--   Seed Data — Customers
-- =====================================================
USE ecommerce_db;
 
INSERT INTO customers (first_name, last_name, email, phone, city, state, age, gender, signup_date) VALUES
('Priya','Sharma','priya.sharma@gmail.com','9876543210','Mumbai','Maharashtra',28,'Female','2021-01-15'),
('Rahul','Verma','rahul.verma@gmail.com','9876543211','Delhi','Delhi',32,'Male','2021-02-20'),
('Anjali','Singh','anjali.singh@gmail.com','9876543212','Bangalore','Karnataka',25,'Female','2021-03-10'),
('Amit','Kumar','amit.kumar@gmail.com','9876543213','Pune','Maharashtra',35,'Male','2021-01-25'),
('Sneha','Patel','sneha.patel@gmail.com','9876543214','Ahmedabad','Gujarat',29,'Female','2021-04-05'),
('Vikram','Nair','vikram.nair@gmail.com','9876543215','Chennai','Tamil Nadu',31,'Male','2021-05-12'),
('Neha','Gupta','neha.gupta@gmail.com','9876543216','Hyderabad','Telangana',27,'Female','2021-06-18'),
('Arjun','Mehta','arjun.mehta@gmail.com','9876543217','Kolkata','West Bengal',33,'Male','2021-07-22'),
('Pooja','Joshi','pooja.joshi@gmail.com','9876543218','Jaipur','Rajasthan',24,'Female','2021-08-30'),
('Rohit','Agarwal','rohit.agarwal@gmail.com','9876543219','Lucknow','Uttar Pradesh',36,'Male','2021-09-14'),
('Kavya','Reddy','kavya.reddy@gmail.com','9876543220','Hyderabad','Telangana',26,'Female','2021-10-08'),
('Suresh','Pillai','suresh.pillai@gmail.com','9876543221','Kochi','Kerala',40,'Male','2021-11-19'),
('Meera','Iyer','meera.iyer@gmail.com','9876543222','Chennai','Tamil Nadu',30,'Female','2021-12-25'),
('Deepak','Chauhan','deepak.chauhan@gmail.com','9876543223','Noida','Uttar Pradesh',28,'Male','2022-01-10'),
('Ritu','Mishra','ritu.mishra@gmail.com','9876543224','Bhopal','Madhya Pradesh',23,'Female','2022-02-14'),
('Karan','Kapoor','karan.kapoor@gmail.com','9876543225','Mumbai','Maharashtra',34,'Male','2022-03-20'),
('Divya','Menon','divya.menon@gmail.com','9876543226','Bangalore','Karnataka',29,'Female','2022-04-15'),
('Sanjay','Rao','sanjay.rao@gmail.com','9876543227','Pune','Maharashtra',37,'Male','2022-05-08'),
('Ananya','Das','ananya.das@gmail.com','9876543228','Kolkata','West Bengal',22,'Female','2022-06-12'),
('Vijay','Tiwari','vijay.tiwari@gmail.com','9876543229','Varanasi','Uttar Pradesh',45,'Male','2022-07-25'),
('Lakshmi','Krishnan','lakshmi.krishnan@gmail.com','9876543230','Chennai','Tamil Nadu',31,'Female','2022-08-18'),
('Manish','Saxena','manish.saxena@gmail.com','9876543231','Agra','Uttar Pradesh',38,'Male','2022-09-05'),
('Sunita','Pandey','sunita.pandey@gmail.com','9876543232','Patna','Bihar',27,'Female','2022-10-22'),
('Aakash','Shah','aakash.shah@gmail.com','9876543233','Surat','Gujarat',32,'Male','2022-11-30'),
('Nisha','Bajaj','nisha.bajaj@gmail.com','9876543234','Nagpur','Maharashtra',26,'Female','2022-12-10'),
('Rajesh','Khanna','rajesh.khanna@gmail.com','9876543235','Delhi','Delhi',42,'Male','2023-01-08'),
('Swati','Dubey','swati.dubey@gmail.com','9876543236','Indore','Madhya Pradesh',28,'Female','2023-02-20'),
('Nikhil','Jain','nikhil.jain@gmail.com','9876543237','Jaipur','Rajasthan',33,'Male','2023-03-15'),
('Preeti','Bose','preeti.bose@gmail.com','9876543238','Kolkata','West Bengal',25,'Female','2023-04-18'),
('Gaurav','Sinha','gaurav.sinha@gmail.com','9876543239','Ranchi','Jharkhand',30,'Male','2023-05-22');
 
SELECT CONCAT('Customers inserted: ', COUNT(*)) AS status FROM customers;