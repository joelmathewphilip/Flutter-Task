import 'dart:async';

import 'package:flutter_task/services/loading_event.dart';

class Loading_Bloc
{
  bool _loading = false;
  final _loadingStateController = StreamController<bool>.broadcast();
   StreamSink<bool> get _inController
   {
     return _loadingStateController.sink;
   }

   Stream<bool> get loading {
    return _loadingStateController.stream;
   }


   final _loadingEventController = StreamController<LoadingEvent>();

   Sink<LoadingEvent> get loadingEventSink {
     return _loadingEventController.sink;
   }

   Loading_Bloc()
   {
    _loadingEventController.stream.listen((LoadingEvent event) {
    _mapEventToState(event);
    });
   }

   void _mapEventToState(LoadingEvent event)
   {
      if(event is isLoading)
        {
          _loading = true;
        }
      else
        {
          _loading = false;
        }
      _loadingStateController.add(_loading);
   }

void dispose()
{
  _loadingStateController.close();
  _loadingEventController.close();
}
}