var teams = require('./teams.js');
var map_gen = require('./map_generation.js')
var matches = [];
var team = {};

setInterval(match_init,500);

function player_migration(HOSTremoteAddress){
	var match_array = teams.fetch_players(HOSTremoteAddress);
	console.log("Length of team = ",match_array.length);
	var count = 1;
	
team = { "Tid" : match_array[0].Tid, "Pnum": match_array.length, "Status": 0 }
	
match_array.forEach(player => { 
	team[count] = {
	"Pid" : player.Pid,
	"Host" : player.host,
	"st" : 0,
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

switch (match.Status){				//Switch sending game-player info

case 0:
	for (var i = 1; i <= match.Pnum; i++){
		var arr = (match[i].udp).split(":");
		if(match[i].st == 0){
			teams.send(JSON.stringify({TYPE : "INIT_GAME", STATUS : 1, Tid : match.Tid, Pindex : i}),arr[0],arr[1]);
		}
	}
	break;

case 1:
	console.log("Entered 1");
	for (var i = 1; i <= match.Pnum; i++){
		var arr = (match[i].udp).split(":");
		teams.send(JSON.stringify({TYPE : "INIT_GAME", STATUS : 2, INFO: match}),arr[0], arr[1]);
		}
	break;
	
case 2:
	console.log("Entered 2");
	var temp_map = map_gen.generate_obstacles();
	for (var i = 1; i <= match.Pnum; i++){
		var arr = (match[i].udp).split(":");
		teams.send(JSON.stringify({TYPE : "INIT_GAME", STATUS : 3, MAP: temp_map}),arr[0], arr[1]);
		}
	break;
	

	
	}
	
});
}

function update_status(Tid,Pindex,status){
//console.log("Updating status of Tid" + Tid + "and Pnum " + Pindex);

matches.forEach(match => {
if(match.Tid == Tid){
match[Pindex].st = status;		//Incrementing status variable
console.log("Increment single status var");

var sum = 0;
for(var i = 1; i <= match.Pnum; i++){ sum = sum + match[i].st; }
if(sum/match.Pnum == status){ match.Status = status; }
}
console.log(match);

});

//matches[]
//Need to update status of single players in the amtch array object
//Continue with different status codes to get the system working. Without need of a stable connection


}

function update_player_pos(){

// TODO : Add algorithm to update the player position and save it to the object array
}

module.exports = {player_migration,update_status};





