// library tool.dev;

// import 'dart:async';
// import 'package:dart_dev/dart_dev.dart' show dev, config;
// import 'package:dart_dev/util.dart' show TaskProcess, reporter;

// main(List<String> args) async {
//   // https://github.com/Workiva/dart_dev

//   config.analyze
//     ..entryPoints = ['example/', 'lib/', 'tool/']
//     ..strong = true;
//   config.format.paths = ['example/', 'lib/', 'tool/'];

//   config.coverage
//     ..before = [_startServer]
//     ..after = [_stopServer];
//   config.test
//     ..before = [_startServer]
//     ..after = [_stopServer]
//     ..unitTests = ['test/xhr_streaming_test.dart']
//     ..integrationTests = ['test/sockjs_client_integration_test.dart']
//     ..platforms = ['chrome'];

//   await dev(args);
// }

// /// Server needed for integration tests and examples.
// TaskProcess _server;

// /// Output from the server (only used if caching the output to dump at the end).
// List<String> _serverOutput;

// /// Start the server needed for integration tests and cache the server output
// /// until the task requiring the server has finished. Then, the server output
// /// will be dumped all at once.
// Future _startServer() async {
//   _serverOutput = [];
//   _server = new TaskProcess('node', ['tool/server.js']);
//   _server.stdout.listen(_serverOutput.add);
//   _server.stderr.listen(_serverOutput.add);
//   // todo: wait for server to start
// }

// /// Stop the server needed for integration tests.
// Future _stopServer() async {
//   if (_serverOutput != null) {
//     reporter.logGroup('HTTP Server Logs',
//         output: '    ${_serverOutput.join('\n')}');
//   }
//   if (_server != null) {
//     try {
//       _server.kill();
//     } catch (e) {}
//   }
// }
