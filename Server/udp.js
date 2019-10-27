var dgram = require('dgram');

var client = dgram.createSocket('udp4');

function send_UDP_message(){
for (var i = 0; i < 50; i ++){
	client.send('HELLO WORLD', 0, 12, 12000, '');
	console.log("MESSAGE SENT!!!!!!!")
}
}

module.exports = {send_UDP_message};
