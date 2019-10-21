
const sqlite3 = require('sqlite3'), TransactionDatabase = require('sqlite3-transactions').TransactionDatabase;
let db = null;
var create_connection = function(){

	db = new TransactionDatabase(new sqlite3.Database('./db/database',sqlite3.OPEN_READWRITE,(err) => {
		if (err) {
            
            console.log('DATABASE CONNECTION ERROR. FILE NOT FOUND');
			console.error(err.message);
			process.exit(1);
		}
		console.log('Connected to Database');


}));

}

	function add_player(remoteAddress){
	var query_insert = "INSERT INTO ONLINE_PLAYERS('IP ADDRESS') VALUES ('"+ remoteAddress +"');";

	db.exec(query_insert, function(err) {
	if (err) {
		console.error(err.message);
	}
});
console.log("Added player to Table ONLINE_PLAYERS")

}

	function remove_player(remoteAddress){

	var query_delete = "DELETE FROM ONLINE_PLAYERS WHERE \"IP Address\" = '"+ remoteAddress +"';";

	db.exec(query_delete, function(err) {
		if (err) {
			console.error(err.message);
		}
	});
	console.log("Deleted player from Table ONLINE_PLAYERS")
	}

	function add_to_team(player_id,team_name){
	console.log("ADDING PLAYER TO TEAM")
	console.log(player_id)
	console.log(team_name)

	}

function create_team(player_id,team_name){

	return new Promise((resolve, reject) => {
	
		db.beginTransaction(function(err,transaction){

		transaction.run("INSERT INTO TEAMS (Team_name) VALUES (\""+ team_name +"\");");
		transaction.run("INSERT INTO TEAM_PLAYER (\"TEAM ID_FK\",PLAYER_ID_FK,is_Host) VALUES (last_insert_rowid(),"+ 			player_id +",(CASE WHEN (SELECT COUNT(*) is_Host FROM TEAM_PLAYER WHERE \"TEAM ID_FK\" = last_insert_rowid() AND 			is_Host = 1) = 0 THEN 1 ELSE 0 END));")

		transaction.commit(function (err){
			if(err) { reject(err); }
			console.log("done");
			resolve("done");
		});
	});
});}

	function get_player_ID(remoteAddress){
	var SQLquery = "SELECT ID as id FROM ONLINE_PLAYERS WHERE \"IP ADDRESS\" = \"" +  remoteAddress + "\" ";

		return new Promise((resolve, reject) => {
		db.get(SQLquery, (err,resp) => {
		if(err) { reject(err); }
		resolve(JSON.parse(resp.id))
});
});
}

	function Player_in_team(team_name){
	var SQLquery = "SELECT COUNT(*) AS Count FROM TEAMS WHERE TEAM_NAME = \"" +  team_name + "\"";

		return new Promise((resolve, reject) => {
		db.get(SQLquery, (err,resp) => {
		if(err) { console.log(err);
		reject(err); }
		resolve(JSON.parse(resp.Count))
});
});
}
	function team_creation_adding(remoteAddress,team_name){


	get_player_ID(remoteAddress).then(function(player_id) { 
	console.log("in_get_playerID")
	Player_in_team(team_name).then(function(team_exists){
		console.log("Player_in_team" + team_exists)		
	if(team_exists == 1){
	console.log("TEAM EXISTS")
		//add_to_team(player_id,team_name).then(function(successful))	{
		add_to_team(player_id,team_name);
		return;
	}
	else if(team_exists == 0){
	create_team(player_id,team_name).then(function(done){
	console.log("TEAM CREATED");
	return;
});
	}
	},
	function(err){ 
	console.log(err); 
	});

	
});
};

module.exports = {create_connection,add_player,remove_player,team_creation_adding};
