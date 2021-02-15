DROP TABLE salaries CASCADE

--Departments # 1
CREATE TABLE departments (
	dept_no VARCHAR PRIMARY KEY,
	dept_name VARCHAR
	);

-- Titles # 2
CREATE TABLE titles (
	title_id VARCHAR PRIMARY KEY,
	title VARCHAR);

-- Employees # 3
CREATE TABLE employees (
	emp_no INT NOT NULL PRIMARY KEY,
	emp_title_id VARCHAR NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id),
	birth_date DATE,
	first_name VARCHAR,
	last_name VARCHAR,
	sex VARCHAR,
	hire_date DATE
	);

-- Dept_Employees # 4
CREATE TABLE dept_employees (
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	dept_no VARCHAR NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
	);
               
-- Dept_Managers # 5
CREATE TABLE dept_managers (
	dept_no VARCHAR, 
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	emp_no INT NOT NULL, 
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
	);

-- SALARIES # 6                       
CREATE TABLE salaries (
	emp_no INT NOT NULL, 
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	salary INT);

-- 1. List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
INNER JOIN salaries AS s ON
e.emp_no = s.emp_no;

-- 2. List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date >= '1986-01-01' AND hire_date <= '1986-12-31';

-- 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT * FROM departments
SELECT * FROM dept_managers
SELECT * FROM employees

SELECT d.dept_no, d.dept_name, e.emp_no AS "manager_no", e.last_name, e.first_name
FROM employees AS e
INNER JOIN dept_managers as dm ON e.emp_no = dm.emp_no
INNER JOIN departments as d ON d.dept_no = dm.dept_no;

-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_managers as dm ON e.emp_no = dm.emp_no
INNER JOIN departments as d ON d.dept_no = dm.dept_no;

-- 5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT * FROM dept_employees

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees as e
INNER JOIN dept_employees as de ON e.emp_no = de.emp_no
INNER JOIN departments as d ON d.dept_no = de.dept_no
WHERE d.dept_name = 'Sales';

--[ALTERNATIVE WAY]
SELECT emp_no, last_name, first_name
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM dept_employees
	WHERE dept_no IN (
		SELECT dept_no 
		FROM departments
		WHERE dept_name = 'Sales'
		)
	);

--[COMMENT FOR BCS]: The above instruction to also include Department Name in the results seems a bit redundant since the question already asks for all employees in the Sales department. 

-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees as e
INNER JOIN dept_employees as de ON e.emp_no = de.emp_no
INNER JOIN departments as d ON d.dept_no = de.dept_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development'
ORDER BY e.emp_no ASC;

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, COUNT(*) AS "Count value"
FROM employees
GROUP BY last_name
HAVING COUNT(*) > 1
ORDER BY "Count value" DESC;
