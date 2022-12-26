import 'dart:convert';

abstract class XStringUtils{

  static bool isEmpty(String? str){
    return str==null || str.trim().length==0;
  }

  //比较字符串(不区分大小写)
  static bool equalsIgnoreCase(String? a,String? b){
    return a?.toLowerCase() == b?.toLowerCase();
  }

  //string to bytes
  static List<int> string2Byte(String str){
    var list = utf8.encode(str);
    return list;
  }

  //bytes to string
  static String byte2String(List<int> bytes){
    var str = utf8.decode(bytes);
    return str;
  }





}


