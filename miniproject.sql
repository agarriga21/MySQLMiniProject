#Add a couple columns to the sales table, time stamp and quantity
#Use alter and update commands to add the columns and update the rows
drop database miniproject;

CREATE database miniproject;
Use miniproject;

CREATE TABLE locations(
locationid int auto_increment,
city varchar(50) not null,
state char(2) not null,
address varchar(50) unique,
zipcode int not null,
`type` varchar(50),
check (state IN("TX","OK","LA")),
primary key(locationid)
);


CREATE TABLE employees(
empid int auto_increment,
firstname varchar(50),
lastname varchar(50),
email varchar(50),
locationid int,
`role` varchar(50) not null,
managerid int,
salary decimal(65,2),
Check (salary between 0 and 1000000),
primary key(empid),
FOREIGN KEY (locationid) REFERENCES locations(locationid)
);


CREATE TABLE customers(
custid int auto_increment,
firstname varchar(50),
lastname varchar(50),
email varchar(50),
phone varchar(50),
DOB date,
age int,
check (TIMESTAMPDIFF(YEAR, DOB, "2023-01-09") > 10 ),
primary key(custid)
);

CREATE TABLE products(
prodid int auto_increment,
prodname varchar(50) not null,
prodtype varchar(50),
inventory int not null,
buyprice decimal(65,2) not null,
msrp decimal(65,2) not null,
Check (buyprice >0),
Check (msrp >0),
primary key(prodid)
);


CREATE TABLE sales(
ID int auto_increment,
custid int not null,
prodid int not null,
empid int not null,
locationid int not null,
quantity int not null,
purchasetime datetime,
primary key(ID),
FOREIGN KEY (custid) REFERENCES customers(custid),
FOREIGN KEY (prodid) REFERENCES products(prodid),
FOREIGN KEY (empid) REFERENCES employees(empid),
FOREIGN KEY (locationid) REFERENCES locations(locationid)
);

Select * From sales;

#insert data
Insert into locations(city,state,address,zipcode,`type`)
Values ('San Antonio','TX','Earl Drive','78260','Store'),
('Austin','TX','6th St','78716','Store'),
('Waco','TX','Baylor Drive','78260','Store'),
('Tulsa','OK','True Street','74104','Store'),
('San Antonio','TX','Elmo Street','78203','Warehouse'),
('San Antonio','TX','Oak Street','78250','Office');


Select * From locations;
update locations set locationid = locationid +6;

Insert into employees(firstname,lastname,email,locationid,`role`,managerid,salary)
Values ('Jose','Gonzales','Jgonz@gmail.com',12,'CEO',null,300000),
('James','Smith','Smithers@yahoo.com',12,'VP',1,200000),
('John','Smith','John@yahoo.com',7,'Manager',2,120000),
('Amy','Gomez','Amyyy@gmail.com',7,'Sales Associate',3,75000),
('Jacob','Frank','JF@yahoo.com',7,'Sales Associate',3,60000),
('John','Adams','jonny@aol.com',7,'Sales Associate',3,55000),
('Edward','Eaton','EEEE@yahoo.com',8,'Manager',2,110000),
('Larry','Lobster','Livlarry@gmail.com',8,'Sales Associate',7,72000),
('Hailey','Munoz','Hbomb@aol.com',9,'Manager',2,100000),
('Manuel','Gomez','Man@gmail.com',9,'Sales Associate',9,58000),
('Jessica','Kent','Jessica@yahoo.com',10,'Manager',2,130000),
('Adam','Goodyear','tireman@gmail.com',10,'Sales Associate',11,45000);

Select * From employees;

Alter Table employees
ADD FOREIGN KEY (managerid) REFERENCES employees(empid);



Insert into customers(firstname,lastname,email,phone,DOB,age)
Values ('Tony','Hall','Thall@gmail.com','210-453-7874',"2003-01-09",TIMESTAMPDIFF(YEAR, "2003-01-09", curdate()));

Insert into customers(firstname,lastname,email,phone,DOB,age)
Values
('Tim','Jenkins','jenkies@gmail.com','210-421-4444',"2002-01-01",99),
('Hadly','Hall','Hhall@gmail.com','210-233-9051',"1996-05-09",99),
('Guy','Goodwin','Thegoods@gmail.com','210-555-7112',"2005-02-12",99),
('Paul','Stevens','paulup@gmail.com','512-333-7321',"1993-05-05",99),
('Madelyn','Mathews','Madss@gmail.com','512-689-4024',"1940-02-15",99),
('Bob','Billy','billybobs@gmail.com','214-553-8852',"1991-03-09",99),
('Andrew','Shultz','Adnys@gmail.com','214-217-9000',"1975-12-12",99),
('Dillon','Cox','dillpickle@gmail.com','539-734-1125',"2000-12-30",99),
('Patrick','Scar','PGotscars@gmail.com','539-134-8364',"2000-01-09",99);

Select * From customers;

Update customers set age = TIMESTAMPDIFF(YEAR, DOB, curdate()) where age=99;

Insert into products(prodname,prodtype,inventory,buyprice,msrp)
Values ('Toy Car','Toys',1000,.25,2.25),
('Lego Set','Toys',268,5.00,25.99),
('Barbie Doll','Toys',798,2.00,9.99),
('Oat Bar','Food',2743,.10,.99),
('Protein Powder','Food',245,5.00,33.99),
('Noodles','Food',1324,.15,1.99),
('Desk chair','Furniture',43,15.25,59.99),
('Foldable Table','Furniture',84,10.00,39.99),
('Foldable Chair','Furniture',202,5.25,19.99),
('T-shirt','Clothing',3652,3.50,14.99),
('Shorts','Clothing',2853,5.00,14.99),
('Skirt','Clothing',1463,6.25,14.99),
('Hats','Clothing',1400,2.00,9.99);

Select * From products;

#drop PROCEDURE GenerateSales;

DELIMITER $$
CREATE PROCEDURE GenerateSales
(
IN num int
)
BEGIN
	DECLARE lid INT;
    DECLARE cid INT;
    DECLARE pid INT;
    DECLARE eid INT;
	DECLARE x INT;
    DECLARE y INT;
    DECLARE q INT;
    SET x = 1;
    
   IF num is null THEN
        SET num = 1;
        end if;
    
    insert_loop:  LOOP
		IF  x > num THEN 
        Select (x-1) as "# of sales rows added";
			LEAVE  insert_loop;
		END  IF;
		
        SET pid = null;
        SET q = null;
        SET y = null;
        SET lid = null;
        SET eid = null;
        SET cid = null;
        
        SET  pid = Round(rand()*12)+1;
        SET q =  Round(rand()*24)+1;
        #handle inventory
        If q <= (Select inventory from products where prodid=pid)
        THEN
        Update products SET inventory = (inventory-q) where prodid=pid;
        else
        Select (x-1) as "# of sales rows added","Generation stopped due to empty inventory on product:",pid;
			LEAVE  insert_loop;
            END IF;
        
        SET  y= Round(rand());
        
         #random variable to boost San Antonio location
        IF y=1 THEN
        SET lid = 7;
        Else
        SET  lid = Round(rand()*3)+7;
        end if;
        
         #random employee depending on location
        IF  lid = 7 THEN 
			SET  eid = Round(rand()*3)+3;
		elseif lid = 8 THEN 
			SET  eid = Round(rand())+7;
		elseif lid = 9 THEN 
			SET  eid = Round(rand())+9;
		else
        SET  eid = Round(rand())+11;
		END  IF;
        
        #random customer depending on location
       IF  lid = 7 THEN 
			SET  cid = Round(rand()*3)+1;
		elseif lid = 8 THEN 
			SET  cid = Round(rand())+5;
		elseif lid = 9 THEN 
			SET  cid = Round(rand())+7;
		else
        SET  cid = Round(rand())+9;
		END  IF;
        
        
INSERT INTO sales (custid,prodid,empid,locationid,quantity,purchasetime)
VALUES (cid,pid,eid,lid,q,Now());
	SET  x = x + 1;	
	END LOOP;
	
END$$
DELIMITER ;

Call GenerateSales(1000);

#truncate table sales;

Select * From sales;
Select * From products;
Select count(*) From sales;
#quick inventory add
Update products Set inventory=(inventory +200);

#Detailed sales table
Create View Sales_Details AS
Select concat(c.firstname," ",c.lastname) as "Customer Name",
prodname as "Product Name",
concat(e.firstname," ",e.lastname) as "Employee Name",
concat(city,", ",state) as "Location",
quantity as "Quantity Purchased",
concat('$',format(quantity*p.msrp,2)) as "Total Price",
purchasetime as "Time of Purchase",
concat('$',format((quantity*p.msrp)-(quantity*p.buyprice),2)) as "Store Profit"
From sales
inner join customers c using(custid)
inner join products p using(prodid)
inner join employees e using(empid)
inner join locations l ON sales.locationid = l.locationid
#Order by ((quantity*p.msrp)-(quantity*p.buyprice))
#desc
;

Select `Total Price`,Cast(REPLACE(`Total Price`, "$", "") as DECIMAL(5,2)) AS "Decimal Price Only" From Sales_Details;

Select * From Sales_Details
order by  Cast(REPLACE(`Total Price`, "$", "") as DECIMAL(5,2))
desc;

Select locationid,count(ID) as "Total Sales"
From sales
Group by sales.locationid
Order by count(ID)
desc;

#Total Sales by location
Select
concat(city,", ",state) as "Location",
count(ID) as "Total Sales"
From sales
inner join locations l ON sales.locationid = l.locationid
Group by sales.locationid
Order by count(ID)
desc;

#Total Store Profit by location
Select
concat(city,", ",state) as "Location",
concat('$',format(sum((quantity*p.msrp)-(quantity*p.buyprice)),2)) as "Total Store Profit"
From sales
inner join products p using(prodid)
inner join locations l ON sales.locationid = l.locationid
Group by sales.locationid
Order by sum(((quantity*p.msrp)-(quantity*p.buyprice)))
desc;

#Amount spent and quantity per customer
Select concat(c.firstname," ",c.lastname) as "Customer Name",
sum(quantity) as "Total Quantity Products Purchased",
concat('$',format(sum(quantity*p.msrp),2)) as "Total Price Spent"
From sales
inner join customers c using(custid)
inner join products p using(prodid)
Group by c.custid
Order by sum(quantity*p.msrp)
desc;

#Employees evaluation of number of sales, amount per sale, and revenue
Select
concat(e.firstname," ",e.lastname) as "Employee Name",
count(ID) as "Total Sales",
concat('$',format(sum(quantity*p.msrp),2)) as "Total Sales Price",
concat('$',format(sum((quantity*p.msrp)-(quantity*p.buyprice)),2)) as "Total Revenue"
From sales
inner join products p using(prodid)
inner join employees e using(empid)
group by empid
Order by sum((quantity*p.msrp)-(quantity*p.buyprice))
desc;

SELECT concat(e1.firstname," ",e1.lastname) AS "Employee Name", 
concat(e2.firstname," ",e2.lastname) AS "Manager Name"
FROM employees e1, employees e2
WHERE e1.managerid = e2.empid
ORDER BY e2.empid;


#Trigger for salary audit
CREATE TABLE salary_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empid INT NOT NULL,
    oldsalary Decimal(65,2) NOT NULL,
    newsalary Decimal(65,2) NOT NULL,
    changedat DATETIME DEFAULT NULL
);

Select * From salary_audit;

#Create Trigger update
DELIMITER $$
CREATE TRIGGER before_salary_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
    BEGIN
    IF NEW.salary <> OLD.salary THEN
 INSERT INTO salary_audit
 SET
     empid = OLD.empid,
     oldsalary = OLD.salary,
     newsalary = NEW.salary,
     changedat = NOW();
END IF;
END$$


#test
Update employees set salary=round(salary*.05+salary,2) where `role`= "VP";
Update employees set salary= round(salary*.03+salary,2) where `role`= "Manager";

Select * From salary_audit;

Update employees set email = 'Testing@test.com' where empid=10;

SELECT concat(e1.firstname," ",e1.lastname) AS "Employee Name",
e1.`role` as  "Employees Role",
concat(e2.firstname," ",e2.lastname) AS "Supervisors Name",
e2.`role` as  "Supervisors Role", 
concat(city,", ",state) as "Location",
concat('$',format(sum(quantity*p.msrp),2)) as "Total Sales Price",
concat('$',format(sum((quantity*p.msrp)-(quantity*p.buyprice)),2)) as "Total Revenue"
FROM employees e1
Left join employees e2 ON e1.managerid = e2.empid
Left join sales ON sales.empid = e1.empid
Left join products p using(prodid)
Inner join locations l ON e1.locationid = l.locationid
group by e1.empid
ORDER BY e2.empid;




Select avg(salary) from employees;

Select sum(salary) from employees group by `role`;

