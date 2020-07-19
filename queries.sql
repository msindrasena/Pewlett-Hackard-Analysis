-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR(10) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL, 
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;
SELECT * from dept_manager;
SELECT * FROM dept_emp;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Retirement eligibility and export
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no, 
	e.first_name, 
e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN DEPT_EMP AS DE
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info;

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- SKILL DRILL 1
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	d.dept_name
INTO sales_info
FROM employees as e
INNER JOIN Dept_Emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN Departments as d
ON (de.dept_no = d.dept_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01')
AND (d.dept_name = 'Sales');

SELECT * FROM sales_info

-- SKILL DRILL 2
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	d.dept_name
INTO mentors_info
FROM employees as e
INNER JOIN Dept_Emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN Departments as d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development')
AND (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01')

-- Beginning of Module Challenge, Deliverable 1: Number of Retiring Employees by title

--1.1 Titles Retiring - Shows 7 Titles Retiring
SELECT COUNT (t.title), t.title
INTO number_titles_retiring
FROM emp_info as rei
inner JOIN titles as t
ON (rei.emp_no = t.emp_no )
GROUP BY t.title;

-- Number of Titles Retiring
SELECT COUNT(title)
FROM number_titles_retiring;

-- 1.2 Employees with Each Title
SELECT COUNT (e.emp_no), t.title
INTO number_employees_each_title
FROM employees as e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
AND (de.to_date = '9999-01-01')
GROUP BY t.title;

-- Number of Employees with Each Title
SELECT * FROM number_employees_each_title;

-- 1.3 Current List of Employees born between 01/01/52- 12/31/55
SELECT e.emp_no, 
	t.title,
	t.from_date,
	s.salary,
	e.first_name || ' ' || e.last_name AS FULLNAME
INTO retiring_title
FROM employees as e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
	INNER JOIN Salaries as s
		ON (e.emp_no = s.emp_no)
	INNER JOIN dept_emp as de
		ON (e.emp_no= de.emp_no)
AND (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (de.to_date = '9999-01-01');

SELECT * FROM retiring_title;

-- Number of retiring employees with titles
SELECT COUNT(emp_no)
FROM retiring_title;

-- Partion- get rid of dupes, show most recent title
SELECT emp_no, fullname, from_date, salary, title
INTO retiring_employees
  FROM
(SELECT emp_no, fullname, from_date, salary, title,
     ROW_NUMBER() OVER
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   FROM retiring_title
  ) tmp WHERE rn = 1
  ORDER BY emp_no;
 
-- Number of retiring employees
SELECT COUNT(emp_no)
FROM retiring_employees;

-- Retitle columns
SELECT emp_no AS Employee,
   title as Title,
   from_date as StartDate,
   salary as Salary,
   fullname as FullName
FROM retiring_employees;

SELECT * FROM retiring_employees;

-- Deliverable 2: Mentorship Eligibility
SELECT e.emp_no, t.title,
--Combine first and last name into fullname
e.first_name || ' ' || e.last_name AS FULLNAME,
--Combine from and to data into one column
t.from_date || ' and ' || t.to_date AS FROM_DATE_AND_TO_DATE
INTO mentors_eligibility
FROM employees as e
INNER JOIN titles as t 
ON (e.emp_no = t.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01');

--Check duplicates 
SELECT * FROM
  (SELECT *, count(*)
   OVER
    (PARTITION BY emp_no)
    AS count
  FROM mentors_eligibility) tableWithCount
  WHERE tableWithCount.count > 1;

-- Number of mentors_with_title, 2382
SELECT COUNT(FULLNAME)
FROM mentors_eligibility;

-- Partition the data to show only most recent title per mentor to get actual number of mentors
SELECT emp_no, fullname, title, from_date_and_to_date
INTO mentors_total_eligibility
FROM (SELECT emp_no, fullname, title, from_date_and_to_date,
  ROW_NUMBER() OVER
 (PARTITION BY (emp_no) ORDER BY from_date_and_to_date DESC) RN
 FROM mentors_eligibility) tmp WHERE RN = 1
ORDER BY emp_no;

SELECT * FROM mentors_total_eligibility

-- Number of mentors, 1549
SELECT COUNT(fullname)
FROM mentors_total_eligibility;
