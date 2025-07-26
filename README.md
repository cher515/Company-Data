# XYZConnect: Company Database System

This project is a relational database system built for managing company-wide operations, including employees, customers, job applications, interviews, salaries, product inventory, vendor supplies, and sales. It integrates a MySQL backend with a Java-based console interface using JDBC.

## 💡 Features

- 📁 Entity-based schema (Person, Employee, Customer, Department, etc.)
- 🧾 CRUD operations for key records
- 🗂️ Manage job postings, applications, and interviews
- 💰 Track salaries and work history
- 🛒 Product-component-vendor relationships
- 📊 Sales and site tracking
- 🧩 JDBC-based interaction via Java (`CRUDConsole.java`)

## ⚙️ Technologies Used

- Java 23
- MySQL 8+
- JDBC (MySQL Connector/J)
- SQL DDL & DML
- ER/EER Diagram Design

## 🛠️ Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/xyzconnect.git
   cd xyzconnect
Set up the MySQL database

Create a schema (e.g., xyz_company)

Run DDL project.sql to create tables

Run project db.sql to populate test data and views

Compile and run the Java console app

bash
Copy
Edit
javac CRUDConsole.java
java -cp ".;path/to/mysql-connector-j-9.3.0.jar" CRUDConsole
Update DB connection in CRUDConsole.java

String url = "jdbc:mysql://localhost:3306/xyz_company";
String username = "root";
String password = "your_password";

## 📁 Project Structure

- **/docs**
  - `ER_diagram.pdf` – Conceptual Entity-Relationship Diagram  
  - `EER_diagram.pdf` – Enhanced ER Model  
  - `Logical_Schema.pdf` – Logical schema with primary/foreign keys  
  - `Assumptions_Summary.pdf` – Design assumptions and constraints  

- **/sql**
  - `ddl_schema.sql` – Table creation (DDL)  
  - `insert_data.sql` – Sample data and inserts  
  - `views.sql` – SQL view definitions  
  - `full_setup.sql` – Full database build script (DDL + inserts + views)  

- **/src**
  - `CRUDConsole.java` – Java console app with JDBC integration  

- **/lib**
  - `mysql-connector-j-9.3.0.jar` – MySQL JDBC driver (download or link)  

- **README.md** – Project overview, setup instructions  
- **.gitignore** – Ignore compiled classes (`*.class`), IDE files, logs, etc.


