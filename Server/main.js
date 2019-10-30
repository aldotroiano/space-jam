var client_listener = require('./handshake_listener.js');
var db_con = require('./database_connection.js');
var udp = require('./udp.js');

db_con.create_connection()
client_listener.start_listener();



