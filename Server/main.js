var client_listener = require('./handshake_listener.js');
var database_connection = require('./database_connection.js');


database_connection.create_connection();

client_listener.start_listener();


