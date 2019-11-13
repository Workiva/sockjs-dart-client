library events;

import "dart:async";

class Event {
  String type;
  Event(this.type);
}

class Emitter {
  final _evtController = StreamController<Event>.broadcast();

  Stream<Event> operator [](type) =>
      _evtController.stream.where((e) => e.type == type);

  Stream<T> getEventStream<T extends Event>(String type) {
    return _evtController.stream
        .where((e) => e.type == type)
        .map((e) => e as T);
  }

  dispatch(evtOrType) {
    var evt = (evtOrType is String) ? Event(evtOrType) : evtOrType;
    _evtController.add(evt);
  }
}
