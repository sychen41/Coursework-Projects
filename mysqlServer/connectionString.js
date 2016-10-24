/**
 * Created by Shiyi on 10/17/2016.
 */
var connectionString = {
    connection : {
        development : {
            host: 'localhost',
            user: 'sychen',
            password: '1111',
            database: 'test2'
        },
        production: {
            host: 'localhost',
            user: 'sychen',
            password: '1111',
            database: 'test2'
        }
    }
};

module.exports.mysqlConnectionString = connectionString;
