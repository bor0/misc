import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Time;

import com.microsoft.sqlserver.jdbc.SQLServerDriver;

public class DB_Conn {

	private java.sql.Connection con = null;
	private String url, query, datum="";
	
	private final static String Boro = "28710:36248";
	private final static String Dimac = "01497:03300";
	private final static String Nikolce = "28710:36270";

	public DB_Conn(String server, String port, String dbName, String userName, String password, String serialNumber) {
		new SQLServerDriver(); // or Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		url = "jdbc:sqlserver://" + server + ":" + port + ";user=" + userName + ";password=" + password + ";databaseName=" + dbName + ";";
		query = "SELECT * FROM dbo.KLOG WHERE SERIAL_NO = '" + serialNumber + "' ORDER BY DATUM, VREME";
		getConnection();
		closeConnection();
	}

	private java.sql.Connection getConnection() {
		try {
			con = DriverManager.getConnection(url);
			Statement t = con.createStatement();
			ResultSet rs = t.executeQuery(query);

			while (rs.next()) {
				String status = rs.getString("STATUS");
				if (rs.getString("DATUM").equals(datum) == false) {
					datum = rs.getString("DATUM");
					System.out.println("---Datum " + datum + "---");
				}

				if (status.equals("0")) status = "Nepoznat";
				else if (status.equals("1")) status = "Vlez";
				else if (status.equals("2")) status = "Izlez";
				else if (status.equals("3")) status = "Problem";
				else if (status.equals("4")) status = "Sluzben vlez";
				else if (status.equals("5")) status = "Sluzben izlez";
				else if (status.equals("6")) status = "Pauza vlez";
				else if (status.equals("7")) status = "Pauza izlez";
				else if (status.equals("8")) status = "Vlez, BEZ REG. IZLEZ";
				else if (status.equals("9")) status = "Izlez, BEZ REG. VLEZ";
				else if (status.equals("10")) status = "Karticka od ured";
				else if (status.equals("11")) status = "Privaten vlez";
				else if (status.equals("12")) status = "Privaten izlez";
				else if (status.equals("13")) status = "Pominuvanje";
				else status = "UNKNOWN_STATUS_" + status;

				System.out.println(status + ": " + rs.getString("VREME"));
			}

		} catch (Exception e) {
			System.out.println("Error Trace in getConnection(): " + e.getMessage());
		}
		return con;
	}

	private void closeConnection() {
		try {
			if (con != null) con.close();
			con = null;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) throws Exception {
		String funcId = "";
		if (args.length == 1) funcId = args[0];
		else funcId = Boro;
		DB_Conn myDbTest = new DB_Conn("192.168.0.228", "1433", "Evidencija", "Evidencija", "Evid321!", funcId);
	}
}