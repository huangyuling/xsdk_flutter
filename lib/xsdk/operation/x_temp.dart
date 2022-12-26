
/*
全局临时变量
 */

import 'dart:ui';

abstract class XTempData{

  //半屏是否已经有过显示蒙层,后续半屏则透明(避免颜色加深)
  static bool isPageMengcengLeftOpen=false;
  static bool isPageMengcengRightOpen=false;
  static Color pageMengcengColor=const Color(0x33000000);
  static String mengcengLeftOpenPageName="";//打开半透明蒙层的activity
  static String mengcengRightOpenPageName="";//打开半透明蒙层的activity





}