const redux = require('redux');
const shell = require('shelljs');
const Net = require('net');
const port = 8991;
let passphrase = '1234';

const server = Net.createServer().listen(port, function () {
    console.log(`Server listening for connection requests on socket localhost:${port}`);
});


server.on('connection', function (socket) {
    let store = redux.createStore(mapActions);

    // store.subscribe(() => console.log(store.getState()))

    console.log('new connection');

    socket.on('data', function (chunk) {
        let msg = chunk.toString().trim();
        let address = socket.address()['address'];

        console.log(msg);
        console.log('state: ' + store.getState())

        switch (store.getState()) {
            case States.initial:
                console.log('here1')
                store.dispatch({ type: ActionTypes.initialConnection });
                break;
            case States.waitPass:
                console.log(`recieved passphrase ${msg}`)
                store.dispatch({ type: ActionTypes.recievedPass, data: msg });
                break;
            case States.connected:
                switch(msg) {
                    case 'VOL_UP':
                        shell.exec('amixer -q sset Master 8%+');
                        break;
                    case 'VOL_DOWN':
                        shell.exec('amixer -q sset Master 8%-');
                        break;
                }
                console.log("accepted");
                break;
        }    
    });

    socket.on('end', function () {
        console.log('Closing connection with the client');
    });

    socket.on('error', function (err) {
        console.log(`Error: ${err}`);
    });
});


function mapActions(state = States.initial, action) {
    switch (action.type) {
        case ActionTypes.recievedPass:
            if (action.data == passphrase) {
                console.log("connected");
                return States.connected;
            }
            break;
        case ActionTypes.initialConnection:
            return States.waitPass;
        default:
            return state;
    }
}

const States = {
    initial: 1,
    waitPass: 2,
    connected: 3,
};

const ActionTypes = {
    recievedPass: 11,
    initialConnection: 22,
};
