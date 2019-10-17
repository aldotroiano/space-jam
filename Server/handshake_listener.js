var db = require('./database_connection.js');
var start_listener = function(){

var net = require('net');
var counter = 0
// Configuration parameters
var HOST = '0.0.0.0';
var PORT = 41555;
 
// Create Server instance 
var server = net.createServer(onClientConnected);  
 
server.listen(PORT, HOST, function() {  
  console.log('server listening on %j', server.address());
});
 
function onClientConnected(sock) {  

  var remoteAddress = sock.remoteAddress + ':' + sock.remotePort;
  counter = counter + 1;
  console.log('NEW CONNECTED CLIENT: %s', remoteAddress);
  console.log('Connected clients: %i', counter);
 
  sock.on('data', function(data) {

try{
	decoded_json = JSON.parse(data);

	switch (decoded_json.TYPE){

  	case "HANDSHAKE":
      	console.log('Received IH from: %s', remoteAddress);
      	db.add_player(remoteAddress);
      	sock.write(JSON.stringify({TYPE : "HANDSHAKE", RES : "OK"}));
    	break;

  	case "KEEPALIVE":
		console.log('Received KAP from: %s', remoteAddress);
    	sock.write(JSON.stringify({TYPE : "KEEPALIVE", RES : "OK"}));
		break;

	case "TEAM_CREATE":
		
		console.log("SENDING PACKET")
		sock.write(JSON.stringify({TYPE : "TEAM_CREATE", RES : "OK"}));
db.create_team(remoteAddress,decoded_json.NAME);
	break;

	default:
		break;
}
}
catch (error){
console.log(error);
}
  });


  sock.on('close',  function () {
    console.log('connection from %s closed', remoteAddress);
	db.remove_player(remoteAddress)
    counter = counter - 1;
    console.log('Connected clients: %i', counter)
  });
  sock.on('error', function (err) {
    console.log('Connection %s error: %s', remoteAddress, err.message);
  });
};
}

module.exports = {start_listener};
