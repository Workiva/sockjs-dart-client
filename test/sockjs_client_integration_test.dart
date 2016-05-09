@TestOn('browser')
library sockjs_client.test.sockjs_client_test;

import 'dart:async';

import 'package:sockjs_client/sockjs_client.dart';
import 'package:test/test.dart';

const String echoUri = 'http://localhost:8000/echo';
const String corUri = 'http://localhost:8000/cor';
const String fofUri = 'http://localhost:8600/404';

void main() {
  group('SockJS Client', () {
    group('default', () {
      Client createEchoClient() => new Client(echoUri, noCredentials: true);
      Client createCorClient() => new Client(corUri, noCredentials: true);
      Client create404Client() => new Client(fofUri, noCredentials: true);

      integrationSuite(createEchoClient, createCorClient, create404Client);
    });

    group('web-socket', () {
      Client createEchoClient() => new Client(echoUri, noCredentials: true, protocolsWhitelist: ['websocket']);
      Client createCorClient() => new Client(corUri, noCredentials: true, protocolsWhitelist: ['websocket']);
      Client create404Client() => new Client(fofUri, noCredentials: true, protocolsWhitelist: ['websocket']);

      integrationSuite(createEchoClient, createCorClient, create404Client);
    });

    group('xhr-streaming', () {
      Client createEchoClient() => new Client(echoUri, noCredentials: true, protocolsWhitelist: ['xhr-streaming']);
      Client createCorClient() => new Client(corUri, noCredentials: true, protocolsWhitelist: ['xhr-streaming']);
      Client create404Client() => new Client(fofUri, noCredentials: true, protocolsWhitelist: ['xhr-streaming']);

      integrationSuite(createEchoClient, createCorClient, create404Client);
    });
  });
}

void integrationSuite(Client createEchoClient(), Client createCorClient(), Client create404Client()) {
  test('connecting to a SockJS server', () async {
    Client client = createEchoClient();
    await client.onOpen.first;
  });

  test('sending and receiving messages', () async {
    Client client = createEchoClient();
    await client.onOpen.first;

    Completer c = new Completer();
    var echos = [];
    client.onMessage.listen((MessageEvent message) {
      echos.add(message.data);
      if (echos.length == 2) {
        c.complete();
      }
    });
    client.send('message1');
    client.send('message2');

    await c.future;
    client.close();

    expect(echos, equals(['message1', 'message2']));
  });

  test('client closing the connection', () async {
    Client client = createEchoClient();
    await client.onOpen.first;
    client.close();
    await client.onClose.first;
  });

  test('client closing the connection with code and reason', () async {
    Client client = createEchoClient();
    await client.onOpen.first;
    client.close(4001, 'Custom close.');
    CloseEvent event = await client.onClose.first;
    expect(event.code, equals(4001));
    expect(event.reason, equals('Custom close.'));
  });

  test('server closing the connection', () async {
    Client client = createCorClient();
    await client.onOpen.first;
    client.send('close');
    await client.onClose.first;
  });

  test('server closing the connection with code and reason', () async {
    Client client = createCorClient();
    await client.onOpen.first;
    client.send('close::4001::Custom close.');
    CloseEvent event = await client.onClose.first;
    expect(event.code, equals(4001));
    expect(event.reason, equals('Custom close.'));
  });

  test('handle failed connection', () async {
    Client client = create404Client();
    await client.onClose.first;
  });
}
