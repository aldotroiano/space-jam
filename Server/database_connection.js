
const connection = require('sqlite3').verbose();
let db = null;
var create_connection = function(){

	db = new connection.Database('./db/database',connection.OPEN_READWRITE,(err) => {
		if (err) {
            
            console.log('DATABASE CONNECTION ERROR. FILE NOT FOUND');
			console.error(err.message);
			process.exit(1);
		}
		console.log('Connected to Database');


});
}

	function add_player(remoteAddress){
	var query_insert = "INSERT INTO ONLINE_PLAYERS('IP ADDRESS') VALUES ('"+ remoteAddress +"');";
	db.serialize(() => {
		db.each(query_insert, (err) => {

	if (err) {
		console.error(err.message);
	}
	});
});
console.log("Added player to Table ONLINE_PLAYERS")
console.log(get_player_ID(remoteAddress));
}

	function remove_player(remoteAddress){

var query_delete = "DELETE FROM ONLINE_PLAYERS WHERE \"IP Address\" = '"+ remoteAddress +"';";

db.serialize(() => {
		db.each(query_delete, (err) => {
	if (err) {
		console.error(err.message);
	}
	});
});
console.log("Deleted player from Table ONLINE_PLAYERS")
}

	function get_player_ID(remoteAddress){

	var query_get_id = "SELECT ID as id FROM ONLINE_PLAYERS WHERE \"IP ADDRESS\" = '"+ remoteAddress +"';";

	db.serialize(() => {
		db.each(query_get_id, (err,resp) => {
		if(err) { console.error(err.message) }

	return resp.id;
});
});

}
	function create_team(remoteAddress,team_name){

	//console.log(get_player_ID(remoteAddress));
console.log(team_name)
	
}

module.exports = {create_connection,add_player,remove_player,create_team};
