var methods = {

handshake_listener: function(){
var net = require('net');
var counter = 0;
// Configuration parameters
var HOST = '0.0.0.0';
var PORT = 41555;
 
// Create Server instance 
var server = net.createServer(onClientConnected);  
 
server.listen(PORT, HOST, function() {  
  console.log('server listening on %j', server.address());
});
 
function onClientConnected(sock) {  

  var remoteAddress = sock.remoteAddress + ':' + sock.remotePort;
  counter = counter + 1;
  console.log('NEW CONNECTED CLIENT: %s', remoteAddress);
  console.log('Connected clients: %i', counter);
 
  sock.on('data', function(data) {
    if(data == 'IH'){
      console.log('Received IH from: %s', remoteAddress);
      
      sock.write('IH-RX')
    }
    else if(data == 'KAP'){
      console.log('Received KAP from: %s', remoteAddress);
      sock.write('KAP-RX')
    }
  });
  sock.on('close',  function () {
    console.log('connection from %s closed', remoteAddress);
    counter = counter - 1;
    console.log('Connected clients: %i', counter)
  });
  sock.on('error', function (err) {
    console.log('Connection %s error: %s', remoteAddress, err.message);
  });
};
}
}
exports.data = methods;
