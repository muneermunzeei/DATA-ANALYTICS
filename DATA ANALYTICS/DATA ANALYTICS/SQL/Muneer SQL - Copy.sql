CREATE DATABASE company_db; 
USE company_db; 
CREATE TABLE departments ( department_id   INT PRIMARY KEY, department_name VARCHAR(50) NOT NULL, location        VARCHAR(50) ); 
CREATE TABLE employees (   
  employee_id     INT PRIMARY KEY,
  first_name      VARCHAR(50),
  last_name       VARCHAR(50), 
  email           VARCHAR(100), 
  hire_date       DATE, 
  salary          DECIMAL(10,2),
  department_id   INT, 
  manager_id      INT,
  FOREIGN KEY (department_id) REFERENCES departments(department_id) );  
  
  CREATE TABLE sales ( 
  sale_id       INT PRIMARY KEY,  
  employee_id   INT, 
  sale_date     DATE,  
  product_name  VARCHAR(50), 
  amount        DECIMAL(10,2), 
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id) );  
  
INSERT INTO departments
	VALUES (1, 'Sales', 'Bengaluru'),
		   (2, 'Marketing', 'Mumbai'),
           (3, 'IT', 'Hyderabad'),
           (4, 'HR','Chennai');
           
INSERT INTO employees
	VALUES (101, 'Anil', 'Kumar',   'anil.kumar@corp.com',   '2019-03-14', 55000, 1, NULL),
		   (102, 'Divya', 'Rao',    'divya.rao@corp.com',    '2020-07-01', 48000, 1, 101), 
           (103, 'Rahul', 'Shah',   'rahul.shah@corp.com',   '2018-01-22', 62000, 2, NULL),
           (104, 'Meera', 'Nair',   'meera.nair@corp.com',   '2021-11-05', 45000, 2, 103),
           (105, 'Sanjay','Verma',  'sanjay.verma@corp.com', '2022-05-19', 51000, 3, NULL),
           (106, 'Priya', 'Iyer',   NULL,                    '2023-02-10', 47000, 3, 105),
           (107, 'Arun', 'Das',   'arundas@corp.com',         '2024-02-15', 40000, 1,NULL);
INSERT INTO sales
	VALUES (1001, 101, '2024-01-05', 'Laptop',      75000.00), 
		   (1002, 102, '2024-01-08', 'Mouse',         500.00),
           (1003, 103, '2024-01-10', 'Tablet',      32000.00),
           (1004, 104, '2024-01-12', 'Monitor',     12000.00),
           (1005, 101, '2024-02-01', 'Laptop',      78000.00),
           (1006, 105, '2024-02-03', 'Keyboard',     1500.00),
           (1007, 106, '2024-02-14', 'Monitor',     11500.00),
           (1008, 102, '2024-03-01', 'Laptop',      76000.00); 


-- All columns 
SELECT * FROM employees;
-- Specific columns 
SELECT first_name, last_name, salary FROM employees; 

-- Employees earning more than 50000
 SELECT first_name, last_name, salary FROM employees WHERE salary > 50000; 
 -- Employees in department 1, hired after 2019
 SELECT * FROM employees WHERE department_id = 1   AND hire_date > '2019-12-31'; 
 -- Pattern match: names starting with 'A'
 SELECT first_name FROM employees WHERE first_name LIKE 'A%'; 
 -- Multiple allowed values
 SELECT * FROM sales WHERE product_name IN ('Laptop', 'Tablet'); 
 
-- Highest paid employees first
 SELECT first_name, last_name, salary FROM employees ORDER BY salary DESC;
 -- Sort by department, then salary within department
 SELECT department_id, first_name, salary FROM employees ORDER BY department_id ASC, salary DESC; 
 
-- Total salary cost and headcount per department
 SELECT department_id,
		COUNT(*)  AS employee_count,
        SUM(salary)    AS total_salary,
        AVG(salary)    AS avg_salary 
        FROM employees
        GROUP BY department_id;
-- Total sales amount per product 
SELECT product_name,
 SUM(amount) AS total_revenue
 FROM sales
 GROUP BY product_name 
 ORDER BY total_revenue DESC; 
 
 
-- Departments whose average salary exceeds 48000 
SELECT department_id, AVG(salary) AS avg_salary
 FROM employees 
 GROUP BY department_id
 HAVING AVG(salary) > 48000;
 -- Products with total revenue above 20000 
 SELECT product_name, SUM(amount) AS total_revenue 
 FROM sales
 GROUP BY product_name
 HAVING SUM(amount) > 20000; 
 
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e 
INNER JOIN departments d       
  ON e.department_id = d.department_id; 
  
-- All employees, with sales details if one exists
 SELECT e.first_name, e.last_name, s.sale_id
 FROM employees e
 LEFT JOIN sales s      
		ON e.employee_id = s.employee_id;

-- Find employees with no recorded sales at all 
SELECT e.employee_id, e.first_name 
FROM employees e 
LEFT JOIN sales s   
     ON e.employee_id = s.employee_id
     WHERE s.sale_id IS NULL; 
     
-- All departments, even ones with no employees yet
 SELECT e.first_name, d.department_name 
 FROM employees e RIGHT JOIN departments d    
	ON e.department_id = d.department_id; 
    
-- FULL OUTER JOIN
select e.first_name, d.department_name
from employees e
left join departments d on e.department_id = d.department_id
union
select e.first_name, d.department_name
from employees e
right join departments d on e.department_id=d.department_id;

-- SCALAR SUBQUERY
-- Show each employee's salary next to the company-wide average 
SELECT first_name,salary,
	 (SELECT avg(salary)from employees) as company_avg_salary
from employees;

-- Employees who earn more than the average salary 
select first_name,last_name,salary
from employees
where salary> (select avg(salary) from employees);

-- Employees who have made at least one sale 
select first_name,last_name
from employees
where employee_id in (select distinct employee_id from sales);

-- Correlated Subquery 
-- Employees earning more than the average salary in their OWN department
select e1.first_name,e1.department_id,e1.salary
from employees e1
where e1.salary>(
	select avg(e2.salary)
    from employees e2
    where e2.department_id=e1.department_id
);