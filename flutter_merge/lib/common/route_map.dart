

import 'package:flutter/material.dart';
import 'package:flutter_merge/book/event/bus_example.dart';
import 'package:flutter_merge/book/gesture/gesture_drag.dart';
import 'package:flutter_merge/book/gesture/gesture_scale.dart';
import 'package:flutter_merge/book/notification/notification.dart';
import 'package:flutter_merge/book/pointer/listener_widget.dart';
import 'package:flutter_merge/tqx_main.dart';

class RouteManager {

  static const TQX_MAIN_PAGE = 'tqx_main';
  static const POINTER_EVENT = 'point_event';
  static const DRAG_GESTURE = 'drag';
  static const SCALE_GESTURE = 'scale';
  static const EVENT_BUS_EXAMPLE = 'event_bus';
  static const NOTIFICATION = 'notification';

  static Map<String, WidgetBuilder> _map = {
    TQX_MAIN_PAGE: _build(TQXScaffold()),
    POINTER_EVENT: _build(ListenerWidget()),
    DRAG_GESTURE: _build(DragGesture()),
    SCALE_GESTURE: _build(ScaleGesture()),
    EVENT_BUS_EXAMPLE: _build(EventRegisterPage()),
    NOTIFICATION: _build(NotificationPage()),
  };

  static List<String> _list;

  static Map<String, WidgetBuilder> register() {
    _list = _map.keys.toList();
    return _map;
  }

  static String routePageName(int index) {
    if (index < 0 || index >= _list.length) return null;
    return _list[index];
  }

  static WidgetBuilder _build(Widget widget) {
    return (ctx) => widget;
  }
}