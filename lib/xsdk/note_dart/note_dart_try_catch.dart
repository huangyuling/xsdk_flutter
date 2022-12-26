

/*
异常:
try {
}catch (e) {
} finally {
}



1.抛出异常:
if (astronauts == 0) {
  throw StateError('No astronauts.'); 或 throw 'Cannot locate user order';
}


2.捕获异常try..on catch:
try {
  for (final object in flybyObjects) {
    var description = await File('$object.txt').readAsString();
    print(description);
  }
} on IOException catch (e) {
  print('Could not describe object: $e');
} catch (e) {
  // No specified type, handles all
  print('Something really unknown: $e');
} finally {
  flybyObjects.clear();
}


在Dart中，异常分两类：同步异常和异步异常:
1、同步异常：
Dart中同步异常可以通过try/on/catch/finally来捕获代码块异常，可以通过throw 关键字用来明确地抛出异常。
try {

  var s = testList[3];

  //代码逻辑

} on IntegerDivisionByZeroException {

  //使用on关键字，捕获特定类型的异常

} on NoSuchMethodError catch (e) {

  //使用on关键字，捕获特定类型的异常

  //代码段可以有多个 on / catch 块来处理多个异常

} catch (error, stacktrace) {

  // 没有指定类型，处理所有错误

  //catch 最多提供两个可选参数

  //第一个参数 error 类型为 Object，也就是异常是可以抛出任意对象。

  //第二个参数 stacktrace，表示异常堆栈。

  print('Something really unknown error: $error');

  print('Something really unknown stacktrace: $stacktrace');

  throw '抛出异常关键';

  //throw 之后的代码将不会执行

  //throw new FormatException();

} finally {

  // 在throw之前先执行finally代码块
  print("this is finally");

}


2、异步异常
try-catch 代码块不能捕获到异步异常，使用 await 关键字声明的同步调用，属于同步异常范围，可以通过 try-catch 捕获。
使用 catchError 捕获异步异常，第一个参数为 Function error 类型，第二个参数为 {bool test(Object error)}，是一个判断表达式，当此表达式返回值为 true 时，表示需要执行 catch 逻辑，如果返回 false，则不执行 catch 逻辑，即会成为未捕获的异常，默认不传时 认为是true。
这里的作用是可以精细化的处理异常，可以理解为同步异常中强化版的 on 关键字，
入参至多两个 分别为error 和 stack，均可选。

Future(() {

}).then((value){

}).catchError((error, stack) {

});

Future.delayed(Duration(seconds: 1)).then((e) => Future.error("xxx"));



二、Flutter异常捕获、抛出
为了捕获并上报异常，可以把应用运行在一个自定义的 Zone 里面。
Zones 为代码建立执行上下文环境。在这个上下文环境中，所有发生的异常在抛出 onError 时都能够很容易地被捕获到。
Dart中有一个runZoned(...) 方法，可以给执行对象指定一个Zone。
Zone表示一个代码执行的环境范围，为了方便理解，读者可以将Zone类比为一个代码执行沙箱，不同沙箱的之间是隔离的，沙箱可以捕获、拦截或修改一些代码行为，
如Zone中可以捕获日志输出、Timer创建、微任务调度的行为，同时Zone也可以捕获所有未处理的异常。
下面我们看看runZoned(...)方法定义：


在下面的例子中，将会把应用运行在一个新的 Zone 里面并捕获所有错误，
在 1.17 之前的 Flutter 版本里，你可以通过 onError() 回调捕获所有的异常:
runZoned<Future<void>>(() async {
  runApp(MyApp());
}, onError: (error, stackTrace) {
  // Whenever an error occurs, call the `_reportError` function. This sends
  // Dart errors to the dev console or Sentry depending on the environment.
  _reportError(error, stackTrace);
});

在包含了 Dart 2.8 的 Flutter 1.17 中，使用 runZonedGuarded：
runZonedGuarded<Future<void>>(() async {
  runApp(MyApp());
}, (Object error, StackTrace stackTrace) {
  // Whenever an error occurs, call the `_reportError` function. This sends
  // Dart errors to the dev console or Sentry depending on the environment.
  _reportError(error, stackTrace);
});



Dart中的每个异常类型都是内置类 Exception 的子类型。
Dart可以通过扩展现有异常来创建自定义异常。
class AmtException implements Exception {
   String errMsg() => 'Amount should be greater than zero';
}

throw new AmtException();

 */





