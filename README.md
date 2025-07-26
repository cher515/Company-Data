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

java
Copy
Edit
String url = "jdbc:mysql://localhost:3306/xyz_company";
String username = "root";
String password = "your_password";
📁 Project Structure
bash
Copy
Edit
├── DDL project.sql            # Table schema
├── project db.sql             # Inserts and views
├── CRUDConsole.java           # Java app for interaction
├── ER diagram.pdf             # Conceptual design
├── EER diagram done.pdf       # Enhanced ER model
├── LOGICAL DIAGRAM DONE.pdf  # Logical schema diagram
├── Assumptions Summary.pdf    # Assumptions made during design
