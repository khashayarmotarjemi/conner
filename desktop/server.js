const Net = require('net');
const port = 8991;
import { createStore } from 'redux'


// Use net.createServer() in your code. This is just for illustration purpose.
// Create a new TCP server.
const server = new Net.Server();
server.listen(port, function () {
    console.log(`Server listening for connection requests on socket localhost:${port}`);
});

server.on('connection', function (socket) {
    let store = createStore(mapActions)

    var state = 'initial';

    console.log('A new connection has been established.');

    // Now that a TCP connection has been established, the server can send data to
    // the client by writing to its socket.
    socket.write('SEND_PASSPHRASE');

    // The server can also receive data from the client by reading from its socket.
    socket.on('data', function (chunk) {
        let msg = chunk.toString();
        let address = socket.address()['address'];
        // console.log(msg);
        // console.log(address)
        switch(store.state) {
            case States.initial:
                store.dispatch({ type: ActionTypes.initialConnection});
            case States.waitPass:
                store.dispatch({ type: ActionTypes.recievedPass , data: msg});
            case States.accepted:
                console.log("accepted");
        }

        if(store.state == States.waitPass) {
        }

    });

    // When the client requests to end the TCP connection with the server, the server
    // ends the connection.
    socket.on('end', function () {
        console.log('Closing connection with the client');
    });

    // Don't forget to catch error, for your own sake.
    socket.on('error', function (err) {
        console.log(`Error: ${err}`);
    });
});


function mapActions(state = States.initial , action) {
    switch (action.type) {
        case ActionTypes.recievedPass:
            if(action.data == '1234') {
                return States.accepted;
            }
        case ActionTypes.initialConnection:
            // check the info for being on the same network
            return States.waitPass;
        default:
            return state
    }
}

const States = {
    initial: 1,
    waitPass: 2,
    accepted: 3,
 };

 const ActionTypes = {
    recievedPass: 11,
    initialConnection: 22,
    // waitPass: 2,
    // connected: 3,
 };
