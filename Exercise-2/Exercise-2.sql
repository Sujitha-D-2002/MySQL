/* 1. remove the details of an employee whose first name ends in ‘even’ */
DELETE FROM EMPLOYEES WHERE LOWER(FIRST_NAME) LIKE '%even';

/*2. to show the three minimum values of the salary from the table*/
SELECT * FROM EMPLOYEES ORDER BY SALARY ASC LIMIT 3;

/*3. remove the employees table from the database*/
DROP TABLE EMPLOYEES;

/*4. to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table*/
 CREATE TABLE EMPLOYEE CLONE EMPLOYEES;
 //Another Way
 CREATE TABLE EMPLOYEE AS (SELECT * FROM EMPLOYEES);
 
/*5.to remove the column Age from the table*/
ALTER TABLE EMPLOYEES DROP COLUMN AGE;

/*6.the list of employees (their full name, email, hire_year) where they have joined the firm before 2000*/
SELECT CONCAT(FIRST_NAME,' ', LAST_NAME) AS FULL_NAME,EMAIL,YEAR(HIRE_DATE) AS HIRE_YEAR FROM EMPLOYEES WHERE YEAR(HIRE_DATE)<2000;

/*7. Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999*/
SELECT EMPLOYEE_ID, JOB_ID FROM EMPLOYEES WHERE YEAR(HIRE_DATE) BETWEEN 1990 AND 1999;

/*8.the first occurrence of the letter 'A' in each employees Email ID  return the employee_id, email id and the letter position*/
SELECT EMPLOYEE_ID,EMAIL,CHARINDEX('A', EMAIL) AS LETTER_POSITION FROM EMPLOYEES WHERE CHARINDEX('A', EMAIL)>0;

//Another way
SELECT EMPLOYEE_ID,EMAIL,INSTR( EMAIL, 'A') AS LETTER_POSITION FROM EMPLOYEES;

/*9.Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12*/
SELECT EMPLOYEE_ID,CONCAT(FIRST_NAME,' ',LAST_NAME) AS FULL_NAME,EMAIL FROM EMPLOYEES WHERE LENGTH(CONCAT(FIRST_NAME,' ',LAST_NAME))<12;

/*10.Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID Return the employee_id, and their corresponding UNQ_ID;*/
SELECT EMPLOYEE_ID,CONCAT_WS('-',FIRST_NAME,LAST_NAME,EMAIL) AS UNQ_ID FROM EMPLOYEES;

/*11.to update the size of email column to 30*/
ALTER TABLE EMPLOYEES ALTER COLUMN EMAIL VARCHAR(30);
DESC TABLE EMPLOYEES;

/*12.Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)*/
SELECT FIRST_NAME,EMAIL,LEFT(PHONE_NUMBER,LENGTH(PHONE_NUMBER)-CHARINDEX('.',REVERSE(PHONE_NUMBER))) AS PHONE,SUBSTRING(PHONE_NUMBER,(LENGTH(PHONE_NUMBER)-CHARINDEX('.',REVERSE(PHONE_NUMBER)))+2,LEN(PHONE_NUMBER)) AS EXTENSION FROM EMPLOYEES;

SELECT FIRST_NAME,EMAIL,PHONE_NUMBER,SPLIT_PART(PHONE_NUMBER,'.',-1) AS EXTENSION ,
CASE 
WHEN LENGTH(PHONE_NUMBER)=12 THEN SUBSTR(PHONE_NUMBER,1,7)
WHEN LENGTH(PHONE_NUMBER)=14 THEN SUBSTR(PHONE_NUMBER,1,9)
WHEN LENGTH(PHONE_NUMBER)=18 THEN SUBSTR(PHONE_NUMBER,1,11)
END AS PHONE FROM EMPLOYEES;

/*13. to find the employee with second and third maximum salary*/
SELECT * FROM EMPLOYEES WHERE SALARY IN (SELECT TOP 2 SALARY FROM EMPLOYEES GROUP BY SALARY HAVING SALARY NOT IN (SELECT MAX(SALARY) FROM EMPLOYEES) ORDER BY SALARY DESC);

/*14.Fetch all details of top 3 highly paid employees who are in department Shipping and IT */
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME IN ('Shipping','IT')) ORDER BY SALARY DESC LIMIT 3;

/*15.Display employee id and the positions(jobs) held by that employee (including the current position)*/
SELECT* FROM(SELECT EMP.EMPLOYEE_ID, JOB.JOB_ID AS POSITIONS FROM EMPLOYEES AS EMP INNER JOIN JOBS AS JOB ON EMP.JOB_ID=JOB.JOB_ID 
UNION
SELECT EMP.EMPLOYEE_ID, JOB.JOB_ID AS POSITIONS FROM EMPLOYEES AS EMP INNER JOIN JOB_HISTORY AS JOB ON EMP.EMPLOYEE_ID=JOB.EMPLOYEE_ID) ORDER BY EMPLOYEE_ID ;

/*16.Display Employee first name and date joined as WeekDay, Month Day, Year*/
SELECT FIRST_NAME, CONCAT(DECODE(DAYNAME(HIRE_DATE), 'Mon', 'Monday', 
                       'Tue','Tuesday', 
                        'Wed','Wednesday', 
                        'Thu','Thursday', 
                          'Fri','Friday', 
                            'Sat','Saturday', 
                              'Sun','Sunday'
                      ),' ',MONTHNAME(HIRE_DATE),' ',DAY(HIRE_DATE),', ',YEAR(HIRE_DATE)) AS DATE_JOINED FROM EMPLOYEES;

/*17.The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .*/
-- DELETE FROM JOBS WHERE JOB_ID='DT_ENGG';
START TRANSACTION;

ALTER SESSION SET AUTOCOMMIT=FALSE;
INSERT INTO JOBS VALUES ('DT_ENGG','Data Engineer',12000,30000);
/*The job position might be removed based on market trends (so, save the changes) */
COMMIT;
/*- Later, update the maximum salary to 40,000 . - Save the entries as well.*/
UPDATE JOBS SET MAX_SALARY=40000 WHERE JOB_ID='DT_ENGG';
/*- Now, revert back the changes to the initial state, where the salary was 30,000*/
ROLLBACK;
SELECT * FROM JOBS WHERE JOB_ID='DT_ENGG';

/*18.the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals*/
SELECT ROUND(AVG(SALARY),3)AS AVERAGE_SALARY FROM EMPLOYEES WHERE HIRE_DATE >'08-JAN-1996' AND HIRE_DATE<'01-JAN-2000';

/*19. Display Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
A. Display all the regions*/
SELECT REGION_ID,REGION_NAME FROM REGIONS
UNION
SELECT '5','Australia' FROM REGIONS
UNION
SELECT '6','Asia' FROM REGIONS
UNION
SELECT '7','Antarcica' FROM REGIONS
UNION
SELECT '8','Europe' FROM REGIONS;

(SELECT REGION_NAME FROM REGIONS)
UNION 
(SELECT $1 FROM (VALUES('Australia'),('Asia'),('Antarcica'),('Europe')));

/*B. Display all the unique regions*/
(SELECT REGION_NAME FROM REGIONS)
UNION ALL
(SELECT $1 FROM (VALUES('Australia'),('Asia'),('Antarcica'),('Europe')));