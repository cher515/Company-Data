USE smallairportdb;


DROP VIEW IF EXISTS View_AvgMonthlySalary, View_IntervieweesPassed, View_SalesPerProductType, View_EmployeesAllDepartments;
DROP TABLE IF EXISTS INTERVIEW_EVALUATION, INTERVIEW, APPLICATION, EMPLOYEE_DEPARTMENT_ASSIGNMENT,
    JOB_POSITION, DEPARTMENT, EMPLOYEE, CUSTOMER, PHONE, PERSON,
    PRODUCT_PART_USAGE, PRODUCT, VENDOR_PART_SUPPLY, VENDOR,
    PART_TYPE, SALE, MARKETING_SITE, SALARY_PAYMENT;



CREATE TABLE PERSON (
    Person_ID INT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Age INT CHECK (Age BETWEEN 18 AND 64),
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'O')),
    Address_Line_1 VARCHAR(100) NOT NULL,
    Address_Line_2 VARCHAR(100),
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Zipcode VARCHAR(10) NOT NULL,
    Email_Address VARCHAR(100)
);


CREATE TABLE PHONE (
    Phone_Number VARCHAR(40) NOT NULL,
    Person_ID INT NOT NULL,
    PRIMARY KEY (Person_ID, Phone_Number),
    FOREIGN KEY (Person_ID) REFERENCES PERSON(Person_ID) ON DELETE CASCADE
);

INSERT INTO PERSON (Person_ID, First_Name, Last_Name, Age, Gender, Address_Line_1, Address_Line_2, City, State, Zipcode, Email_Address)
VALUES
(101, 'jackson', 'thomas', 20, 'M', '233 Oak View', NULL, 'addison', 'TX', '75056', 'jacksonkt2004@gmail.com'),
(102, 'Beater', 'Dee', 60, 'M', '667 Meowie Ln', NULL, 'Dallas', 'OH', '45698', 'sigmaboy@example.org'),
(103, 'Pearl', 'Jonah', 24, 'F', '281 Jobless Lane', NULL, 'Unemployed', 'TX', '73301', 'givemeinternship@example.org');


INSERT INTO PHONE (Person_ID, Phone_Number)
VALUES
(101, '(399)927-9126'),
(101, '+1-663-341-9936x6364'),
(101, '001-511-80x60977'),
(102, '214-555-7890'),
(103, '469-555-5555');
SELECT * FROM PERSON;
SELECT * FROM PHONE;


CREATE TABLE EMPLOYEE (
    Employee_ID INT PRIMARY KEY,
    Supervisor_ID INT,
    Rank_Code VARCHAR(20) NOT NULL,
    FOREIGN KEY (Employee_ID) REFERENCES PERSON(Person_ID) ON DELETE CASCADE,
    FOREIGN KEY (Supervisor_ID) REFERENCES EMPLOYEE(Employee_ID) ON DELETE SET NULL,
    FOREIGN KEY (Rank_Code) REFERENCES RANK_TABLE(Rank_Code)
);


CREATE TABLE SALARY_PAYMENT (
    Payroll_ID INT PRIMARY KEY,
    Employee_ID INT NOT NULL,
    Pay_Date DATE NOT NULL,
    Amount DECIMAL(10, 2) CHECK (Amount >= 0),
    FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID) ON DELETE CASCADE
);

CREATE OR REPLACE VIEW View_AvgMonthlySalary AS
SELECT
    sp.Employee_ID,
    ROUND(SUM(sp.Amount) / COUNT(DISTINCT DATE_FORMAT(sp.Pay_Date, '%Y-%m')), 2) AS Avg_Monthly_Salary
FROM SALARY_PAYMENT sp
GROUP BY sp.Employee_ID;

CREATE OR REPLACE VIEW View_AvgMonthlySalary AS
SELECT
    sp.Employee_ID,
    ROUND(SUM(sp.Amount) / COUNT(DISTINCT DATE_FORMAT(sp.Pay_Date, '%Y-%m')), 2) AS Avg_Monthly_Salary
FROM SALARY_PAYMENT sp
GROUP BY sp.Employee_ID;

-- INTERVIEW table
CREATE TABLE IF NOT EXISTS INTERVIEW (
    Interview_ID INT PRIMARY KEY,
    Job_ID INT,
    Candidate_ID INT,
    Interview_Timestamp DATETIME
);

CREATE TABLE IF NOT EXISTS INTERVIEW_EVALUATION (
    Interview_ID INT,
    Interviewer_ID INT,
    Evaluation_Score INT,
    PRIMARY KEY (Interview_ID, Interviewer_ID),
    FOREIGN KEY (Interview_ID) REFERENCES INTERVIEW(Interview_ID)
);

CREATE OR REPLACE VIEW View_IntervieweesPassed AS
SELECT i.Candidate_ID
FROM INTERVIEW_EVALUATION ev
JOIN INTERVIEW i ON ev.Interview_ID = i.Interview_ID
GROUP BY i.Candidate_ID
HAVING AVG(ev.Evaluation_Score) > 70
   AND COUNT(CASE WHEN ev.Evaluation_Score > 60 THEN 1 END) >= 5;

CREATE OR REPLACE VIEW View_IntervieweesPassed AS
SELECT i.Candidate_ID
FROM INTERVIEW_EVALUATION ev
JOIN INTERVIEW i ON ev.Interview_ID = i.Interview_ID
GROUP BY i.Candidate_ID
HAVING AVG(ev.Evaluation_Score) > 70
   AND COUNT(CASE WHEN ev.Evaluation_Score > 60 THEN 1 END) >= 5;

SELECT * FROM View_IntervieweesPassed;
SELECT 
    p.Person_ID,
    p.First_Name,
    p.Last_Name,
    p.Email_Address
FROM PERSON p
WHERE p.Person_ID IN (
    SELECT Candidate_ID
    FROM View_IntervieweesPassed
);


CREATE TABLE SALE (
    Sale_ID INT PRIMARY KEY,
    Product_ID INT,
    Salesman_ID INT,
    Customer_ID INT,
    Site_ID INT,
    Sale_Time DATETIME
);

CREATE TABLE PRODUCT (
    Product_ID INT PRIMARY KEY,
    Product_Type VARCHAR(30) NOT NULL,
    Size DECIMAL(6,2) CHECK (Size > 0),
    Weight DECIMAL(6,2) CHECK (Weight > 0),
    Style VARCHAR(30),
    Base_Price DECIMAL(10,2) NOT NULL,
    List_Price DECIMAL(10,2) NOT NULL
);

CREATE VIEW View_SalesPerProductType AS
SELECT s.Salesman_ID, p.Product_Type
FROM SALE s
JOIN PRODUCT p ON s.Product_ID = p.Product_ID;


CREATE OR REPLACE VIEW View_SalesPerProductType AS
SELECT s.Salesman_ID, p.Product_Type
FROM SALE s
JOIN PRODUCT p ON s.Product_ID = p.Product_ID;


CREATE TABLE DEPARTMENT (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(50) NOT NULL
);

CREATE TABLE EMPLOYEE_DEPARTMENT_ASSIGNMENT (
    Employee_ID INT,
    Department_ID INT,
    Start_Date DATE NOT NULL,
    End_Date DATE,
    PRIMARY KEY (Employee_ID, Department_ID, Start_Date),
    FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID) ON DELETE CASCADE,
    FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID) ON DELETE CASCADE
);

CREATE OR REPLACE VIEW View_EmployeesAllDepartments AS
SELECT e.Employee_ID
FROM EMPLOYEE e
WHERE NOT EXISTS (
    SELECT 1
    FROM DEPARTMENT d
    WHERE NOT EXISTS (
        SELECT 1
        FROM EMPLOYEE_DEPARTMENT_ASSIGNMENT eda
        WHERE eda.Employee_ID = e.Employee_ID AND eda.Department_ID = d.Department_ID
    )
);

SELECT * FROM View_AvgMonthlySalary;
SELECT * FROM View_IntervieweesPassed;
SELECT * FROM View_SalesPerProductType;
SELECT * FROM View_EmployeesAllDepartments;


CREATE TABLE RANK_TABLE (
    Rank_Code VARCHAR(20) PRIMARY KEY,
    Job_Title VARCHAR(50) NOT NULL
);


CREATE TABLE EMPLOYEE (
    Employee_ID INT PRIMARY KEY,
    Supervisor_ID INT,
    Rank_Code VARCHAR(20) NOT NULL,
    FOREIGN KEY (Employee_ID) REFERENCES PERSON(Person_ID) ON DELETE CASCADE,
    FOREIGN KEY (Supervisor_ID) REFERENCES EMPLOYEE(Employee_ID) ON DELETE SET NULL,
    FOREIGN KEY (Rank_Code) REFERENCES RANK_TABLE(Rank_Code)
);


CREATE TABLE JOB_POSITION (
    Job_ID INT PRIMARY KEY,
    Description TEXT NOT NULL,
    Posted_Date DATE NOT NULL,
    Department_ID INT NOT NULL,
    FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID)
);


CREATE TABLE APPLICATION (
    Application_ID INT AUTO_INCREMENT PRIMARY KEY,
    Person_ID INT NOT NULL,
    Job_ID INT NOT NULL,
    Status VARCHAR(30),
    Application_Date DATE NOT NULL,
    FOREIGN KEY (Person_ID) REFERENCES PERSON(Person_ID) ON DELETE CASCADE,
    FOREIGN KEY (Job_ID) REFERENCES JOB_POSITION(Job_ID) ON DELETE CASCADE
);

CREATE TABLE INTERVIEW (
    Interview_ID INT PRIMARY KEY,
    Job_ID INT,
    Candidate_ID INT,
    Interview_Timestamp DATETIME
);

CREATE TABLE INTERVIEW_EVALUATION (
    Interview_ID INT,
    Interviewer_ID INT,
    Evaluation_Score INT,
    PRIMARY KEY (Interview_ID, Interviewer_ID)
);



CREATE TABLE MARKETING_SITE (
    Site_ID INT PRIMARY KEY,
    Site_Name VARCHAR(50) NOT NULL,
    Site_Location VARCHAR(100)
);


CREATE TABLE PART_TYPE (
    Part_Type_ID INT PRIMARY KEY,
    Part_Type_Name VARCHAR(50) NOT NULL
);
CREATE TABLE PRODUCT (
    Product_ID INT PRIMARY KEY,
    Product_Type VARCHAR(30) NOT NULL,
    Size DECIMAL(6,2),
    Weight DECIMAL(6,2),
    Style VARCHAR(30),
    Base_Price DECIMAL(10,2),
    List_Price DECIMAL(10,2)
);

CREATE TABLE PRODUCT_PART_USAGE (
    Product_ID INT,
    Part_Type_ID INT,
    Quantity INT,
    PRIMARY KEY (Product_ID, Part_Type_ID),
    FOREIGN KEY (Product_ID) REFERENCES PRODUCT(Product_ID) ON DELETE CASCADE,
    FOREIGN KEY (Part_Type_ID) REFERENCES PART_TYPE(Part_Type_ID) ON DELETE CASCADE
);

CREATE TABLE VENDOR (
    Vendor_ID INT PRIMARY KEY,
    Vendor_Name VARCHAR(100)
);


CREATE TABLE VENDOR_PART_SUPPLY (
    Part_Type_ID INT NOT NULL,
    Vendor_ID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Part_Type_ID, Vendor_ID),
    FOREIGN KEY (Part_Type_ID) REFERENCES PART_TYPE(Part_Type_ID) ON DELETE CASCADE,
    FOREIGN KEY (Vendor_ID) REFERENCES VENDOR(Vendor_ID) ON DELETE CASCADE
);


INSERT INTO PART_TYPE VALUES 
(1, 'Cup'), (2, 'Lid'), (3, 'Label');

-- VENDORS
INSERT INTO VENDOR VALUES 
(10, 'CheapParts Co'), (11, 'TopParts Inc');

-- PRODUCTS
INSERT INTO PRODUCT VALUES 
(1001, 'Drink', 2.5, 1.2, 'Smooth', 10.00, 15.00),
(1002, 'Food', 3.0, 1.8, 'Crunchy', 8.00, 12.00);

-- PART USAGE
INSERT INTO PRODUCT_PART_USAGE VALUES 
(1001, 1, 2),  -- 2 Cups
(1001, 2, 1),  -- 1 Lid
(1002, 1, 1),  -- 1 Cup
(1002, 3, 2);  -- 2 Labels

-- PART COST SUPPLY
INSERT INTO VENDOR_PART_SUPPLY VALUES 
(1, 10, 1.50), -- Cup from vendor 10
(2, 10, 0.75), -- Lid from vendor 10
(3, 11, 0.30); -- Label from vendor 11

CREATE OR REPLACE VIEW View_ProductCost AS
SELECT 
    ppu.Product_ID,
    SUM(ppu.Quantity * vps.Price) AS Total_Cost
FROM PRODUCT_PART_USAGE ppu
JOIN VENDOR_PART_SUPPLY vps ON ppu.Part_Type_ID = vps.Part_Type_ID
GROUP BY ppu.Product_ID;

SELECT * FROM View_ProductCost;


CREATE TABLE SALARY_PAYMENT (
    Payroll_ID INT PRIMARY KEY,
    Employee_ID INT NOT NULL,
    Pay_Date DATE NOT NULL,
    Amount DECIMAL(10, 2) CHECK (Amount >= 0),
    FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID) ON DELETE CASCADE
);


CREATE VIEW View_AvgMonthlySalary AS
SELECT
    sp.Employee_ID,
    ROUND(SUM(sp.Amount) / COUNT(DISTINCT DATE_FORMAT(sp.Pay_Date, '%Y-%m')), 2) AS Avg_Monthly_Salary
FROM SALARY_PAYMENT sp
GROUP BY sp.Employee_ID;

CREATE VIEW View_IntervieweesPassed AS
SELECT i.Candidate_ID
FROM INTERVIEW_EVALUATION ev
JOIN INTERVIEW i ON ev.Interview_ID = i.Interview_ID
GROUP BY i.Candidate_ID
HAVING AVG(ev.Evaluation_Score) > 70 AND COUNT(CASE WHEN ev.Evaluation_Score > 60 THEN 1 END) >= 5;

CREATE VIEW View_EmployeesAllDepartments AS
SELECT e.Employee_ID
FROM EMPLOYEE e
WHERE NOT EXISTS (
    SELECT 1
    FROM DEPARTMENT d
    WHERE NOT EXISTS (
        SELECT 1
        FROM EMPLOYEE_DEPARTMENT_ASSIGNMENT eda
        WHERE eda.Employee_ID = e.Employee_ID AND eda.Department_ID = d.Department_ID
    )
);

SELECT DISTINCT
    ev.Interviewer_ID,
    pi.First_Name AS Interviewer_First,
    pi.Last_Name AS Interviewer_Last
FROM INTERVIEW_EVALUATION ev
JOIN INTERVIEW i ON ev.Interview_ID = i.Interview_ID
JOIN PERSON pc ON i.Candidate_ID = pc.Person_ID
JOIN PERSON pi ON ev.Interviewer_ID = pi.Person_ID
WHERE pc.First_Name = 'Hellen'
  AND pc.Last_Name = 'Cole'
  AND i.Job_ID = 11111;


SELECT
    d.Department_ID,
    d.Department_Name
FROM DEPARTMENT d
LEFT JOIN JOB_POSITION j
  ON d.Department_ID = j.Department_ID
  AND j.Posted_Date BETWEEN '2011-01-01' AND '2011-02-01'
WHERE j.Job_ID IS NULL;

SELECT p.First_Name, p.Last_Name, p.Email_Address
FROM PERSON p
WHERE p.Person_ID IN (
    SELECT i.Candidate_ID
    FROM INTERVIEW_EVALUATION ev
    JOIN INTERVIEW i ON ev.Interview_ID = i.Interview_ID
    GROUP BY i.Candidate_ID
    HAVING AVG(ev.Evaluation_Score) > 70 AND
           COUNT(CASE WHEN ev.Evaluation_Score > 60 THEN 1 END) >= 5
);

INSERT INTO PERSON (Person_ID, First_Name, Last_Name, Age, Gender, Address_Line_1, City, State, Zipcode, Email_Address)
VALUES (109, 'Cheryl', 'DeMello', 20, 'F', '515 Meowiw Ct', 'Loserville', 'OH', '75080', 'sigma@gmail.org');


SELECT * FROM PHONE
WHERE Person_ID = 101;

INSERT IGNORE INTO PHONE (Person_ID, Phone_Number)
VALUES 
(101, '(489)-033-9039'),
(101, '111711-111'),
(101, '34925d5s5557');


INSERT INTO DEPARTMENT (Department_ID, Department_Name)
VALUES (1, 'QA');

CREATE TABLE JOB_POSITION (
    Job_ID INT PRIMARY KEY,
    Description TEXT NOT NULL,
    Posted_Date DATE NOT NULL,
    Department_ID INT NOT NULL,
    FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID)
);

INSERT INTO JOB_POSITION (Job_ID, Description, Posted_Date, Department_ID)
VALUES (201, 'Tester', '2024-01-01', 1), (202, 'Support', '2024-01-02', 1);


CREATE TABLE APPLICATION (
    Application_ID INT AUTO_INCREMENT PRIMARY KEY,
    Person_ID INT NOT NULL,
    Job_ID INT NOT NULL,
    Status VARCHAR(30),
    Application_Date DATE NOT NULL,
    FOREIGN KEY (Person_ID) REFERENCES PERSON(Person_ID) ON DELETE CASCADE,
    FOREIGN KEY (Job_ID) REFERENCES JOB_POSITION(Job_ID) ON DELETE CASCADE
);

INSERT INTO APPLICATION (Person_ID, Job_ID, Status, Application_Date)
VALUES 
(101, 201, 'Applied', '2024-01-10'),
(101, 202, 'Applied', '2024-01-12');


DELETE FROM INTERVIEW WHERE Interview_ID IN (301, 302);

INSERT INTO INTERVIEW (Interview_ID, Job_ID, Candidate_ID, Interview_Timestamp)
VALUES 
(301, 201, 101, NOW()),
(302, 202, 101, NOW());

INSERT INTO INTERVIEW_EVALUATION (Interview_ID, Interviewer_ID, Evaluation_Score)
VALUES
(301, 102, 80),
(301, 103, 85),
(301, 104, 90),
(301, 105, 75),
(301, 106, 88), -- 5 scores > 60
(302, 102, 85),
(302, 103, 90),
(302, 104, 77),
(302, 105, 80),
(302, 106, 92); -- 5 scores > 60

SELECT p.First_Name, p.Last_Name, pn.Phone_Number, p.Email_Address
FROM PERSON p
JOIN PHONE pn ON p.Person_ID = pn.Person_ID
JOIN APPLICATION a ON p.Person_ID = a.Person_ID
GROUP BY p.Person_ID, pn.Phone_Number, p.Email_Address
HAVING COUNT(DISTINCT a.Job_ID) = (
    SELECT COUNT(DISTINCT i.Job_ID)
    FROM INTERVIEW_EVALUATION ev
    JOIN INTERVIEW i ON ev.Interview_ID = i.Interview_ID
    WHERE i.Candidate_ID = p.Person_ID AND ev.Evaluation_Score > 60
);


CREATE TABLE MARKETING_SITE (
    Site_ID INT PRIMARY KEY,
    Site_Name VARCHAR(50) NOT NULL,
    Site_Location VARCHAR(100)
);
CREATE TABLE SALE (
    Sale_ID INT PRIMARY KEY,
    Product_ID INT,
    Salesman_ID INT,
    Customer_ID INT,
    Site_ID INT,
    Sale_Time DATETIME
);

INSERT IGNORE INTO MARKETING_SITE (Site_ID, Site_Name, Site_Location)
VALUES
(1, 'Site A', 'Khan Nation'),
(2, 'Site B', 'Pls Curve Nation'),
(3, 'Site C', 'Lake Infestation'),
(4, 'Site D', 'Nails Slays'),
(5, 'Site E', 'Reyna Goated'),
(6, 'Site F', 'Location Namelol'),
(7, 'Site G', 'State Bludington the 2nd');

INSERT INTO SALE (Sale_ID, Product_ID, Salesman_ID, Customer_ID, Site_ID, Sale_Time)
VALUES (1, 101, 201, 301, 4, '2011-03-15 12:00:00');

SELECT
    ms.Site_ID,
    ms.Site_Location
FROM MARKETING_SITE ms
LEFT JOIN SALE s
  ON ms.Site_ID = s.Site_ID
  AND s.Sale_Time BETWEEN '2011-03-01' AND '2011-03-31 23:59:59'
WHERE s.Sale_ID IS NULL;

CREATE TABLE IF NOT EXISTS PERSON (
    Person_ID INT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Age INT CHECK (Age BETWEEN 18 AND 64),
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'O')),
    Address_Line_1 VARCHAR(100) NOT NULL,
    Address_Line_2 VARCHAR(100),
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Zipcode VARCHAR(10) NOT NULL,
    Email_Address VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS INTERVIEW (
    Interview_ID INT PRIMARY KEY,
    Job_ID INT NOT NULL,
    Candidate_ID INT NOT NULL,
    Interview_Timestamp DATETIME
);

CREATE TABLE IF NOT EXISTS INTERVIEW_EVALUATION (
    Interview_ID INT NOT NULL,
    Interviewer_ID INT NOT NULL,
    Evaluation_Score INT NOT NULL,
    PRIMARY KEY (Interview_ID, Interviewer_ID),
    FOREIGN KEY (Interview_ID) REFERENCES INTERVIEW(Interview_ID) ON DELETE CASCADE
);


INSERT IGNORE INTO PERSON (Person_ID, First_Name, Last_Name, Age, Gender, Address_Line_1, City, State, Zipcode, Email_Address)
VALUES 
(201, 'Hellen', 'Keller', 29, 'F', '123 Eyesight St', 'Frisco', 'TX', '75036', 'hellen@gmail.com'),
(202, 'Maya', 'heart', 34, 'F', '222 Eval Ln', 'Plano', 'TX', '75024', 'maya@example.com');

INSERT INTO INTERVIEW (Interview_ID, Job_ID, Candidate_ID, Interview_Timestamp)
VALUES (402, 10001, 201, NOW());

INSERT INTO INTERVIEW_EVALUATION (Interview_ID, Interviewer_ID, Evaluation_Score)
VALUES (402, 202, 85);


SELECT DISTINCT
    ev.Interviewer_ID,
    pi.First_Name AS Interviewer_First,
    pi.Last_Name AS Interviewer_Last
FROM INTERVIEW_EVALUATION ev
JOIN INTERVIEW i ON ev.Interview_ID = i.Interview_ID
JOIN PERSON pc ON i.Candidate_ID = pc.Person_ID
JOIN PERSON pi ON ev.Interviewer_ID = pi.Person_ID
WHERE pc.First_Name = 'Hellen'
  AND pc.Last_Name = 'Cole'
  AND i.Job_ID = 10001;


