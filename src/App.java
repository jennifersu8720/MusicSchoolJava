import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
//TODO add id to instrument_lease
//TODO do not show instrument in list if <=0

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
            connection.setAutoCommit(false);
            System.out.println("Connected successfully!");

            runMenu();
        } catch (SQLException | ClassNotFoundException exc) {
            exc.printStackTrace();
            handleException();
        }
    }
    
    //print menu
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

            } else if (menuChoice == 3) {
                System.out.println("\nType student ID: ");
                int student_id = scan.nextInt();
                System.out.println("\nType desired instrument ID to lease: ");
                int instrument_id = scan.nextInt();
                System.out.println("\nType start date, 'yyyy-mm-dd': ");
                String start_month = scan.next();
                System.out.println("\nType end date, 'yyyy-mm-dd': ");
                String end_month = scan.next();
                rentInstrument(student_id, instrument_id, start_month, end_month);

            }else if (menuChoice == 4) {
                System.out.println("Listing rented instruments...");
                listRentedInstruments();

            }   else if (menuChoice == 5) {
                System.out.print("\n Type Student ID: ");
                int student_id = scan.nextInt();
                System.out.print("\n Type desired instrument ID to end lease: ");
                int instrument_id = scan.nextInt();
                terminateRental(instrument_id, student_id);

            }else if (menuChoice == 6) {
                System.out.println("Closing...");
                break;
            }
        }
    }
    //check if student exceeds the rent limit of 2, true = exceeded, false = not exceeded
    Boolean rentLimit(int student_id) throws SQLException{
        PreparedStatement rentLimitStmt = this.connection.prepareStatement("SELECT student_id FROM instrument_lease");
        try (ResultSet studentId = rentLimitStmt.executeQuery()) {
            int count = 0;
            while (studentId.next()){
                if( student_id == studentId.getInt(1)){
                    count++;
                }
            }
            if(count >= 2){
                return true;
            }else{
                return false;
            }
        } catch (SQLException sqle) {
            sqle.printStackTrace();
            return false;
        }
    }

    void rentInstrument(int student_id, int instrument_id, String start_month, String end_month) throws SQLException{
        PreparedStatement instrumentStmt = this.connection.prepareStatement("SELECT nbr_in_stock, rented FROM instrument WHERE id = ?");
        instrumentStmt.setInt(1, instrument_id);
        try (ResultSet instrument = instrumentStmt.executeQuery()) {
            instrument.next();
            if(rentLimit(student_id)  == false && instrument.getInt(2) < instrument.getInt(1)){
                PreparedStatement updRentStmt = this.connection.prepareStatement("INSERT INTO instrument_lease (instrument_id, start_month, end_month, student_id, active_rental) VALUES(?, ?, ?, ?, ?)");
                updRentStmt.setInt(4, student_id);
                updRentStmt.setInt(1, instrument_id);
                updRentStmt.setDate(2, Date.valueOf(start_month));
                updRentStmt.setDate(3, Date.valueOf(end_month));
                updRentStmt.setString(5, "Yes");
                updRentStmt.executeUpdate();

                PreparedStatement updateStockStmt = this.connection.prepareStatement("UPDATE instrument SET rented=rented+1 WHERE id = ?;");
                updateStockStmt.setInt(1, instrument_id);
                updateStockStmt.executeUpdate();
                connection.commit();
            } else{
                System.out.println("The rental cannot be carried out!");
            }      
        } catch (SQLException sqle) {
            sqle.printStackTrace();
            handleException();
        }
    }
    
    String activeRental (int instrument_id, int student_id)throws SQLException{
        PreparedStatement findActiveLease = this.connection.prepareStatement("SELECT active_rental FROM instrument_lease WHERE student_id = ? AND instrument_id = ?;");
        findActiveLease.setInt(1, student_id);
        findActiveLease.setInt(2, instrument_id);
        String ActiveLease = "No";
        
        try (ResultSet Leasex = findActiveLease.executeQuery()) {
            while (Leasex.next()) {
              ActiveLease = Leasex.getString(1);
            } }
           catch (SQLException sqle) {
            sqle.printStackTrace();
            handleException();
        }
        
        ResultSet Lease = findActiveLease.executeQuery();
        while (Lease.next()){
            ActiveLease = Lease.getString(1);
        }
        
        return ActiveLease;
    }
    void terminateRental (int instrument_id, int student_id) throws SQLException { //instrument available+
        if(activeRental(instrument_id, student_id).contains("Yes")){
            PreparedStatement findLease = this.connection.prepareStatement("UPDATE instrument_lease SET active_rental ='No' WHERE student_id = ? AND instrument_id = ? AND active_rental = 'Yes';");
            findLease.setInt(1, student_id);
            findLease.setInt(2, instrument_id);
            findLease.executeUpdate();

            PreparedStatement updateStock = this.connection.prepareStatement("UPDATE instrument SET rented=rented-1 WHERE id = ?;");
            updateStock.setInt(1, instrument_id);
            updateStock.executeUpdate();

            System.out.println("\n Lease terminated \n");
            connection.commit();
        } 
        else {
            System.out.println("\n Lease already terminated");
        }
    } 

    void listRentedInstruments () throws SQLException {
        PreparedStatement findRentedInstrumentsStmt = this.connection.prepareStatement("SELECT instrument_lease.instrument_id, instrument_lease.student_id, instrument.type, instrument.price, instrument_lease.active_rental FROM instrument_lease JOIN instrument ON instrument_lease.instrument_id = instrument.id");
        try (ResultSet instruments = findRentedInstrumentsStmt.executeQuery()) {
            while (instruments.next()) {
                System.out.println(
                "id: " + instruments.getInt(1) + ", student: " + instruments.getString(2) + ", type of instrument: " + instruments.getString(3) + ", active rental: " + instruments.getString(5));
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
        connection.commit();
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
        return DriverManager.getConnection("jdbc:postgresql://localhost:5432/logphysmodel_updated",
          "postgres", "Kthpostgres");
    }

    private void handleException() {
        try {
            connection.rollback();
        } catch (SQLException rollbackExc) {
        }
    }
}
