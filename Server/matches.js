var teams = require('./teams.js');
var matches = [];
var team = {};

function player_migration(HOSTremoteAddress){
	var match_array = teams.fetch_players(HOSTremoteAddress);
	console.log("Length of team = ",match_array.length);
	var count = 1;
	//TODO : Add the players to the single object in the array
	

team = {
	"Tid" : match_array[0].Tid,
	"Pnum": match_array.length
	}
	

match_array.forEach(player => { 

	team[count] = {
	"Pid" : player.Pid,
	"Host" : player.host,
	"Usr" : player.usr,
	"TCP" : player.tcp,
	"UDP" : player.udp,
	"x" : null,
	"y" : null,
	}
	

	
	count++;
	});

matches.push(team);
console.log(matches);
}

function update_player_pos(){

// TODO : Add algorithm to update the player position and save it to the object array
}

module.exports = {player_migration};





