
/*
Dart异步编程

dart是单线程,多进程,是基于事件循环的异步编程,内置2个队列:

开始
-> 执行main()
->                                     <-------------------------------------------------------------------\
-> MicroTask队列 -> 判断MicroTask队列不为空时(开启异步线程,不阻塞外部方法往下执行),循环遍历处理1条MicroTask队列微任务; -\  (注意:优先处理完该队列所有任务,即处理完1条后继续遍历直至该队列所有微任务处理完毕后,再往下处理Event队列的事件队列任务)
-> (当MicroTask队列为空时)Event队列 -> 判断Event队列不为空时(开启异步线程,不阻塞外部方法往下执行,取出1条Event队列处理; -\  (注意:处理完1条则跳出Event队列循环,再次返回MicroTask队列前检查判断MicroTask队列是否有任务,有则优先处理MicroTask队列的微任务)
-> (当MicroTask队列和Event队列为空)结束

注意:
1.将异步任务添加到MicroTask队列可以尽快被执行,但需要注意:当循环处理MicroTask队列时,Event队列会被阻塞,导致应用程序无法处理鼠标点击,I/O消息等事件;
2.MicroTask队列按先进先出的顺序同步执行,则添加到MicroTask队列的微任务执行是按顺序同步执行的,任务之间会阻塞,队列内的任务并不是并发或异步执行, 当存在1个耗时微任务时则会阻塞以后的微任务执行;
3.Event队列也是按顺序执行的
4.Future属于Event, 很多flutter组件都属于Event,例如:Http请求...


任务调度:
void myTask1(){...}
1.把任务添加MicroTask队列: Future.microtask(myTask1); 或 scheduleMicrotask(myTask1);
2.把任务添加Event队列:     Future(myTask1);

Future延时任务: Future.delayed(Duration(seconds: 1),(){...}); 注意:这种延时方式不准确,万一在MicroTask队列中有耗时任务,则实际会推迟;
Future同步: Future.sync(); 会被立即执行(同外部的同步方法一样)
Future获得回调: 使用.then(), 可以多个then,按then的顺序响应
Future处理异常: 通常在then后添加.catchError((e){...})

Future使用静态方法wait()等待多个Event任务全部完成后再回调:
Future f1=Future(task1);
Future f2=Future(task2);
Future f3=Future(task3);
//注意:这里不阻塞
Future.wait([f1,f2,f3]).then((_){//上面f1,f2,f3所有事件都执行完成后,回调!});

Future使用async和await(阻塞等待):
注意:
1.要在方法后使用async定义,内部才能使用await阻塞等待;
2.使用async修饰的方法,其返回值是Future;
3.async异步并不是并行执行(并非多线程),依然遵守Dart异步的事件队列规则;

Future<void> do() async{
  print('---1');
  await Future.delayed(Duration(seconds: 1)).then(...);
  print('---2');
}



 */



Future<String> fetchUserOrder() {
  //开启子线程,延迟2秒执行
  return Future.delayed(const Duration(seconds: 2), () => 'hello w');
}

void main() async{
  var a= await fetchUserOrder();
  print(a);
  print('Fetching user order...');
}