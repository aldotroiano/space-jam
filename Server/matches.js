var teams = require('./teams.js');
var map_gen = require('./map_generation.js')
var matches = [];
var team = {};

setInterval(match_init,100);

function player_migration(HOSTremoteAddress){
	var match_array = teams.fetch_players(HOSTremoteAddress);
	console.log("Length of team = ",match_array.length);
	var count = 1;
	
team = { "Tid" : match_array[0].Tid, "Pnum": match_array.length, "Status": 0 }
	
match_array.forEach(player => { 
	team[count] = {
	"Pid" : player.Pid,
	"Host" : player.host,
	"s_Status" : 0,
	"Usr" : player.usr,
	"tcp" : player.tcp,
	"udp" : player.udp,
	"x" : 	null,
	"y" : null,
	}
	count++;
	});

matches.push(team);
console.log(matches);
return true;
}

function match_init(){

matches.forEach(match => {

if (match.Status == 0){				//Sending game-player info
	
	for (var i = 1; i <= match.Pnum; i++){
		var arr = (match[i].udp).split(":");
		teams.send(JSON.stringify({TYPE : "INIT_GAME", STATUS : 1, TEAM_ID : match.Tid, Pnum : i}),arr[0],arr[1]);
		
	}
	}
	
});
}

function update_status(Tid,Pnum){
console.log("Updating status of Tid" + Tid + "and Pnum " + Pnum);

//matches[]
//Need to update status of single players in the amtch array object
//Continue with different status codes to get the system working. Without need of a stable connection


}

function update_player_pos(){

// TODO : Add algorithm to update the player position and save it to the object array
}

module.exports = {player_migration,update_status};





