package main;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

/**
 * @author Boro Sitnikovski
 * @date 20.08.2011, 26.08.2011
 *
 */


// keytool -genkey -keyalg rsa -alias mysqlClientCertificate -keystore keystore
// keytool -import -alias ca-key.pem -file ca-cert.pem -keystore truststore

/*
 * Server side configuration procedure
 * 
mysql> GRANT ALL ON *.* TO 'collector'@'%' REQUIRE SSL WITH GRANT OPTION;
mysql> GRANT ALL ON *.* TO 'root'@'%' REQUIRE SSL WITH GRANT OPTION;
mysql> GRANT ALL ON *.* TO 'root'@'127.0.0.1' REQUIRE NONE WITH GRANT OPTION;
*******
GRANT ALL ON *.* TO 'root'@'127.0.0.1' REQUIRE NONE IDENTIFIED BY '123456' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'localhost' REQUIRE NONE WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'ubuntu' REQUIRE NONE WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'88.85.115.8' REQUIRE NONE WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'vpn2.ein-sof.net.mk' REQUIRE NONE WITH GRANT OPTION;
*******
mysql> FLUSH PRIVILEGES;

// za gasnenje
// mysql> GRANT ALL ON *.* TO 'collector'@'%' REQUIRE NONE WITH GRANT OPTION;

*********************************************
potoa se kreiraat klucevite

# Create server certificate
openssl genrsa 2048 > ca-key.pem
openssl req -new -x509 -nodes -days 1000 -key ca-key.pem -out ca-cert.pem

#Country Name (2 letter code) [AU]:MK
#State or Province Name (full name) [Some-State]:Macedonia
#Locality Name (eg, city) []:Skopje
#Organization Name (eg, company) [Internet Widgits Pty Ltd]:Ein-Sof
#Organizational Unit Name (eg, section) []:DMS
#Common Name (eg, YOUR name) []:Boro
#Email Address []:boro.sitnikovski@ein-sof.com

openssl req -newkey rsa:2048 -days 1000 -nodes -keyout server-key.pem -out server-req.pem
openssl rsa -in server-key.pem -out server-key.pem
openssl x509 -req -in server-req.pem -days 1000 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem

# Create client certificate, remove passphrase, and sign it
openssl req -newkey rsa:2048 -days 1000 -nodes -keyout client-key.pem -out client-req.pem
openssl rsa -in client-key.pem -out client-key.pemw
openssl x509 -req -in client-req.pem -days 1000 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem
********************************************
vo my.cnf se dodava

[mysqld]
ssl-ca=/home/administrator/sqlcerts/ca-cert.pem
ssl-cert=/home/administrator/sqlcerts/server-cert.pem
ssl-key=/home/administrator/sqlcerts/server-key.pem

[client]
ssl-ca=/home/administrator/sqlcerts/ca-cert.pem
ssl-cert=/home/administrator/sqlcerts/client-cert.pem
ssl-key=/home/administrator/sqlcerts/client-key.pem
*********************************************
vo /etc/apparmor.d/usr.sbin.mysqld se dodava
  /home/administrator/sqlcerts/*.pem r,
*********************************************
*service mysql restart
*********************************************
za konektiranje mysql --host=localhost --ssl-ca=ca-cert.pem -p -u root
*/

public class MoveTablesAndReplicate {

	static class sqlConnection {
		/* SQL konekciska klasa */
		public Connection conn = null;

		/* SQL konekciska IP adresa */
		public String hostName = null;

		/* SQL konekciski korisnik */
		public String userName = null;

		/* SQL konekciski password za korisnik */
		public String password = null;

		/* SQL konekciska baza */
		public String database = null;

		/* SQL konekciski URL */
		public String url = "jdbc:mysql://";

		/* SQL konekciski klasi za query-ja */
		Statement stmtSelect = null, stmtSelectInsertDelete = null;

		/* SQL klasa za result od query-ja */
		ResultSet rs = null;

		/* Konstruktor */
		sqlConnection(String hostName, String userName, String password, String database) {
			this.hostName = hostName;
			this.userName = userName;
			this.password = password;
			this.database = database;
			url += hostName + "/" + database + "?verifyServerCertificate=false&useSSL=true&requireSSL=true";
		}
		
	}

	/* Definiraj source database */
	static sqlConnection connSrc = null;

	/* Definiraj destination database */
	static sqlConnection connDst = null;

	static void initiateSql() throws Exception {
		/* Iniciraj go drajverot za MySQL */
		Class.forName ("com.mysql.jdbc.Driver").newInstance();

		/* Iniciraj konekcija do MySQL serverot SRC */
		connSrc.conn = DriverManager.getConnection(connSrc.url, connSrc.userName, connSrc.password);
		/* Notificiraj go korisnikot */
		System.out.println("Source database connection established");

		/* Iniciraj konekcija do MySQL serverot DST */
		connDst.conn = DriverManager.getConnection(connDst.url, connDst.userName, connDst.password);
		/* Notificiraj go korisnikot */
		System.out.println("Destination database connection established");

		/* Iniciraj statement klasa (SELECT) */
		connSrc.stmtSelect = connSrc.conn.createStatement();

		/* Iniciraj statement klasa (INSERT, DELETE) */
		connSrc.stmtSelectInsertDelete = connSrc.conn.createStatement();

		/* Iniciraj statement klasa (INSERT, DELETE) */
		connDst.stmtSelectInsertDelete = connDst.conn.createStatement();
	}

	static void moveTablesAndReplicate(String from, String to, String destTo, int resultsPerQuery, int idUniqueColumn, boolean debug) throws Exception {
		/* Deklariraj klasa za result set */
		ResultSetMetaData rsMetaData;

		/* Deklariraj prefix za query Builder */
		String queryBuilderSrc = "INSERT INTO `" + connSrc.database + "`.`" + to + "` VALUES (";
		String queryBuilderDst = "INSERT INTO `" + connDst.database + "`.`" + destTo + "` VALUES (";

		/* Deklariraj finalQuery proizlezeno od queryBuilder */
		String finalQuerySrc = queryBuilderSrc;
		String finalQueryDst = queryBuilderDst;

		/* Deklariraj prefix za query Builder za DELETE */
		String deleteQueryBuilder;

		/* Deklariraj deleteFinalQuery proizlezeno od deleteQueryBuilder */
		String deleteFinalQuery;

		/* Counter za resultsPerQuery rezultati per query */
		int count = 0;

		/* Iniciraj Result Set i negov meta data za vlecenje na koloni */
		connSrc.rs = connSrc.stmtSelect.executeQuery("SELECT * FROM " + from);
		rsMetaData = connSrc.rs.getMetaData();

		/* Vidi kolku koloni postojat */
		int i = rsMetaData.getColumnCount();

		/* Zemi ja ID kolonata (se orientira DELETE spored nea) */
		String columnName = rsMetaData.getColumnName(idUniqueColumn);

		deleteQueryBuilder = "DELETE FROM `" + connSrc.database + "`.`" + from + "` WHERE `" + from + "`.`" + columnName + "` = ";
		deleteFinalQuery = deleteQueryBuilder;

		/* Iteracija se dodeka ima rezultati od SELECT-ot */
		while (connSrc.rs.next()) {

			/* Parsiraj go finalQuery po redici, za INSERT */
			for (int j=1;j<=i;j++) {
				finalQuerySrc += "'" + connSrc.rs.getString(j) + "',";
				finalQueryDst += "'" + connSrc.rs.getString(j) + "',";
			}
			finalQuerySrc = finalQuerySrc.substring(0, finalQuerySrc.length()-1) + "),";
			finalQueryDst = finalQueryDst.substring(0, finalQueryDst.length()-1) + "),";

			/* Parsiraj go deleteFinalQuery po redici, za DELETE */
			deleteFinalQuery += "'" + connSrc.rs.getString(idUniqueColumn) + "'";

			/* Ako e dostignat count (results per query) izvrsi INSERT i DELETE */
			if (count+1 == resultsPerQuery) {
				finalQuerySrc = finalQuerySrc.substring(0, finalQuerySrc.length()-1);
				finalQueryDst = finalQueryDst.substring(0, finalQueryDst.length()-1);

				if (debug) {
					System.out.println(finalQuerySrc);
					System.out.println(deleteFinalQuery);
					System.out.println(finalQueryDst);
				}
				else {
					connSrc.stmtSelectInsertDelete.execute(finalQuerySrc);
					connSrc.stmtSelectInsertDelete.execute(deleteFinalQuery);
					connDst.stmtSelectInsertDelete.execute(finalQueryDst);
				}

				finalQuerySrc = queryBuilderSrc;
				deleteFinalQuery = deleteQueryBuilder;
				finalQueryDst = queryBuilderDst;

				System.out.println("Moved " + (count+1) + " rows.");
				count = 0;
			}

			/* Vo sprotivno, prodolzi so parsiranje */
			else {
				finalQuerySrc += " (";
				deleteFinalQuery += " OR `" + from + "`.`" + columnName + "` = ";
				finalQueryDst += " (";
				count++;
			}
		}

		/* Zatvori go result set-ot */
		connSrc.rs.close();

		/* Zatvori go statement za SELECT */
		connSrc.stmtSelect.close();

		/* Ako ima nekoi preostanati redici (modulo), INSERT-iraj i DELETE-iraj gi */
		if (count != 0) {
			finalQuerySrc = finalQuerySrc.substring(0, finalQuerySrc.length()-" (".length()-1);
			deleteFinalQuery = deleteFinalQuery.substring(0, deleteFinalQuery.length()-(" OR `" + from + "`.`" + columnName + "` = ").length());
			finalQueryDst = finalQueryDst.substring(0, finalQueryDst.length()-" (".length()-1);
			if (debug) {
				System.out.println(finalQuerySrc);
				System.out.println(deleteFinalQuery);
				System.out.println(finalQueryDst);
			}
			else {
				connSrc.stmtSelectInsertDelete.execute(finalQuerySrc);
				connSrc.stmtSelectInsertDelete.execute(deleteFinalQuery);
				connDst.stmtSelectInsertDelete.execute(finalQueryDst);
			}

			System.out.println("Moved " + count + " rows.");
		}
	}

	static void closeVariables(sqlConnection conn, String server) {

		/* Ako statement za INSERT/UPDATE bil iniciran, zatvori go */
		if (conn.stmtSelectInsertDelete != null) {
			try {
				conn.stmtSelectInsertDelete.close();
			}
			catch (Exception e) { /* ignore close errors */ }
		}

		/* Ako result-setot bil iniciran, zatvori go */
		if (conn.rs != null) {
			try {
				conn.rs.close();
			}
			catch (Exception e) { /* ignore close errors */ }
		}

		/* Ako statement klasata (za SELECT) bila inicirana, zatvori ja */
		if (conn.stmtSelect != null) {
			try {
				conn.stmtSelect.close();
			}
			catch (Exception e) { /* ignore close errors */ }
		}

		/* Ako statement klasata (za INSERT, DELETE) bila inicirana, zatvori ja */
		if (conn.stmtSelectInsertDelete != null) {
			try {
				conn.stmtSelectInsertDelete.close();
			}
			catch (Exception e) { /* ignore close errors */ }
		}

		/* Ako konekcijata do SQL serverot bila inicirana, zatvori ja */
		if (conn.conn != null) {
			try {
				conn.conn.close();
				System.out.println(server + " database connection terminated");
			}
			catch (Exception e) { /* ignore close errors */ }
		}
	}
	
	static void debug() {
		/*System.setProperty("javax.net.ssl.trustStore","C:/client/truststore");
		System.setProperty("javax.net.ssl.trustStorePassword","123456");
		System.setProperty("javax.net.ssl.keyStore","C:/client/keystore");
		System.setProperty("javax.net.ssl.keyStorePassword","123456");*/

		Connection conn = null;
		try {
		//String url = "jdbc:mysql://192.168.0.231:3306/collector?verifyServerCertificate=false&useSSL=true&requireSSL=true";
		String url = "jdbc:mysql://192.168.0.231:3306/collector";
		/* Iniciraj go drajverot za MySQL */
		Class.forName ("com.mysql.jdbc.Driver").newInstance();

		/* Iniciraj konekcija do MySQL serverot SRC */
		conn = DriverManager.getConnection(url, "root", "123456");
		/* Notificiraj go korisnikot */
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			try {
				if (conn != null) conn.close();
			} catch (Exception e) {}
		}
	}

	public static void main(String[] args) {
		System.out.println(	"moveTablesAndReplicate(); implementation\n" + 
							"Dev Boro Sitnikovski/Ein-Sof, 20.08.2011\n" +
							"----------------------------------------");
		
		InputStream is = null;

		//debug();
		
		try {
			/* Namesti klucevi */
			System.setProperty("javax.net.ssl.trustStore","trust.store");
			System.setProperty("javax.net.ssl.trustStorePassword","123456");
			System.setProperty("javax.net.ssl.keyStore","key.store");
			System.setProperty("javax.net.ssl.keyStorePassword","123456");
			
			/* Loadiraj properties fajl */
			is = MoveTablesAndReplicate.class.getResourceAsStream("Collector.properties");
			Properties prop = new Properties();  
			prop.load(is);

			connSrc = new sqlConnection(prop.getProperty("Source.hostname"), prop.getProperty("Source.username"), prop.getProperty("Source.password"), prop.getProperty("Source.database"));
			connDst = new sqlConnection(prop.getProperty("Destination.hostname"), prop.getProperty("Destination.username"), prop.getProperty("Destination.password"), prop.getProperty("Destination.database"));

			/* Iniciraj konekcija na MySQL serverot */
			initiateSql();

			/* Zapocni so premestuvanje na tabelite */
			moveTablesAndReplicate(prop.getProperty("Source.table.from"), prop.getProperty("Source.table.to"), prop.getProperty("Destination.table.to"), Integer.parseInt(prop.getProperty("ResultsPerQuery")), Integer.parseInt(prop.getProperty("IdUniqueColumn")), false);

		} catch (Exception e) {

			/* Notificiraj go korisnikot za greskata */
			e.printStackTrace();

		} finally {

			if (is != null) {
				try {
					is.close();
				} catch (Exception e) { /* ignore close errors */ }
			}

			/* Zatvori gi otvorenite promenlivi */
			if (connSrc != null) closeVariables(connSrc, "Source");

			/* Zatvori gi otvorenite promenlivi */
			if (connDst != null) closeVariables(connDst, "Destination");

		}
	}
}