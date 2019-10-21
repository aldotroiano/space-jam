
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
	var SQLquery = "SELECT ID as id FROM ONLINE_PLAYERS WHERE \"IP ADDRESS\" = \"" +  remoteAddress + "\" ";

		return new Promise((resolve, reject) => {
		db.get(SQLquery, (err,resp) => {
		if(err) { reject(err); }
		resolve(JSON.parse(resp.id))
});
});
}
	function create_team(remoteAddress,team_name){


	get_player_ID(remoteAddress).then(function(res) { 
/*
BEGIN TRANSACTION;
INSERT INTO TEAMS (Team_name) VALUES ("ciaociao");
INSERT INTO TEAM_PLAYER ("TEAM ID_FK",PLAYER_ID_FK,is_Host) VALUES 
(last_insert_rowid(),60,(CASE WHEN (SELECT COUNT(*) is_Host FROM TEAM_PLAYER WHERE "TEAM ID_FK" = last_insert_rowid() AND is_Host = 1) > 0 THEN
	 1
	ELSE 0
	END)
	);

COMMIT;*/
	console.log(res);
return;
	
	},
	function(err){ 
	console.log(err); 
	});

	
}

module.exports = {create_connection,add_player,remove_player,create_team};
