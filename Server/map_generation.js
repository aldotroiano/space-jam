function random_Int_Calculator(lower,higher){
return Math.floor(Math.random() * (higher - lower + 1) + lower)
}

function generate_obstacles(){
	var x_obstacles = new Array(500);
	for (var i = 0; i < 10 ; i++ ){
		x_obstacles[i] = random_Int_Calculator(1,650);
	}
	return x_obstacles;
}
module.exports = {generate_obstacles}
