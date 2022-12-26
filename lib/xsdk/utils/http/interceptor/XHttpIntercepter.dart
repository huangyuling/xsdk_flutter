
/*
dio网络请求框架拦截器
 */
import 'package:dio/dio.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_log.dart';

/*
https://blog.csdn.net/fyq520521/article/details/119382876

排队拦截器
Interceptor可以并发执行，即所有请求一次进入拦截器，而不是顺序执行。但是，在某些情况下，我们希望请求按顺序进入拦截器。
方法1:在Interceptor拦截器中加锁;
方法2:使用QueuedInterceptor,它提供一种顺序访问（一个接一个）拦截器的机制。
如:出于安全考虑，我们需要在所有请求的header中设置一个csrfToken，如果csrfToken不存在，我们需要先请求一个csrfToken，
然后再进行网络请求，因为请求csrfToken进度是异步的，所以我们需要在请求拦截器中执行此异步请求;
创建2个不同的Dio实例:
var dio = Dio();
var tokenDio = Dio();
dio.interceptors.add(QueuedInterceptorsWrapper(
    onRequest: (options, handler) {
      print('send request：path:${options.path}，baseURL:${options.baseUrl}');
      if (csrfToken == null) {
        print('no token，request token firstly...');
        tokenDio.get('/token').then((d) {
          options.headers['csrfToken'] = csrfToken = d.data['data']['token'];
          print('request token succeed, value: ' + d.data['data']['token']);
          print(
              'continue to perform request：path:${options.path}，baseURL:${options.path}');
          handler.next(options);
        }).catchError((error, stackTrace) {
          handler.reject(error, true);
        });
      } else {
        options.headers['csrfToken'] = csrfToken;
        return handler.next(options);
      }
    },
   );
 */

//(注意:拦截器优先转换器)
// class XHttpInterceptor extends Interceptor {
class XHttpInterceptor extends QueuedInterceptorsWrapper {

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async
  {

    XLogUtils.printLog('REQUEST[${options.method}],PATH: ${options.path}');

    Map<String, dynamic> headers = options.headers;
    //headers['sign'] = sign; //参数加密签名
    // headers['group_id'] = 'abcds';
    options.headers = headers;

    //print(options.headers);
    //
    super.onRequest(options, handler);
  }


  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    //ok拦截器最终修改的请求头:
    XLogUtils.printLog('request-headers: ${response.requestOptions.headers}');
    super.onResponse(response, handler);
  }

  /*
  dio.interceptors.add(InterceptorsWrapper(
    onRequest:(options, handler){
     // Do something before request is sent
     print('REQUEST[${options.method}],PATH: ${options.path}');
     return handler.next(options); //continue
     // If you want to resolve the request with some custom data，
     // you can resolve a `Response` object eg: `handler.resolve(response)`.
     // If you want to reject the request with a error message,
     // you can reject a `DioError` object eg: `handler.reject(dioError)`
    },
    onResponse:(response,handler) {
     // Do something with response data
     print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
     return handler.next(response); // continue
     // If you want to reject the request with a error message,
     // you can reject a `DioError` object eg: `handler.reject(dioError)`
    },
    onError: (DioError e, handler) {
     // Do something with response error
     print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
     return  handler.next(e);//continue
     // If you want to resolve the request with some custom data，
     // you can resolve a `Response` object eg: `handler.resolve(response)`.
    }
));

在所有拦截器中，您都可以干扰它们的执行流程。
如果你想用一些自定义数据来解决请求/响应，你可以调用handler.resolve(Response).
如果您想拒绝带有错误消息的请求/响应，您可以调用handler.reject(dioError).
   */

}