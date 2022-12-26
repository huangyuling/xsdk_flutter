/*
Dart是一门单线程的语言，我们可以将一些需要等待的任务放到异步操作中，
但是异步操作并没有开辟一条子线程，而是在线程空闲时去执行异步操作。
而Isolate和compute(对Isolate的封装,内部包含dart:ui等)
Isolate不是严格意义上的多线程,实际上，Isolate更像是进程而不是线程，因为他拥有独立的内存空间，并且他与子线程之间的通信需要借助到端口（Port）概念的api，这些特性让它看起来更像是进程

如果我们需要将Isolate的结果返回，我们需要使用端口ReceivePort来进行传递。
我们将ReceivePort作为参数传递给Isolate，Isolate执行完成后通过Port的send方法将结果传递出来，外部通过listen得到结果。
void isolateTest() async {
  print("外部代码 1");
  ReceivePort port = ReceivePort();
  Isolate iso = await Isolate.spawn(isoFunc, port.sendPort);
  port.listen((message) {
    _data = message;
    print("data is $_data");
    port.close();
    iso.kill();
  });
  print("外部代码 2");

}
void isoFunc(SendPort port) {
  sleep(Duration(seconds: 2));
  port.send("msg");
}



compute(对Isolate的封装),compute的使用要比Isolate方便很多:
void computeTest() async {
  print("外部代码 1");
  compute(computeFunc, "msg").then((value) => print("value = $value"));
  print("外部代码 2");
}
String computeFunc(String message) {
  print("computeFunc ${message}");
  return message + "compute";
}




实现多线程:使用import 'dart:isolate'替代import 'package:flutter/foundation.dart',避免直接运行dart-run报错:dart:ui不存在

//Isolate
void isolateTest() async {
    print("外部代码 1");
    Isolate.spawn(isoFunc0, "msg");
    print("外部代码 2");
  }
  void isoFunc0(String message) {
    // 模拟耗时操作
    sleep(Duration(seconds: 2));
    print("message is $message");
  }

  //compute
  static _parseAndDecode(String response) {
    return jsonDecode(response);
  }
  static _parseJson(String text) {
    //使用Isolate替代compute,避免直接运行dart-run出错
    return compute(_parseAndDecode, text);
  }


进程池:  https://cloud.tencent.com/developer/article/1676442
 */

import 'dart:isolate';

abstract class XThreadUtils{








}
