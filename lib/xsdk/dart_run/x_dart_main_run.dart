


import 'package:xsdk_flutter_package/xsdk/framework/bean/x_bean_group_list_item.dart';
import '../utils/http/x_utils_http.dart';



void testHttp(){

  XHttpUtils.init();
  // XHttpUtils.base_request_async(
  //   'get',
  //     'https://www.baidu.com',
  //         null,
  //         (json,headers){
  //           print(json);
  //         },
  //         (code,msg){
  //           print(code);
  //           print(msg);
  //         });

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

}


void main() async{



  XBeanExpansionItem item = XBeanExpansionItem();
  item.groupItem='a1';


  List<dynamic> list=[];
  list.add(item);


  //List<XBeanExpansionItem> ll=list as List<XBeanExpansionItem>;

  print((list[0] as XBeanExpansionItem).groupItem);



}


