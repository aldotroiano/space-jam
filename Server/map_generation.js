//																//

/*			 MAP GENERATION						*/

//																//
function random_Int_Calculator(lower,higher){
return Math.floor(Math.random() * (higher - lower + 1) + lower)
}

function generate_obstacles(){
	var x_obstacles = new Array(300);
	for (var i = 0; i < 200 ; i++ ){
		x_obstacles[i] = random_Int_Calculator(1,650);
	}
	return x_obstacles;
}
module.exports = {generate_obstacles}
