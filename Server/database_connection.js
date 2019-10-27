
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

	function add_player(remoteAddress,player_name){
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

	function add_to_team(player_id,team_name,username){

	return new Promise((resolve, reject) => {
	
		db.beginTransaction(function(err,transaction){
		transaction.run("UPDATE ONLINE_PLAYERS SET Name = \""+ username +"\" WHERE ID = "+ player_id +";")
		transaction.run("INSERT INTO TEAM_PLAYER (\"TEAM ID_FK\",PLAYER_ID_FK,is_Host) VALUES ((SELECT Team_ID FROM TEAMS 			WHERE Team_name = \""+ team_name +"\"),"+ 			player_id +",(CASE WHEN (SELECT COUNT(*) is_Host FROM TEAM_PLAYER 			WHERE \"TEAM ID_FK\" = (SELECT Team_ID FROM TEAMS 			WHERE Team_name = \""+ team_name +"\") AND 			is_Host = 1) = 0 THEN 1 ELSE 0 END));")

		transaction.commit(function (err){
			if(err) { reject(err); }
			resolve("done");
		});
	});
});
	}

function create_team(player_id,team_name,username){

	return new Promise((resolve, reject) => {
	
		db.beginTransaction(function(err,transaction){
		transaction.run("UPDATE ONLINE_PLAYERS SET Name = \""+ username +"\" WHERE ID = "+ player_id +";")
		transaction.run("INSERT INTO TEAMS (Team_name) VALUES (\""+ team_name +"\");");
		transaction.run("INSERT INTO TEAM_PLAYER (\"TEAM ID_FK\",PLAYER_ID_FK,is_Host) VALUES (last_insert_rowid(),"+ 			player_id +",(CASE WHEN (SELECT COUNT(*) is_Host FROM TEAM_PLAYER WHERE \"TEAM ID_FK\" = last_insert_rowid() AND 			is_Host = 1) = 0 THEN 1 ELSE 0 END));")

		transaction.commit(function (err){
			if(err) { reject(err); }
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

function is_host(player_id){
	var SQLquery = "SELECT is_Host AS ishost FROM TEAM_PLAYER WHERE PLAYER_ID_FK = \"" + player_id + "\"";
	return new Promise((resolve, reject) => {
	db.get(SQLquery, (err,resp) => {
		if(err) { reject(err); }
		resolve(JSON.parse(resp.ishost))
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


function selecthost_and_leave(team_id,player_id,remoteAddress){

	return new Promise((resolve, reject) => {
	
		db.beginTransaction(function(err,transaction){
		transaction.run("UPDATE TEAM_PLAYER SET is_Host = 0 WHERE is_Host = 1 AND \"TEAM ID_FK\" = \"" + team_id + "\" AND PLAYER_ID_FK = \"" + player_id + "\"");
		transaction.run("UPDATE TEAM_PLAYER SET is_Host = 1 WHERE \"TEAM ID_FK\" = \"" + team_id + "\" AND PLAYER_ID_FK = (SELECT PLAYER_ID_FK FROM TEAM_PLAYER WHERE PLAYER_ID_FK <> \"" + player_id + "\" AND \"TEAM ID_FK\" = \"" + team_id + "\" AND is_Host = 0 LIMIT 1)");
		
		transaction.run("DELETE FROM TEAM_PLAYER WHERE PLAYER_ID_FK = \"" + player_id + "\" AND \"TEAM ID_FK\" = \"" + team_id + "\"")
		transaction.run("DELETE FROM ONLINE_PLAYERS WHERE \"IP ADDRESS\" = \"" + remoteAddress + "\"")

		transaction.commit(function (err){
			if(err) { reject(err); }
			resolve(true);
		});
	});
});
}

function delete_player_from_team(team_id,player_id,remoteAddress){

	return new Promise((resolve, reject) => {
	
		db.beginTransaction(function(err,transaction){
		
		transaction.run("DELETE FROM TEAM_PLAYER WHERE PLAYER_ID_FK = \"" + player_id + "\" AND \"TEAM ID_FK\" = \"" + team_id + "\"")
		transaction.run("DELETE FROM ONLINE_PLAYERS WHERE \"IP ADDRESS\" = \"" + remoteAddress + "\"")

		transaction.commit(function (err){
			if(err) { reject(err); }
			resolve(true);
		});
	});
});
}
function delete_team(team_id,player_id,remoteAddress){

	return new Promise((resolve, reject) => {
	
		db.beginTransaction(function(err,transaction){
		transaction.run("DELETE FROM TEAM_PLAYER WHERE PLAYER_ID_FK = \"" + player_id + "\" AND \"TEAM ID_FK\" = \"" + team_id + "\"")
		transaction.run("DELETE FROM TEAMS WHERE \"TEAM ID_FK\" = \"" + team_id + "\" ")
		transaction.run("DELETE FROM ONLINE_PLAYERS WHERE \"IP ADDRESS\" = \"" + remoteAddress + "\"")


		transaction.commit(function (err){
			if(err) { reject(err); }
			resolve(true);
		});
	});
});
}
	
	function check_for_team_mates(team_id){
		var SQLquery = "SELECT COUNT(*) AS number FROM TEAM_PLAYER WHERE \"TEAM ID_FK\" = \"" +  team_id + "\"";

		return new Promise((resolve, reject) => {
			db.get(SQLquery, (err,resp) => {
			if(err) { 
				console.log(err);
				reject(err); }
			if(JSON.parse(resp.number) > 1){
				resolve(1);
			}
			else{
				resolve(0);
			}
			});
		});
	}


	function get_team_ID(team_name){
	var SQLquery = "SELECT Team_ID AS id FROM TEAMS WHERE TEAM_NAME = \"" +  team_name + "\"";

		return new Promise((resolve, reject) => {
		db.get(SQLquery, (err,resp) => {
		if(err) { console.log(err);
		reject(err); }
		resolve(JSON.parse(resp.id))
});
});
}


	function team_creation_adding(remoteAddress,team_name,username){

	return new Promise((resolve, reject) => {
	get_player_ID(remoteAddress).then(function(player_id) { 
	Player_in_team(team_name).then(function(team_exists){
	if(team_exists == 1){
		add_to_team(player_id,team_name,username).then(function(){
		console.log("ADDED TO TEAM");
		is_host(player_id).then(function(ishost){
		resolve(ishost);
});
		});	
	}
	else if(team_exists == 0){
		create_team(player_id,team_name,username).then(function(){
		console.log("TEAM CREATED");
		is_host(player_id).then(function(ishost){
		resolve(ishost);
		});
		});
	}
	},
	function(err){ 
	console.log(err); 
	reject();
	});

	
});
});
};

	function leave_room(remoteAddress,team_name){
	
		return new Promise((resolve, reject) => {
		var team_ID_global;
		var player_ID_global;
			get_player_ID(remoteAddress).then(function(player_id) { 	//Retreive player_id
				player_ID_global = player_id;
				is_host(player_id).then(function(ishost){				//Retrieve is_host value
					if(ishost == 1){					//Check whether exiting Player is Room host
						get_team_ID(team_name).then(function(team_id){	//Retrieve Team ID 
							team_ID_global = team_id;
							check_for_team_mates(team_id).then(function(resp){ 	//Retrieve 1 if NOT alone in team, 0 otherwise
							if(resp == 1){				//Other people in the team
								selecthost_and_leave(team_id, player_id, remoteAddress).then(function(val){
									if (val) { resolve("OK") }
									else{ reject(0)}
								});
							}
							else if(resp == 0){			//Leaving team with only one occupier, should delete team
								delete_team(team_id,player_id,remoteAddress).then(function(val){
									if (val) { resolve ("OK") }
									else { reject(0) }
								});
							}
						});
						});
					}
					else if(ishost == 0){			//If exiting player is NOT host
							delete_player_from_team(team_ID_global,player_ID_global,remoteAddress).then(function(val){
							if (val) {resolve ("OK")}
							else { reject (0) }
							});
					}
				});
			});
});
}


module.exports = {create_connection,add_player,remove_player,team_creation_adding,leave_room};
