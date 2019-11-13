var db = require('./database_connection.js');
var teams = require('./teams.js');
var start_listener = function(){

var net = require('net');
var counter = 0

// Configuration parameters
var HOST = '0.0.0.0';
var PORT = 41555;

// Create Server instance
var server = net.createServer(onClientConnected);

server.listen(PORT, HOST, function() {
  console.log('TCP server listening on: %s', PORT);
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
      	sock.write(JSON.stringify({TYPE : "HANDSHAKE", RES : "OK", IPADDRESS: remoteAddress}));
    	break;

  	case "KEEPALIVE":
		console.log('Received KAP from: %s', remoteAddress);
    	sock.write(JSON.stringify({TYPE : "KEEPALIVE", RES : "OK"}));
		break;

	case "CREATE_TEAM":
		db.team_creation_adding(remoteAddress,decoded_json.NAME,decoded_json.USERNAME).then(function(isHost){
		sock.write(JSON.stringify({TYPE : "CREATE_TEAM", RES : "OK", ISHOST: isHost}));
		console.log("PACKET SENT");
		});
		break;

	case "LEAVE_ROOM":
		db.leave_room(remoteAddress,decoded_json.NAME).then(function(ok){
		sock.write(JSON.stringify({TYPE : "LEAVE_ROOM", RES : "OK"}));
		console.log("PLAYER LEFT ROOM");
		counter -= 1;
		teams.delete_object(remoteAddress);
		});
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
 		try{
		db.player_exists(remoteAddress).then(function(exists){

			if(exists == 1){
				db.leave_room(remoteAddress).then(function(ok){
		 		db.remove_player(remoteAddress);
    		counter = counter - 1;
    		console.log('connection from %s closed', remoteAddress);
  			console.log('Connected clients: %i', counter);
  			teams.delete_object(remoteAddress);
				});
			}
			else{
			console.log('connection from %s closed', remoteAddress);
			console.log('Connected clients: %i', counter);
			}
		});
		}
		catch(e){
		console.log(e);
		}
  });


  sock.on('error', function (err) {
    console.log('Connection %s error: %s', remoteAddress, err.message);
  });
};
}

module.exports = {start_listener};
