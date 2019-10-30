var dgram = require('dgram');
var server = dgram.createSocket('udp4');

server.on('error', (err) => {
console.log('server error: \n %s', err.stack);
server.close();
});

server.on('message', (msg,rinfo) => {
console.log('server got: %s from %s : %s',msg,rinfo.address,rinfo.port);
send_UDP_message(rinfo.address,rinfo.port);
});

server.on('listening', () => {
const address = server.address();
console.log('server listening %s : %s',address.address,address.port);
});

server.bind(55000);

function send_UDP_message(address,port){
for (var i = 0; i < 50; i++){
	server.send('HELLO WORLD', 0, 12, port, address);
	console.log("MESSAGE SENT!!!!!!!")
}
}


module.exports = {send_UDP_message};
