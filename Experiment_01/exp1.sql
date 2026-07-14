

--
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    income INT NOT NULL
);

INSERT INTO Accounts (account_id, income) VALUES 
(3, 108939), 
(2, 12747),  
(8, 87709),  
(6, 91738),  
(7, 45169);  

DROP TABLE ACCOUNTS;

SELECT 'LOW SALARY' AS CATEGORY, COUNT(ACCOUNT_ID) AS ACCOUNT_COUNT
FROM ACCOUNTS
WHERE INCOME < 20000
UNION ALL

SELECT 'AVG SALARY' AS CATEGORY, COUNT(ACCOUNT_ID) AS ACCOUNT_COUNT
FROM ACCOUNTS
WHERE INCOME >=20000 AND INCOME <=50000
UNION ALL

SELECT 'HIGH SALARY' AS CATEGORY, COUNT(ACCOUNT_ID) AS ACCOUNT_COUNT
FROM ACCOUNTS
WHERE INCOME >50000;


--B

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    dept_id INT REFERENCES Departments(dept_id)
);

CREATE TABLE Salaries (
    emp_id INT PRIMARY KEY REFERENCES Employees(emp_id) ON DELETE CASCADE,
    salary INT NOT NULL
);


INSERT INTO Departments (dept_id, dept_name) VALUES 
(10, 'HR'), (20, 'IT'), (30, 'Sales');

INSERT INTO Employees (emp_id, name, dept_id) VALUES 
(1, 'Alice', 10), (2, 'Bob', 10), (3, 'Charlie', 20), (4, 'David', 20), (5, 'Emma', 30);

INSERT INTO Salaries (emp_id, salary) VALUES 
(1, 50000), (2, 25000), (3, 80000), (4, 40000), (5, 45000);
  
  

SELECT E.name, D.dept_name, S.salary
FROM 
EMPLOYEES AS E
LEFT JOIN
DEPARTMENTS AS D
ON E.DEPT_ID = D.DEPT_ID
LEFT JOIN 
SALARIES AS S
ON E.EMP_ID = S.EMP_ID;

UPDATE SALARIES 
SET SALARY = SALARY*1.10
WHERE EMP_ID IN(
	SELECT E.EMP_ID 
	FROM EMPLOYEES AS E
	JOIN 
	DEPARTMENTS AS D
	ON E.DEPT_ID = D.DEPT_ID
	WHERE D.DEPT_NAME = 'HR'
);

SELECT EMP_NAME FROM EMPLOYEES WHERE EMP_ID = (
	SELECT EMP_ID FROM SALARIES WHERE SALARY > (
		SELEAVG(SALARY) AS AVERAGE_SALARY FROM SALARIES
	)
);

--C

CREATE TABLE pizza_toppings (
    topping_name VARCHAR(50) PRIMARY KEY,
    ingredient_cost NUMERIC(4,2) NOT NULL
);


INSERT INTO pizza_toppings (topping_name, ingredient_cost) VALUES 
('Pepperoni', 0.50),
('Sausage', 0.70),
('Chicken', 0.55),
('Onions', 0.25),
('Extra Cheese', 0.40);

SELECT CONCAT(p1.topping_name, ', ', p2.topping_name, ', ', p3.topping_name) AS PIZZA, (p1.ingredient_cost+ p2.ingredient_cost + p3.ingredient_cost) AS COST
FROM pizza_toppings p1
JOIN
pizza_toppings p2
ON p1.topping_name < p2.topping_name
JOIN
pizza_toppings p3
ON p2.topping_name < p3.topping_name
ORDER BY 
COST DESC;

--D
CREATE TABLE amazon_transactions (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    item VARCHAR(50),
    created_at TIMESTAMP NOT NULL,
    revenue INT
);
INSERT INTO amazon_transactions (id, user_id, item, created_at, revenue) VALUES 
(1, 101, 'biscuit', '2026-03-01 10:00:00', 12),
(2, 101, 'milk',    '2026-03-01 14:00:00', 5),  
(3, 101, 'bread',   '2026-03-05 09:00:00', 8),  
(4, 102, 'banana',  '2026-03-10 12:00:00', 4),
(5, 102, 'apple',   '2026-03-25 11:00:00', 6),  
(6, 103, 'milk',    '2026-03-15 08:00:00', 5),
(7, 103, 'bread',   '2026-03-16 08:00:00', 7);  

SELECT DISTINCT t1.user_id
FROM amazon_transactions t1
JOIN amazon_transactions t2
ON t1.user_id = t2.user_id
WHERE 
t1.created_at::DATE - t2.created_at::DATE <= 7 AND
t1.created_at::DATE - t2.created_at::DATE >= 1;


