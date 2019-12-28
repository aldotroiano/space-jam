var teams = require('./teams.js');


function player_migration(HOSTremoteAddress){
	var match_array = teams.fetch_players(HOSTremoteAddress);
	console.log("Length of team = ",match_array.length);
}

module.exports = {player_migration};





