package camaral.dbmigration.aws;


import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class DbMigration implements RequestHandler<Void, String> {

    @Override
    public String handleRequest(Void input, Context context) {
        return "Success";
    }
}