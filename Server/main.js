var client_listener = require('./handshake_listener.js');
var database_connection = require('./database_connection.js
')

//Start Database connection
database_connection.create_connection();
//Always running loop that registers new clients
client_listener.data.handshake_listener();


