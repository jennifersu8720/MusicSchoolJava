import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class App {
    Scanner scan = new Scanner(System.in);
    Connection connection;

    public static void main(String[] args) throws Exception {
        new App().runApp();
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
            System.out.println("Choose action\n\n1: List instruments\n2: Add instrument\n3: Rent instrument\n4: List rented instruments\n5: Terminate rental\n6: Quit app\n");
            int menuChoice = scan.nextInt();
            
            if (menuChoice == 1) {
                System.out.println("Listing all instruments...");
                listAllInstruments();
                
            } else if (menuChoice == 2) {
                System.out.println("Id: ");
                int id = scan.nextInt();
                System.out.println("Type: ");
                String type = scan.next();
                System.out.println("Number in stock: ");
                int nbr_in_stock = scan.nextInt();
                System.out.println("Rented: ");
                int rented = scan.nextInt();
                System.out.println("Brand: ");
                String brand = scan.next();
                System.out.println("Price: ");
                int price = scan.nextInt();
                addInstrument(id, type, nbr_in_stock, rented, brand, price);

            } else if (menuChoice == 4) {
                System.out.println("Listing rented instruments...");
                listRentedInstruments();

            } else if (menuChoice == 6) {
                System.out.println("Closing...");
                break;
            }
        }
    }

    //kolla ifall studenten har två instrument
    //kolla om rented är mindre än nbr_in_stock(alla instrument som finns)
    void rentInstrument() throws SQLException{

    }

    void listRentedInstruments () throws SQLException {
        PreparedStatement findRentedInstrumentsStmt = this.connection.prepareStatement("SELECT instrument_lease.instrument_id, instrument_lease.student_id, instrument.type, instrument.price FROM instrument_lease JOIN instrument ON instrument_lease.instrument_id = instrument.id");
        try (ResultSet instruments = findRentedInstrumentsStmt.executeQuery()) {
            while (instruments.next()) {
              System.out.println(
                  "id: " + instruments.getInt(1) + ", student: " + instruments.getString(2) + ", type of instrument: " + instruments.getString(3));
            }
          } catch (SQLException sqle) {
            sqle.printStackTrace();
          }
    }
    
    void addInstrument (int id, String type, int nbr_in_stock, int rented, String brand, int price) throws SQLException {
        PreparedStatement insertStmt = this.connection.prepareStatement("INSERT INTO instrument (id, type, nbr_in_stock, rented, brand, price) VALUES (?, ?, ?, ?, ?, ?)");
        insertStmt.setInt(1, id);
        insertStmt.setString(2, type);
        insertStmt.setInt(3, nbr_in_stock);
        insertStmt.setInt(4, rented);
        insertStmt.setString(5, brand);
        insertStmt.setInt(6, price);
        insertStmt.executeUpdate();

        System.out.println("Added!");
    }

    //fixa om <= 0, visa inte instrument
    void listAllInstruments () throws SQLException {
        PreparedStatement findAllInstrumentsStmt = this.connection.prepareStatement("SELECT * FROM instrument");
        try (ResultSet instruments = findAllInstrumentsStmt.executeQuery()) {
            while (instruments.next()) {
              System.out.println(
                  "id: " + instruments.getInt(1) + ", type of instrument: " + instruments.getString(2) + ", available to rent: " + (instruments.getInt(3) - instruments.getInt(4))
                  + ", brand: " + instruments.getString(5)+ ", price: " + instruments.getInt(6));
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
