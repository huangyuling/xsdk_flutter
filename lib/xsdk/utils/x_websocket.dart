
/*
WebSocket:
依赖:
dependencies:
  web_socket_channel: ^2.2.0
引入:
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  final channel = IOWebSocketChannel.connect('ws://localhost:1234');

  channel.stream.listen((message) {
    channel.sink.add('received!');
    channel.sink.close(status.goingAway);
  });
}

 */
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef void XWebSocketCallback<T>(T result);

class XWebSocket{

  /*
  /////////////////////////////////////////

var ws = WebSocket('ws://echo.websocket.org');
ws.send('Hello from Dart!');
ws.onMessage.listen((MessageEvent e) {
  print('Received message: ${e.data}');
});

void initWebSocket([int retrySeconds = 1]) {
  var reconnectScheduled = false;

  print('Connecting to websocket');

  void scheduleReconnect() {
    if (!reconnectScheduled) {
      Timer(Duration(seconds: retrySeconds),
          () => initWebSocket(retrySeconds * 2));
    }
    reconnectScheduled = true;
  }

  ws.onOpen.listen((e) {
    print('Connected');
    ws.send('Hello from Dart!');
  });

  ws.onClose.listen((e) {
    print('Websocket closed, retrying in $retrySeconds seconds');
    scheduleReconnect();
  });

  ws.onError.listen((e) {
    print('Error connecting to ws');
    scheduleReconnect();
  });

  ws.onMessage.listen((MessageEvent e) {
    print('Received message: ${e.data}');
  });
}
   */

  String url;
  IOWebSocketChannel? channel;

  XWebSocket(this.url);


  //1.连接服务器
  connect() async{
    channel = await IOWebSocketChannel.connect(url);
  }


  //2.接收数据,不间断
  receiveMsg(XWebSocketCallback callback){
    channel?.stream.listen((message) {
      callback(message);
    });
  }


  //3.发送数据
  sendMsg(String msg) async{
    channel?.sink.add(msg);
  }


  //4.关闭连接
  void close() async{
    channel?.sink.close();
  }

}
