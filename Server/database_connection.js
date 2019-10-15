
const db_con = require('sqlite3').verbose();
var create_connection = function(){

	let db = new db_con.Database('./database.db', (err) => {
		if (err) {
			console.error(err.message);
		}
		console.log('Connected to Database');
});
}
module.exports = {create_connection};
