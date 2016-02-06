// Load modules

const Path = require('path');
const Hapi = require('hapi');
const Inert = require('inert');


// Declare internals

const internals = {};


internals.main = function () {

    const server = new Hapi.Server();

    const connectionOptions = {
        port: 8080,
        routes: {
            files: {
                relativeTo: Path.join(__dirname, '../public')
            }
        }
    };

    server.connection(connectionOptions);

    server.register(Inert, (err) => {

        if (err) {
            throw err;
        }

        const route = {
            method: 'GET',
            path: '/{param*}',
            handler: {
                directory: {
                    path: '.',
                    redirectToSlash: true,
                    index: true
                }
            }
        };
        server.route(route);

        server.start((err) => {

            if (err) {
                throw err;
            }

            console.log('Server is up, neat deal.');
        })
    });
};


internals.main();
