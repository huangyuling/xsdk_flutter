
//注意:引入import 'package:flutter/foundation.dart';会导致直接运行dart报错,提示无法获得ui库那个问题

abstract class XLogUtils{

  //直接调用打印log
  static void printLog(String str) {
    // if (kDebugMode) {
    //   print('debug: $x');
    // }
    //debugPrint('xsdk: $str');
    print('xsdk: $str');
  }


}
