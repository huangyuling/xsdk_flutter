import 'package:dio/dio.dart';
import 'interceptor/XHttpIntercepter.dart';
import 'transformer/XTransformer.dart';


//成功响应
typedef void XHttpCallback_success(String result,Map<String,dynamic> headers_response);//headers_response: Map<String, List<String>>
//失败响应
typedef void XHttpCallback_fail(String code,String msg);

//dart抽象类是无法直接实例化
// abstract class XHttpCallback<T>{
//   void success(T,Map<String,dynamic>headers);
//   void fail(int code,String msg);
// }

/*
https://github.com/flutterchina/dio/



注意:编译成web应用时,浏览器有跨域问题,一般我们写一个网页的时候，网络请求可以通过后台服务器转发，由服务器解除跨域限制即可;

注意:
引用import 'package:flutter/foundation.dart';时,直接运行dart,则会报错,

 */

abstract class XHttpUtils{

  static Dio dio = new Dio();
  static CancelToken _cancelToken = new CancelToken();

  //请求头
  static Map<String,dynamic>? getRequestHeaders(){
    return null;
  }

  /*
  1.初始化,在app中
   */
  static void init(){
    // 设置超时时间等 ...
    dio.options = BaseOptions(
        receiveTimeout: 60*1000,
        connectTimeout: 60*1000,
        headers: getRequestHeaders()
    );
    // 添加拦截器，如 token之类，需要全局使用的参数
    dio.interceptors.add(XHttpInterceptor());
    /*
    Transformer允许在向服务器发送/接收之前更改请求/响应数据。仅适用于请求方法“PUT”、“POST”和“PATCH”。
    Dio 已经实现了DefaultTransformer作为默认Transformer。
    如果您想自定义请求/响应数据的转换，您可以自己提供一个，并通过设置Transformer替换.DefaultTransformerdio.transformer
    如果你在 Flutter 开发中使用 dio，你最好使用 [compute] 函数在后台解码 json。
    //多线程json解析jsonDecodeCallback,已在自定义Transformer中设置
    //(dio.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
     */
    //dio.transformer = XTransformer();

    //直接返回json字符串,不需要转换
    //dio.options.responseType=ResponseType.json;
    dio.options.responseType=ResponseType.plain;

  }

  //异步请求///////////////////////////////////

  //2.post请求
  static post_async(
      String? requestType,//'get' 'post'
      String url,
      String? dataJson

      ) async
  {


  }


  /*
  XHttpUtils.base_request_async(
    'get',
      'https://www.baidu.com',
          null,
          (json,headers){
            print(json);
          },
          (code,msg){
            print(code);
            print(msg);
          });

  XHttpUtils.base_request_async(
      'post',
      'http://ht.reabam.com:50006/api/core/app/Business/NeedOrder/List',
      null,
          (json,headers){
        print('---response-headers= '+headers.toString());
        print('---json= '+json.toString());
      },
          (code,msg){
        print(code);
        print(msg);
      });
   */

  // 支持get/post请求
  static void base_request_async(
      String? requestType,//'get' 'post'
      String url,
      String? dataJson,
      XHttpCallback_success success,
      XHttpCallback_fail fail
      ) async
  {
    try {

      Response? response;
      if('GET'==requestType?.toUpperCase()){
        //get请求
        response= await dio.get(url,cancelToken: _cancelToken);
      }else{
        //post请求
        //response=await dio.post(url,data:json).catchError(onError);//等同于try catch
        response=await dio.post(url,data:dataJson,cancelToken: _cancelToken);
      }

      if(200==response.statusCode){
        String result=response.data.toString();
        Headers headers=response.headers;
        success(result,headers.map);
      }else{
        fail('${response.statusCode??-1}',response.statusMessage??'');
      }

    } on DioError catch (e) {
      fail('${e.response?.statusCode ?? -1}', '$e');
    } catch (e) {
      fail('${-2}','$e');
    }

  }


//发起多个并发请求:
// response= await Future.wait([dio.post("/info"),dio.get("/token")]);


//下载文件
//   xHttpDownload(String url,String savePath) async{
//     Response response=await xDio.download(url,savePath);
//   }


/*
通过FormData上传多个文件:
main() async {
  var dio = new Dio();
  dio.options.baseUrl = "http://www.dtworkroom.com/doris/1/2.0.0/";

  FormData formData = new FormData.from({
    "name": "wendux",
    "age": 25,
    "file": new UploadFileInfo(new File("./example/upload.txt"), "upload.txt"),
    // In PHP the key must endwith "[]", ("files[]")
    "files": [
      new UploadFileInfo(new File("./example/upload.txt"), "upload.txt"),
      new UploadFileInfo(new File("./example/upload.txt"), "upload.txt")
    ]
  });
  Response response = await dio.post("/token", data: formData);
  print(response.data);
}






 */


//自带底层请求框架/////////////////////////////////////////////////////
/*

void main() async {
  String pageHtml = await HttpRequest.getString(url);
  // Do something with pageHtml...
}

  void main() async {
  HttpRequest req = await HttpRequest.request(
    url,
    method: 'HEAD',
  );
  if (req.status == 200) {
    // Successful URL access...
  }
  // ···
  }


var request = HttpRequest();
request
  ..open('POST', url)
  ..onLoadEnd.listen((e) => requestComplete(request))
  ..send(encodedData);



  String encodeMap(Map<String, String> data) => data.entries
    .map((e) =>
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
    .join('&');

void main() async {
  const data = {'dart': 'fun', 'angular': 'productive'};

  var request = HttpRequest();
  request
    ..open('POST', url)
    ..setRequestHeader(
      'Content-type',
      'application/x-www-form-urlencoded',
    )
    ..send(encodeMap(data));

  await request.onLoadEnd.first;

  if (request.status == 200) {
    // Successful URL access...
  }
  // ···
}


 */

}
