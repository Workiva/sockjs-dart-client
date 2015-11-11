var http = require('http');
var sockjs = require('sockjs');

var sockjsUrl = '//cdn.jsdelivr.net/sockjs/1.0.3/sockjs.min.js';

var echo = sockjs.createServer({
    sockjs_url: sockjsUrl
});
echo.on('connection', function(conn) {
    conn.on('data', function(message) {
        console.log('[echo] "' + message + '"');
        conn.write(message);
    });
    conn.on('close', function() {
        console.log('[echo] closed.');
    });
});

var closeOnRequest = sockjs.createServer({
    sockjs_url: sockjsUrl
});
closeOnRequest.on('connection', function(conn) {
    conn.on('data', function(message) {
        if (message.substr(0, 'close'.length) === 'close') {
            var parts = message.split('::');
            var code;
            var reason;
            if (parts.length >= 2) {
                code = parseInt(parts[1], 10);
            }
            if (parts.length >= 3) {
                reason = parts[2];
            }
            console.log('[cor] close request received');
            conn.close(code, reason);
        }
    });
    conn.on('close', function() {
        console.log('[cor] closed.');
    });

});

var server = http.createServer();
echo.installHandlers(server, {prefix: '/echo'});
closeOnRequest.installHandlers(server, {prefix: '/cor'});
server.listen(8000, 'localhost');