var db = require('./database_connection.js');
var dgram = require('dgram');
var server = dgram.createSocket('udp4');

var players = {};
server.on('error', (err) => {
console.log('server error: \n %s', err.stack);
server.close();
});

server.on('message', (msg,rinfo) => {
try{
	decoded_json = JSON.parse(msg);

	switch (decoded_json.TYPE){

  	case "INITIATE":

      	console.log('Received INITIATE UDP from: %s : %s', rinfo.address,rinfo.port);
      	var addr = String(String(rinfo.address) + ":" + String(rinfo.port));
      	db.initiate_udp(decoded_json.TCPADDRESS,addr).then(function(){
				send(JSON.stringify({TYPE : "INITIATE", RES : "OK"}),rinfo.address,rinfo.port);

				players[sock.id] ={
						


				}
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

server.on('listening', () => {
const address = server.address();
console.log('UDP server listening on port: %s',address.port);
});

server.bind(55000);

function send(msg,address,port){

	server.send(msg, port, address);
	console.log("Sent!")

}


module.exports = {send};
