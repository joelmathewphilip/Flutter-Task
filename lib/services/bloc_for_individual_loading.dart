import 'dart:async';

import 'package:flutter_task/services/favourite_event_individual.dart';

class Loading_Bloc_2
{
  bool _present = false;
  final _presentStateController = StreamController<bool>.broadcast();
  StreamSink<bool> get _inController
  {
    return _presentStateController.sink;
  }

  Stream<bool> get present {
    return _presentStateController.stream;
  }


  final _presentEventController = StreamController<Present>();

  Sink<Present> get presentEventSink {
    return _presentEventController.sink;
  }

  Loading_Bloc()
  {
    _presentEventController.stream.listen((Present event) {
      _mapEventToState(event);
    });
  }

  void _mapEventToState(Present event)
  {
    if(event is isPresent)
    {
      _present = true;
    }
    else
    {
      _present = false;
    }
    _presentStateController.add(_present);
  }

  void dispose()
  {
    _presentStateController.close();
    _presentEventController.close();
  }
}