CREATE TABLE IF NOT EXISTS Person (
    PersonID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT CHECK (Age < 65),
    Gender CHAR(1),
    Address1 VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(20),
    Zipcode VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS Employee (
    EmployeeID INT PRIMARY KEY,
    Erank VARCHAR(30),
    Title VARCHAR(30),
    SupID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Person(PersonID),
    FOREIGN KEY (SupID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE IF NOT EXISTS Customer (
    CustomerID INT PRIMARY KEY,
    PrefSalesRep INT,
    FOREIGN KEY (PrefSalesRep) REFERENCES Employee(EmployeeID)
);

CREATE TABLE IF NOT EXISTS Salary (
    EmployeeID INT,
    RefNumber INT,
    Amount DECIMAL(10,2),
    PayDate DATE,
    PRIMARY KEY (EmployeeID, RefNumber),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE IF NOT EXISTS Candidate (
    CandidateID INT PRIMARY KEY,
    FOREIGN KEY (CandidateID) REFERENCES Person(PersonID)
);

CREATE TABLE IF NOT EXISTS Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS WorkHistory (
    EmployeeID INT,
    DepartmentID INT,
    StartTime DATE,
    EndTime DATE,
    PRIMARY KEY (EmployeeID, DepartmentID, StartTime),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DeptID)
);

CREATE TABLE IF NOT EXISTS JobPosition (
    JobID INT PRIMARY KEY,
    DatePosted DATE,
    Description VARCHAR(255),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE IF NOT EXISTS Application (
    PersonID INT,
    JobID INT,
    Status VARCHAR(20),
    DateTime DATE,
    PRIMARY KEY (PersonID, JobID),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (JobID) REFERENCES JobPosition(JobID)
);

CREATE TABLE IF NOT EXISTS Interview (
    InterviewID INT PRIMARY KEY,
    PersonID INT,
    JobID INT,
    InterviewTime DATETIME,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (JobID) REFERENCES JobPosition(JobID)
);

CREATE TABLE IF NOT EXISTS Interviewer (
    PersonID INT,
    InterviewID INT,
    Grade INT CHECK (Grade BETWEEN 0 AND 100),
    PRIMARY KEY (PersonID, InterviewID),
    FOREIGN KEY (PersonID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (InterviewID) REFERENCES Interview(InterviewID)
);

CREATE TABLE IF NOT EXISTS Site (
    SiteID INT PRIMARY KEY,
    SiteName VARCHAR(100),
    SiteLocation VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Product (
    ProductID INT PRIMARY KEY,
    ProductType VARCHAR(50),
    Size VARCHAR(50),
    ListPrice DECIMAL(10,2),
    Weight DECIMAL(10,2),
    Style VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Sale (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    SaleTime DATETIME,
    SiteID INT,
    SalespersonID INT,
    CustomerID INT,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (SiteID) REFERENCES Site(SiteID),
    FOREIGN KEY (SalespersonID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE IF NOT EXISTS Part (
    PartID INT PRIMARY KEY,
    NameProduct VARCHAR(100),
    ProductType VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS ProductComponent (
    ProductID INT,
    PartID INT,
    Quantity INT,
    Price DECIMAL(10,2),
    PRIMARY KEY (ProductID, PartID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (PartID) REFERENCES Part(PartID)
);

CREATE TABLE IF NOT EXISTS Vendor (
    VendorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address1 VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Zipcode VARCHAR(10),
    AccountNum VARCHAR(30),
    Rating INT,
    URL VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS ProductSupplier (
    PartID INT,
    VendorID INT,
    Price DECIMAL(10,2),
    PRIMARY KEY (PartID, VendorID),
    FOREIGN KEY (PartID) REFERENCES Part(PartID),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);
