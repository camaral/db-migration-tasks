package camaral.dbmigration.aws

import spock.lang.Specification;

class DbMigrationTest extends Specification {
    def "succeed: run with no parameters"() {
        expect:
        0 == new DbMigration().run(null, null);
    }
}
