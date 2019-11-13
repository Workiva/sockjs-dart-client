part of sockjs_client;

class XhrReceiver extends Receiver {
  AbstractXHRObject xo = null;
  int buf_pos = 0;

  XhrReceiver(url, AjaxObjectFactory xhrFactory, {bool noCredentials}) {
    xo = xhrFactory('POST', url, noCredentials: noCredentials);
    xo.onChunk.listen((e) {
      if (e.status != 200) return;
      readAndBroadcastMessage(e);
    });
    xo.onFinish.listen((e) {
      readAndBroadcastMessage(e);
      xo = null;
      var reason = (e.status == 200) ? 'network' : 'permanent';
      dispatch(new CloseEvent(reason: reason));
    });
  }

  readAndBroadcastMessage(e) {
    while (true) {
      var buf = e.text.substring(buf_pos);
      var p = buf.indexOf('\n');
      if (p == -1) break;
      buf_pos += p + 1;
      var msg = buf.substring(0, p);
      dispatch(new MessageEvent(msg));
    }
  }

  abort() {
    if (xo != null) {
      xo.close();
      dispatch(new CloseEvent(reason: 'user'));
      xo = null;
    }
  }
}

Receiver XhrReceiverFactory(String recvUrl, AjaxObjectFactory xhrFactory,
    {bool noCredentials}) {
  return new XhrReceiver(recvUrl, xhrFactory, noCredentials: noCredentials);
}
