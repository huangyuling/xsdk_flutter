import 'dart:convert';

/*
轻量级存储: https://pub.dev/packages/shared_preferences
依赖:
dependencies:
  shared_preferences: ^2.0.15
引入:
import 'package:shared_preferences/shared_preferences.dart';

 */

import 'package:shared_preferences/shared_preferences.dart';

abstract class XSharePreferencesUtils{

  static SharedPreferences? sharedPreferences;

  //1.在application中初始化
  static void init() async{
    //等同:
    // if(sharedPreferences==null){
    //   sharedPreferences = await SharedPreferences.getInstance();
    // }
    sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static void saveString(String key,String value){
    sharedPreferences?.setString(key, value);
  }
  static void saveDouble(String key,double value){
    sharedPreferences?.setDouble(key, value);
  }
  static void saveBool(String key,bool value){
    sharedPreferences?.setBool(key, value);
  }

  static bool getBool(String key){
    return sharedPreferences?.getBool(key)??false;
  }
  static double getDouble(String key){
    return sharedPreferences?.getDouble(key)??0;
  }
  static String getString(String key){
    return sharedPreferences?.getString(key)??'';
  }


}
