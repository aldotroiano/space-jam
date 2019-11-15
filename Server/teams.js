var db = require('./database_connection.js');
var dgram = require('dgram');
var server = dgram.createSocket('udp4');


var players = [];
var player = {};

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
      	db.initiate_udp(decoded_json.TCPADDRESS,addr).then(function([player_id,team_id,is_host,username]){
				send(JSON.stringify({TYPE : "INITIATE", RES : "OK"}),rinfo.address,rinfo.port);
				create_object(player_id,team_id,is_host,username,decoded_json.TCPADDRESS,addr);
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
	setInterval(periodic_UDP,2000);
	});

server.bind(55000);

function create_object(player_id,team_id,is_host,username,tcp,udp){
console.log("ADDED PLAYER to object");
player = {
	"Tid" : team_id,
	"Pid" : player_id,
	"usr" : username,
	"host" : is_host,
	"tcp" : tcp,
	"udp" : udp,
	"ingame" : false,
}
players.push(player);
console.log(players);
periodic_UDP();
}

function delete_object(tcpa){
players.splice(players.findIndex(x => x.tcp === tcpa),1);
console.log(players.length);
}

function periodic_UDP(){

	for (var a = 0; a < players.length; a++){
		var addr = players[a].udp;
		var addr_s = addr.split(":");
		var tID = players[a].Tid;
		var tmp_nm = [];
		var tmp_ishost = [];
	
		for(var b = 0; b < players.length; b++){
			if(players[b].Tid == tID){
				tmp_nm.push(players[b].usr);
				tmp_ishost.push(players[b].host);
			}
		}
		var jsn = "{";
		for (var x = 0; x < tmp_nm.length; x++){
		jsn += "\"NAME"+x+"\" : \""+ tmp_nm[x] + "\", \"HOST"+x+"\" : "+ tmp_ishost[x] +",";
		}
		send(jsn+"}",addr_s[0],addr_s[1]);
	}
}

function send(msg,address,port){
	server.send(msg, port, address);
}


module.exports = {send,delete_object};
