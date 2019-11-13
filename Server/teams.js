



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
}

function periodic_UDP(){

	for (var a = 0; a < players.length; a++){
		var addr = players[a].udp;
		var addr_s = addr.split(":");
		var tID = players[a].Tid;
		var tmp_nm = [];
		//var tmp_udp = [];
	
		for(var b = 0; b < players.length; b++){
			if(players[b].Tid == tID){
				tmp_nm.push(players[b].usr);
				//tmp_udp.push(players[b].udp);
			}
		}
		
		console.log("SEND:" + tmp_nm + " ADDRESS: " + addr_s[0] + "PORT: " + addr_s[1]);
	}

}

module.exports = {create_object,delete_object,periodic_UDP};

