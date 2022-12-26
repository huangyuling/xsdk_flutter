import 'dart:async';
import 'package:dio/dio.dart';

import 'dart:convert';
//实现多线程,使用import 'dart:isolate'替代import 'package:flutter/foundation.dart',因为在直接执行dart-run会报错:dart:ui不存在
//import 'package:flutter/foundation.dart';
import 'dart:isolate';


// Must be top-level function
_parseAndDecode(String response) {
  var obj=jsonDecode(response);
  return obj;
}

_parseJson(String text) async {
  //return _parseAndDecode(text);
  //使用Isolate替代compute,避免直接运行dart-run出错
  //return compute(_parseAndDecode, text);
  //进程池管理,未完成...https://cloud.tencent.com/developer/article/1676442
  //return await loadWithBalancer<dynamic, String>(_parseAndDecode, text);
  return await Isolate.spawn(_parseAndDecode, text);
}

// //上面的compute就可以了,不过如果产生大量的isolate,不利于内存,所以:
// Future<LoadBalancer> loadBalancer = LoadBalancer.create(2, IsolateRunner.spawn);
// //这样创建isolate的数量就限制了.
// Future<dynamic> loadWithBalancer<R, T>(Function function, T data) async {
//   final lb = await loadBalancer;
//   return await lb.run<dynamic, T>(function, data);
// }

//转换器,返回内容是json时才会进入使用 (注意:拦截器优先转换器)
//已在dio中定义返回的是字符串,因此不需要使用转换,用不到
class XTransformer extends DefaultTransformer {

  //实测:不在这里转换,改为外部按具体业务转换和处理
  //XTransformer() : super(jsonDecodeCallback: _parseJson);

  @override
  Future<String> transformRequest(RequestOptions options) async {
    // if (options.data is List<String>) {
    //   throw DioError(
    //     error: "Can't send List to sever directly",
    //     requestOptions: options,
    //   );
    // } else {
    //   return super.transformRequest(options);
    // }

    return super.transformRequest(options);
  }

  /// The [Options] doesn't contain the cookie info. we add the cookie
  /// info to [Options.extra], and you can retrieve it in [ResponseInterceptor]
  /// and [Response] with `response.request.extra["cookies"]`.
  @override
  Future transformResponse(
      RequestOptions options,
      ResponseBody response,
      ) async {
    //options.extra['self'] = 'XX';
    return super.transformResponse(options, response);
  }
}

void main() async {
  var dio = Dio();
  // Use custom Transformer
  dio.transformer = XTransformer();

  var response = await dio.get('https://www.baidu.com');
  print(response.requestOptions.extra['self']);

  try {
    await dio.post('https://www.baidu.com', data: ['1', '2']);
  } catch (e) {
    print(e);
  }
}