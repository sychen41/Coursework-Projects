/**
 * Created by Shiyi on 10/17/2016.
 */
var mysql = require('mysql');
var connectionString = require('./connectionString.js');
var mysqlConnectionProvider = {
    startConnection: function() {
        var connection = mysql.createConnection(connectionString.mysqlConnectionString.connection.development);
        connection.connect(function(err){
            if(!err) {
                console.log("Database is connected by connection provider");
            }else {
                console.log("Error connection database");
            }
        });
        return connection;
    },
    endConnection: function(currentConnection) {
        if(currentConnection) {
            currentConnection.end(function (err) {
                if(err) {
                    alert("Failed to close mysql connection");
                } else {
                    console.log("connection closed successfully by connection provider");
                }
            });
        }
    }
};

module.exports.connectionProdiver = mysqlConnectionProvider;
