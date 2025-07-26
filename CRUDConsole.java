//"C:\Program Files\Java\jdk-23\bin\java.exe" -cp "C:\Users\chery\AppData\Local\Temp\vscodesws_a063a\jdt_ws\jdt.ls-java-project\bin;C:\Users\chery\Downloads\mysql-connector-j-9.3.0.jar" CRUDConsole

import java.sql.*;
import java.util.*;

public class CRUDConsole {
    static final String DB_URL = "jdbc:mysql://localhost:3306/xyz_company";
    static final String USER = "javauser";
    static final String PASS = "java123";

    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             Scanner scanner = new Scanner(System.in)) {

            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Connected to database: XYZ_Company");

            while (true) {
                System.out.println("\n==== XYZ CRUD MENU ====");
                System.out.println("1. List tables");
                System.out.println("2. Read rows");
                System.out.println("3. Insert row");
                System.out.println("4. Update row");
                System.out.println("5. Delete row");
                System.out.println("6. List views");
                System.out.println("7. Run ad-hoc SELECT");
                System.out.println("8. Run ANY SQL");
                System.out.println("0. Quit");
                System.out.print("Select option: ");
                String choice = scanner.nextLine();

                switch (choice) {
                    case "1":
                        listTables(conn);
                        break;
                    case "2": // Read rows
                    System.out.print("Enter table name: ");
                    String tableToRead = scanner.nextLine().trim();

                    if (tableToRead.equalsIgnoreCase("person")) {
                        System.out.print("Enter Person_ID to view: ");
                        int id = Integer.parseInt(scanner.nextLine());

                        String sql = "SELECT * FROM PERSON WHERE Person_ID = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, id);
                            ResultSet rs = ps.executeQuery();
                            ResultSetMetaData meta = rs.getMetaData();
                            int colCount = meta.getColumnCount();

                            if (!rs.isBeforeFirst()) {
                                System.out.println("No person found with ID: " + id);
                            } else {
                                while (rs.next()) {
                                    for (int i = 1; i <= colCount; i++) {
                                        System.out.print(meta.getColumnName(i) + ": " + rs.getString(i) + "\t");
                                    }
                                    System.out.println();
                                }
                            }
                        } catch (SQLException e) {
                            System.out.println(" Error: " + e.getMessage());
                        }
                    } else {
                        // Generic read for other tables
                        String query = "SELECT * FROM " + tableToRead;
                        try (Statement st = conn.createStatement();
                            ResultSet rs = st.executeQuery(query)) {
                            ResultSetMetaData meta = rs.getMetaData();
                            int colCount = meta.getColumnCount();

                            while (rs.next()) {
                                for (int i = 1; i <= colCount; i++) {
                                    System.out.print(meta.getColumnName(i) + ": " + rs.getString(i) + "\t");
                                }
                                System.out.println();
                            }
                        } catch (SQLException e) {
                            System.out.println(" Error: " + e.getMessage());
                        }
                    }
                    break;

                                    
                    case "3":
                        insertRow(conn, scanner);
                        break;
                    case "4":
                        updateRow(conn, scanner);
                        break;
                    case "5":
                        deleteRow(conn, scanner);
                        break;
                    case "6":
                        listViews(conn);
                        break;
                    case "7":
                        runAdHocSelect(conn, scanner);
                        break;
                    case "8":
                        runAnySQL(conn, scanner);
                        break;
                    case "0":
                        System.out.println(" Goodbye.");
                        return;
                    default:
                        System.out.println(" Invalid option.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    static void listTables(Connection conn) throws SQLException {
        ResultSet rs = conn.getMetaData().getTables(null, null, "%", new String[]{"TABLE"});
        System.out.println(" Tables:");
        while (rs.next()) {
            System.out.println("- " + rs.getString(3));
        }
    }

    static void listViews(Connection conn) throws SQLException {
        ResultSet rs = conn.getMetaData().getTables(null, null, "%", new String[]{"VIEW"});
        System.out.println("👁 Views:");
        while (rs.next()) {
            System.out.println("- " + rs.getString(3));
        }
    }

    static void readRows(Connection conn, Scanner scanner) throws SQLException {
        System.out.print("Enter table name: ");
        String table = scanner.nextLine();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM " + table);
        ResultSetMetaData meta = rs.getMetaData();
        int cols = meta.getColumnCount();

        while (rs.next()) {
            for (int i = 1; i <= cols; i++) {
                System.out.print(meta.getColumnName(i) + ": " + rs.getString(i) + "\t");
            }
            System.out.println();
        }
    }

static void insertRow(Connection conn, Scanner scanner) throws SQLException {
    System.out.print("Enter table name: ");
    String table = scanner.nextLine();

    // Get column metadata
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM " + table + " LIMIT 1");
    ResultSetMetaData meta = rs.getMetaData();
    int cols = meta.getColumnCount();

    // Collect user input for each column
    String[] values = new String[cols];
    for (int i = 0; i < cols; i++) {
        String col = meta.getColumnName(i + 1);
        System.out.print("Enter value for " + col + ": ");
        values[i] = scanner.nextLine();
    }

    // Build parameterized query
    StringBuilder placeholders = new StringBuilder();
    StringBuilder columns = new StringBuilder();
    for (int i = 0; i < cols; i++) {
        columns.append(meta.getColumnName(i + 1));
        placeholders.append("?");
        if (i < cols - 1) {
            columns.append(", ");
            placeholders.append(", ");
        }
    }

    String sql = "INSERT INTO " + table + " (" + columns + ") VALUES (" + placeholders + ")";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        for (int i = 0; i < cols; i++) {
            ps.setString(i + 1, values[i]); // You can enhance this by checking column type if needed
        }
        ps.executeUpdate();
        System.out.println("Row inserted successfully.");
    } catch (SQLException e) {
        System.out.println(" Insert failed: " + e.getMessage());
    }
}



static void updateRow(Connection conn, Scanner scanner) throws SQLException {
    System.out.print("Enter table name: ");
    String table = scanner.nextLine().trim();

    System.out.println("Example condition: Person_ID = 101");
    System.out.print("Enter WHERE condition to identify the row (e.g. Person_ID = 101): ");
    String condition = scanner.nextLine().trim();
    if (condition.isEmpty()) {
        System.out.println("Condition cannot be empty. Update cancelled.");
        return;
    }

    System.out.println("Example update: First_Name = 'Cher'");
    System.out.print("Enter column assignment(s) to update (e.g. First_Name = 'Cher'): ");
    String update = scanner.nextLine().trim();
    if (update.isEmpty() || !update.contains("=")) {
        System.out.println("Invalid update format. Update cancelled.");
        return;
    }

    String sql = "UPDATE " + table + " SET " + update + " WHERE " + condition;

    try (Statement stmt = conn.createStatement()) {
        int rows = stmt.executeUpdate(sql);
        System.out.println("Rows updated: " + rows);
    } catch (SQLException e) {
        System.out.println("Error executing update: " + e.getMessage());
    }
}


    static void deleteRow(Connection conn, Scanner scanner) throws SQLException {
        System.out.print("Enter table name: ");
        String table = scanner.nextLine();
        System.out.print("Enter condition to delete (e.g. id = 1): ");
        String condition = scanner.nextLine();

        String sql = "DELETE FROM " + table + " WHERE " + condition;
        Statement stmt = conn.createStatement();
        int rows = stmt.executeUpdate(sql);
        System.out.println("Rows deleted: " + rows);
    }

    static void runAdHocSelect(Connection conn, Scanner scanner) throws SQLException {
        System.out.print("Enter SELECT query: ");
        String sql = scanner.nextLine();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        ResultSetMetaData meta = rs.getMetaData();
        int cols = meta.getColumnCount();

        while (rs.next()) {
            for (int i = 1; i <= cols; i++) {
                System.out.print(meta.getColumnName(i) + ": " + rs.getString(i) + "\t");
            }
            System.out.println();
        }
    }

    static void runAnySQL(Connection conn, Scanner scanner) throws SQLException {
        System.out.print("Enter any SQL: ");
        String sql = scanner.nextLine();
        Statement stmt = conn.createStatement();
        boolean hasResult = stmt.execute(sql);
        if (hasResult) {
            ResultSet rs = stmt.getResultSet();
            ResultSetMetaData meta = rs.getMetaData();
            int cols = meta.getColumnCount();

            while (rs.next()) {
                for (int i = 1; i <= cols; i++) {
                    System.out.print(meta.getColumnName(i) + ": " + rs.getString(i) + "\t");
                }
                System.out.println();
            }
        } else {
            System.out.println("SQL executed. Rows affected: " + stmt.getUpdateCount());
        }
    }
}
