//																//
//
/*			 MAP GENERATION						*/
/*				Aldo Troiano				 		*/
//						2020								//

function random_calc(lower,higher){
return Math.floor(Math.random() * (higher - lower + 1) + lower)
}

function generate_obstacles(){
	var nObstacles = 10;		//original 200
	var nAsteroids = 150;
	var total_y = 0;
	
	var obstacles = new Array(nObstacles);
	var asteroids = new Array(nAsteroids);
	var y_total = 0;
	for (var i = 0; i < nObstacles ; i++ ){
		obstacles[i] = new Array(2);
		obstacles[i][0] = random_calc(50,615);
		var rand_y = random_calc(400,800);
		obstacles[i][1] = total_y + rand_y;
		total_y = total_y + rand_y;
		
	}
	
	for (var i = 0; i < nAsteroids; i++){
		asteroids[i] = new Array(2);
		asteroids[i][0] = random_calc(50,615);
		asteroids[i][1] = 300;
	}
	
	return [obstacles,asteroids,total_y];
	
}

module.exports = {generate_obstacles}
