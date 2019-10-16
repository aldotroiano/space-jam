
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
}

	function remove_player(remoteAddress){

var query_delete = "DELETE FROM ONLINE_PLAYERS WHERE \"IP Address\" = '"+ remoteAddress +"';";
	console.log(query_delete)
db.serialize(() => {
		db.each(query_delete, (err) => {

	if (err) {
		console.error(err.message);
	}
	});
});
	}
module.exports = {create_connection,add_player,remove_player};
