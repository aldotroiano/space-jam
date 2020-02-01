//																//

/*			 MAP GENERATION						*/

//																//
function random_calc(lower,higher){
return Math.floor(Math.random() * (higher - lower + 1) + lower)
}

function generate_obstacles(){
	var nHoriz_obstacles = 200;
	var nAsteroids = 60;
	
	var obstacles = new Array(300);
	var y_total = 0;
	for (var i = 0; i < nHoriz_obstacles ; i++ ){
		obstacles[i] = new Array(2);
		obstacles[i][0] = random_calc(50,615);
		obstacles[i][1] = 500;
	}
	
	for (var i = nHoriz_obstacles; i < nHoriz_obstacles+nAsteroids; i++){
		obstacles[i] = new Array(2);
		obstacles[i][0] = random_calc(50,615);
		obstacles[i][1] = 300;
	}
	
	return obstacles;
	
}

module.exports = {generate_obstacles}
