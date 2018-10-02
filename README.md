# SockJS Client

This is a Dart client library for [SockJS](http://sockjs.org).
SockJS gives you a coherent, cross-browser, Javascript API
which creates a low latency, full duplex, cross-domain communication
channel between the browser and the web server.

Under the hood SockJS tries to use native WebSockets first. If that
fails it can use a variety of browser-specific transport protocols and
presents them through WebSocket-like abstractions.

SockJS is intended to work for all modern browsers and in environments
which don't support WebSocket protocol, for example behind restrictive
corporate proxies.

## Development

### Dependencies
```
$ pub get && npm install
```

### Tests
```
Dart 1:
-------

Run unit tests:

    $ pub run test

Run integration tests:

    $ node tool/server.js
    $ pub run test -P integration


Dart 2:
-------

Run unit tests:

    $ pub run build_runner test

Run integration tests:

    $ node tool/server.js
    $ pub run build_runner test -- -P integration
```