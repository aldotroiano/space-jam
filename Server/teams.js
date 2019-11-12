var players = [];
var player = {};


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
}

function delete_object(tcpa){
players.splice(players.findIndex(x => x.tcp === tcpa),1);
}

module.exports = {create_object,delete_object};
