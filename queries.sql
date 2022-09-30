--  Sample employee database 
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--  
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
-- 
--  Current schema by Giuseppe Maxia 
--  Data conversion from XML to relational by Patrick Crews
-- 
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.
-- 
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 

-- DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

-- DROP TABLE IF EXISTS dept_emp,
--                     dept_manager,
 --                    titles,
 --                    salaries, 
 --                    employees, 
 --                    departments;

/*!50503 set default_storage_engine = InnoDB */;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
) 
; 

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) 
; 

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;
        
ALTER TABLE employees MODIFY emp_no int AUTO_INCREMENT;
SHOW CREATE TABLE employees;
INSERT INTO employees (birth_date, first_name, last_name, gender, hire_date) VALUES ('2003/08/30','Ezequiel','Zvirgzdins', 'M', '2022/09/22');
SELECT * FROM salaries;

SHOW CREATE TABLE salaries;
INSERT INTO salaries (emp_no, salary, from_date, to_date) VALUES (1,6000,'2003/08/30','2022/09/22');
SELECT * FROM salaries;
INSERT INTO employees (birth_date, first_name, last_name, gender, hire_date) VALUES
('1998/01/01', 'Juan', 'Parma', 'M','2020/09/22'),
('1985/3/01','Miguel', 'Chiappero', 'M','2012/11/21'),
('2000/12/20', 'Miguel','Bernardis', 'M','2003/04/19'),
('2001/06/19', 'Alex', 'Balaguer', 'M', '2021/09/22'),
('1996/06/09', 'Maria', 'Gaudalupe', 'F', '2013/05/20'),
('2002/06/06', 'Marta', 'Punset', 'F','2011/09/22'),
('1978/01/01', 'Oracio', 'Palm','M','2015/11/21'),
('1989/03/22', 'Oriana', 'Cataldo','F', '2021/09/22'),
('1988/09/02','Bernat','Pineda', 'M','2015/05/22'),
('1997/01/10','Fernando','Fernandes','M','2018/09/21');
INSERT INTO salaries (emp_no, salary, from_date, to_date) VALUES
 (1,6000,'2022/08/30','2022/09/30'),
(2,10000,'2022/08/30','2022/09/30'),
(2,10000,'2022/07/30','2022/08/30'),
(3,48000,'2022/08/30','2022/09/30'),
(4,26000,'2022/07/30','2022/08/30'),
(4,26000,'2022/08/30','2022/09/30'),
(5,20000,'2022/08/30','2022/09/30'),
(6,45000,'2022/08/30','2022/09/30'),
(7,45000,'2022/07/30','2022/08/30'),
(7,45000,'2022/08/30','2022/09/30'),
(8,45000,'2022/07/30','2022/08/30'),
(8,45000,'2022/08/30','2022/09/30'),
(9,45000,'2022/07/30','2022/08/30'),
(9,45000,'2022/08/30','2022/09/30'),
(10,45000,'2022/08/30','2022/09/30');
INSERT INTO salaries (emp_no, salary, from_date, to_date) VALUES
 (11,16000,'2022/08/30','2022/09/30');
INSERT INTO employees (birth_date, first_name, last_name, gender, hire_date) VALUES
('1992/01/01', 'Juan', 'Gimenez', 'M','2020/09/22'),
('1988/3/01','Alvaro', 'Babiera', 'M','2012/11/21'),
('2001/12/20', 'Miguel','Bernardis', 'M','2003/04/19'),
('2001/06/19', 'Pedro', 'Garcia', 'M', '2021/09/22'),
('1997/06/09', 'Maria', 'Gaudalupe', 'F', '2013/05/20');
INSERT INTO salaries (emp_no, salary, from_date, to_date) VALUES
 
 (12,16000,'2022/08/30','2022/09/30'),
(13,13000,'2022/08/30','2022/09/30'),
(14,10000,'2022/07/30','2022/08/30'),
(15,48500,'2022/08/30','2022/09/30'),
(16,46000,'2022/07/30','2022/08/30');
SHOW CREATE TABLE departments;
INSERT INTO departments (dept_no, dept_name) VALUES
 ('MARK', 'Marketing'),
('SAL', 'Sales'),
('ADMI', 'Administration'),
('DEV', 'Development'),
('HHRR', 'Human Resources');

SELECT * FROM departments;
SHOW CREATE TABLE dept_emp;
INSERT INTO dept_emp (emp_no, dept_no) VALUES 
(1,'MARK'),
(1,'ADMI'),
(2,'MARK'),
(2,'DEV'),
(3,'SAL'),
(3,'MARK'),
(4,'MARK'),
(4,'ADMI'),
(5,'MARK'),
(6,'MARK'),
(7,'MARK'),
(7,'DEV'),
(8,'MARK'),
(9,'MARK'),
(10,'DEV'),
(10,'HHRR'),
(11,'HHRR'),
(11,'SAL'),
(12,'SAL'),
(12,'MARK'),
(13,'MARK'),
(13,'SAL'),
(14,'MARK'),
(14,'DEV'),
(15,'DEV');
SELECT * FROM dept_emp;
SHOW CREATE TABLE dept_manager;
INSERT INTO dept_manager(dept_no, emp_no)VALUES
 ('MARK', 12),
('SAL', 11),
('ADMI', 4),
('DEV', 14),
('HHRR', 11);
SELECT * FROM dept_manager;
SHOW CREATE TABLE titles;

INSERT INTO titles (emp_no, title, from_date) VALUES 
(1,'FINANCES DEGREE','2018/09/21'),
(2,'SOFTWARE ENGINNERING','2020/09/11'),
(3,'SOFTWARE ENGINNERING','2020/09/21'),
(4,'PSYCHOLOGY DEGREE','2020/09/21'),
(5,'SOFTWARE ENGINNERING','2020/09/21'),
(6,'PSYCHOLOGY DEGREE','2018/09/21'),
(7,'SOFTWARE ENGINNERING','2018/09/21'),
(8,'MARKETING AND SALES DEGREE','2018/09/21'),
(9,'MARKETING AND SALES DEGREE','2018/09/18'),
(10,'SOFTWARE ENGINNERING','2018/09/21'),
(11,'PSYCHOLOGY DEGREE','2021/09/18'),
(11,'PSYCHOLOGY DEGREE','2019/09/21'),
(12,'ECONOMICS DEGREE','2018/09/19'),
(12,'MARKETING AND SALES DEGREE','2018/09/21'),
(13,'ECONOMICS DEGREE','2018/09/21'),
(14,'SOFTWARE ENGINNERING','2021/09/01'),
(15,'SOFTWARE ENGINNERING','2018/09/21');
-- obtaining the employee id--Update Row

--Change the name of an employee.
-- obtaining the employee id
SET SQL_SAFE_UPDATES=0;
UPDATE employees
SET first_name = 'Eutasio' 
WHERE first_name='Pedro' AND last_name='Garcia' AND birth_date='2001/06/19';
SET SQL_SAFE_UPDATES=1;


--('2001/06/19', 'Pedro', 'Garcia', 'M', '2021/09/22'),

UPDATE departments
SET dept_name = 'MarketingUpdatet' 
WHERE dept_no='MARK';

-- Select all employees with a salary greater than 20,000,
--  you must list all employees data and the salary.
SELECT e.emp_no, e.first_name, e.last_name, s.salary
 FROM employees e left join salaries s on e.emp_no=s.emp_no 
 WHERE s.salary>20000;
-- Select all employees with a salary below 10,000, you must list all employees data and the salary.

SELECT e.emp_no, e.first_name, e.last_name, s.salary
 FROM employees e left join salaries s on e.emp_no=s.emp_no 
 WHERE s.salary<10000;

-- Select all employees who have a salary between 14,000 and 50,000, 
-- you must list all employees data and the salary.

 SELECT e.emp_no, e.first_name, e.last_name, s.salary
 FROM employees e left join salaries s on e.emp_no=s.emp_no 
 WHERE s.salary between 14000 and 50000;


 -- Select the total number of employees
 SELECT COUNT(emp_no)
 FROM employees;


 -- Select the total number of employees who have worked in more 
 -- than one department
 SELECT e.emp_no,e.first_name,e.last_name, dt.dept_no
 FROM employees e left join dept_emp dt on e.emp_no=dt.emp_no;

 --group_by 


 -- Select the titles of the year 2020
  SELECT title, from_date FROM titles
 WHERE from_date>='2020/01/01';


 
-- Select the name, surname and name of the current department of each employee

 SELECT e.emp_no, e.first_name ,  e.last_name, d.dept_name FROM
employees e left join dept_emp dt on e.emp_no=dt.emp_no
left join departments d on dt.dept_no=d.dept_no;


-- Select the name, surname and number of times the employee has worked as a manager

--Select the name of employees without any being repeated




