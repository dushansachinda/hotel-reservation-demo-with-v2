import ballerina/log;
//import ballerina/os;
import ballerina/sql;
import ballerina/time;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

mysql:Client mysqlEp;

function init() returns error? {
    //int dbPort = check int:fromString(dbPortStr);
    log:printInfo("DB INFO: ", host = dbHost, user = dbUser, password = dbPassword, database = dbName, port = dbPort);

    mysqlEp = check new (host = dbHost, user = dbUser, password = dbPassword, database = dbName, port = dbPort);
}

# This function provides the available room types for a given date range and guest capacity
#
# + checkinDate - checkin date
# + checkoutDate - checkout date
# + guestCapacity - guest capacity
# + return - returns the available room types
function getAvailableRoomTypes(string checkinDate, string checkoutDate, int guestCapacity) returns RoomTypeData[]|error {
    time:Utc userCheckinUTC = check time:utcFromString(checkinDate);
    time:Utc userCheckoutUTC = check time:utcFromString(checkoutDate);
    sql:ParameterizedQuery sqlQuery = `SELECT rt.*
        FROM room_type rt
        WHERE rt.guest_capacity >= ${guestCapacity}
        AND EXISTS (
            SELECT r.*
            FROM room r
            WHERE r.type_id = rt.id
            AND NOT EXISTS (
                SELECT res.*
                FROM reservation res
                WHERE res.room_number = r.number
                AND res.checkin_date < ${userCheckinUTC}
                AND res.checkout_date > ${userCheckoutUTC}
            )
        )`;
    stream<RoomTypeData, sql:Error?> infoStream = mysqlEp->query(sqlQuery);

    RoomTypeData[] roomTypes = [];

    error? e = infoStream.forEach(function(RoomTypeData roomTypeData) {
        log:printInfo("RoomType: ", val= roomTypeData.name);
        roomTypes.push(roomTypeData);
    });
    
    if e is error {
        log:printError("Error processing stream", 'error = e);
        return e;
    }
    return roomTypes;
}

configurable string dbHost = ?; //os:getEnv("DB_HOST");
configurable string dbUser = ?; //os:getEnv("DB_USERNAME");
configurable string dbPassword = ?; //os:getEnv("DB_PASSWORD");
configurable string dbName =?; //os:getEnv("DB_NAME");
configurable int dbPort = ?;//os:getEnv("DB_PORT");

