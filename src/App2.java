import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class App2 {
    Scanner scan = new Scanner(System.in);
    Connection connection;

    public static void main(String[] args) throws Exception {
        new App2().runApp();
    }

    private void runApp () {
        System.out.println("Rental App starting up!");
        
        System.out.println("Connecting to database!");
        try (Connection conn = createConnection()) {
            this.connection = conn;

            System.out.println("Connected successfully!");

            runMenu();
        } catch (SQLException | ClassNotFoundException exc) {
            exc.printStackTrace();
        }
    }

    void runMenu () throws SQLException {
        while(true) {
            System.out.println("Choose action\n\n1: List persons\n2: Add person\n3: Update last name\n4: Quit app\n");
            int menuChoice = scan.nextInt();
            
            if (menuChoice == 1) {
                System.out.println("Listing all persons...");

                listAllPersons();
            }
            else if (menuChoice == 2) {
                System.out.println("Id: ");
                int id = scan.nextInt();
                System.out.println("Person number: ");
                String pnbr = scan.next();
                System.out.println("First name: ");
                String firstname = scan.next();
                addPerson(id, pnbr, firstname);
            }
            else if (menuChoice == 3) {
                System.out.println("Id: ");
                int id = scan.nextInt();
                System.out.println("Last name: ");
                String lastname = scan.next();
                updatePerson(id, lastname);
            }
            else if (menuChoice == 4) {
                System.out.println("Closing...");
                break;
            }
        }
    }

    void addPerson (int id, String personNbr, String firstName) throws SQLException {
        PreparedStatement insertStmt = this.connection.prepareStatement("INSERT INTO person_detail (id, person_nbr, first_name) VALUES (?, ?, ?)");
        insertStmt.setInt(1, id);
        insertStmt.setString(2, personNbr);
        insertStmt.setString(3, firstName);
        insertStmt.executeUpdate();

        System.out.println("Added!");
    }

    void updatePerson (int id, String lastname) throws SQLException {
        PreparedStatement updateStmt = this.connection.prepareStatement("UPDATE person_detail SET last_name = ? WHERE id = ?");
        updateStmt.setString(1, lastname);
        updateStmt.setInt(2, id);
        updateStmt.executeUpdate();

        System.out.println("Updated!");
    }

    void listAllPersons () throws SQLException {
        PreparedStatement findAllPersonsStmt = this.connection.prepareStatement("SELECT * FROM person_detail");
        try (ResultSet persons = findAllPersonsStmt.executeQuery()) {
            while (persons.next()) {
              System.out.println(
                  "first name: " + persons.getString(3) + ", last name: " + persons.getString(4) + ", age: " + persons.getInt(5));
            }
          } catch (SQLException sqle) {
            sqle.printStackTrace();
          }
    }

    private Connection createConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection("jdbc:postgresql://localhost:5432/task3_logphysmodel",
          "postgres", "Kthpostgres");
    }
}
