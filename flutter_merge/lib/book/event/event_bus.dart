
typedef void EventCallback(arg);

class EventBus {

  EventBus._internal();

  static EventBus _instance = EventBus._internal();

//  factory EventBus() {
//    return _instance;
//  }
  factory EventBus() => _instance;

  //定义一个top-level变量，页面引入该文件后可以直接使用bus
//  var bus = EventBus();


  // queue
  var _events = Map<Object, List<EventCallback>>();

  void register(eventName, EventCallback cb) {
    if (eventName == null || cb == null) return;
    _events[eventName] ??= List<EventCallback>();
    _events[eventName].add(cb);
  }

  void unregister(eventName, [EventCallback cb]) {
    if (eventName == null) return;
    var list = _events[eventName];
    if (list == null) return;
    if (cb == null) {
      _events[eventName] = null;
    } else {
      list.remove(cb);
    }
  }

  void post(eventName, [arg]) {
    var list = _events[eventName];
    if (list == null) return;
    int lastIndex = list.length - 1;
    // 反向遍历，防止在订阅者在回调中移除自身带来的下标错位
    for (int i = lastIndex; i > -1; --i) {
      list[i](arg);
    }
  }
}