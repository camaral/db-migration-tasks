package camaral.dbmigration.aws;

import com.amazonaws.services.lambda.runtime.Context;
import liquibase.Liquibase;
import liquibase.changelog.DatabaseChangeLog;
import liquibase.database.Database;
import liquibase.database.DatabaseConnection;
import liquibase.database.DatabaseFactory;
import liquibase.database.OfflineConnection;
import liquibase.database.jvm.JdbcConnection;
import liquibase.exception.DatabaseException;
import liquibase.logging.LogService;
import liquibase.logging.LogType;
import liquibase.logging.Logger;
import liquibase.resource.ClassLoaderResourceAccessor;
import liquibase.resource.ResourceAccessor;
import org.h2.jdbcx.JdbcDataSource;

import java.sql.Connection;


public class DbMigration {

    protected final Logger log = LogService.getLog(DbMigration.class);

    public static void main(String[] args) {
        new DbMigration().run(null, null);
    }

    public Integer run(Void input, Context ctx) {
        log.info("Calling db-migration function");

        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:mydb");
        ds.setUser("sa");
        ds.setPassword("sa");

        log.info("H2 instance created");

        try (Connection connection = ds.getConnection()) {
            DatabaseChangeLog databaseChangeLog = new DatabaseChangeLog("classpath:db.changelog.xml");
            ClassLoaderResourceAccessor resourceAccessor = new ClassLoaderResourceAccessor();
            Database database = DatabaseFactory.getInstance().findCorrectDatabaseImplementation(new JdbcConnection(connection));
            Liquibase liquibase = new Liquibase(databaseChangeLog, resourceAccessor, database);
            liquibase.update("");
            return 0;
        } catch (Exception e) {
            log.severe(String.format("An exception happened: %s\n", e.toString()), e);
            return -101;
        }
    }

}