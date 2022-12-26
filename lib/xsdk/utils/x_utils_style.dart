
import 'package:flutter/material.dart';


//工具类使用abstract定义时,写代码时不会提示创建实例选项
abstract class XStyleUtils{

  //按钮样式//////////////////////////////////////////////////
  // static TextStyle buttonStyle_000_18(){
  //   return getTextStyle(
  //       fontSize: 18,
  //       color: const Color(0xFF000000)
  //   );
  // }

  //通用字体样式
  static ButtonStyle getButtonStyle(
      {
        double fontSize=16,//字体大小
        Color fontColor=const Color(0xFF000000),//字体颜色,默认黑色,
        Color backgroundColor=const Color(0xFFffffff),//背景颜色,默认白色,
        Color? overlayColor,//设置高亮色,按钮处于focused, hovered, or pressed时的颜色
        Color? shadowColor,//阴影颜色
        double? shadowElevation,//阴影值,如10
        BorderSide? borderSide,//边框 BorderSide(width: 1,color: Color(0xffffffff))
        /*
        shape形状:
        圆角: StadiumBorder(
              side: BorderSide(
                //设置 界面效果
                style: BorderStyle.solid,
                color: Color(0xffFF7F24),
              )
          )
          圆形:
          CircleBorder(
                    side: BorderSide(
                      //设置 界面效果
                      color: Colors.green,
                      width: 280.0,
                      style: BorderStyle.none,
                    )
                )
         */
        OutlinedBorder? shape,
      }
      ){

    return ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(fontSize: fontSize)),//设置字体大小
      foregroundColor: MaterialStateProperty.all(fontColor),//设置字体颜色
      backgroundColor: MaterialStateProperty.all(backgroundColor),//设置背景颜色
      overlayColor: MaterialStateProperty.all(overlayColor),//设置高亮色，
      shadowColor: MaterialStateProperty.all(shadowColor),//阴影颜色
      elevation: MaterialStateProperty.all(shadowElevation),//阴影值
      side: MaterialStateProperty.all(borderSide),//边框
      shape: MaterialStateProperty.all(shape),//形状
    );
  }



  //字体样式//////////////////////////////////////////////////
  static TextStyle textStyle_000_18(){
    return getTextStyle(
        fontSize: 18,
        color: const Color(0xFF000000)
    );
  }

  static TextStyle textStyle_000_16(){
    return getTextStyle(
        fontSize: 16,
        color: const Color(0xFF000000)
    );
  }
  static TextStyle textStyle_000_14(){
    return getTextStyle(
        fontSize: 14,
        color: const Color(0xFF000000)
    );
  }
  static TextStyle textStyle_000_12(){
    return getTextStyle(
        fontSize: 12,
        color: const Color(0xFF000000)
    );
  }
  static TextStyle textStyle_000_10(){
    return getTextStyle(
        fontSize: 10,
        color: const Color(0xFF000000)
    );
  }
  static TextStyle textStyle_000_8(){
    return getTextStyle(
        fontSize: 8,
        color: const Color(0xFF000000)
    );
  }

  static TextStyle textStyle_333_18(){
    return getTextStyle(
        fontSize: 18,
        color: const Color(0xFF333333)
    );
  }

  static TextStyle textStyle_333_16(){
    return getTextStyle(
        fontSize: 16,
        color: const Color(0xFF333333)
    );
  }
  static TextStyle textStyle_333_14(){
    return getTextStyle(
        fontSize: 14,
        color: const Color(0xFF333333)
    );
  }
  static TextStyle textStyle_333_12(){
    return getTextStyle(
        fontSize: 12,
        color: const Color(0xFF333333)
    );
  }
  static TextStyle textStyle_333_10(){
    return getTextStyle(
        fontSize: 10,
        color: const Color(0xFF333333)
    );
  }
  static TextStyle textStyle_333_8(){
    return getTextStyle(
        fontSize: 8,
        color: const Color(0xFF333333)
    );
  }

  static TextStyle textStyle_666_18(){
    return getTextStyle(
        fontSize: 18,
        color: const Color(0xFF666666)
    );
  }

  static TextStyle textStyle_666_16(){
    return getTextStyle(
        fontSize: 16,
        color: const Color(0xFF666666)
    );
  }
  static TextStyle textStyle_666_14(){
    return getTextStyle(
        fontSize: 14,
        color: const Color(0xFF666666)
    );
  }
  static TextStyle textStyle_666_12(){
    return getTextStyle(
        fontSize: 12,
        color: const Color(0xFF666666)
    );
  }
  static TextStyle textStyle_666_10(){
    return getTextStyle(
        fontSize: 10,
        color: const Color(0xFF666666)
    );
  }
  static TextStyle textStyle_666_8(){
    return getTextStyle(
        fontSize: 8,
        color: const Color(0xFF666666)
    );
  }

  static TextStyle textStyle_999_18(){
    return getTextStyle(
        fontSize: 18,
        color: const Color(0xFF999999)
    );
  }

  static TextStyle textStyle_999_16(){
    return getTextStyle(
        fontSize: 16,
        color: const Color(0xFF999999)
    );
  }
  static TextStyle textStyle_999_14(){
    return getTextStyle(
        fontSize: 14,
        color: const Color(0xFF999999)
    );
  }
  static TextStyle textStyle_999_12(){
    return getTextStyle(
        fontSize: 12,
        color: const Color(0xFF999999)
    );
  }
  static TextStyle textStyle_999_10(){
    return getTextStyle(
        fontSize: 10,
        color: const Color(0xFF999999)
    );
  }
  static TextStyle textStyle_999_8(){
    return getTextStyle(
        fontSize: 8,
        color: const Color(0xFF999999)
    );
  }


  //通用字体样式
  static TextStyle getTextStyle(
      {
        double fontSize=16,//字体大小
        Color color=const Color(0xFF000000),//字体颜色,默认黑色000000
        FontWeight fontWeight=FontWeight.normal,//字体粗细,normal正常, bold加粗, w900最粗, w100最细
        FontStyle fontStyle=FontStyle.normal,//字体样式,normal正常, italic斜体
        TextDecoration decoration=TextDecoration.none, //装饰线 none正常,underline 下划线, overline 上划线, lineThrough 删除线
        TextDecorationStyle decorationStyle=TextDecorationStyle.solid, //装饰线样式, solid实线, double双实线, dotted虚线,dashed点虚线,wavy波浪线
        Color? decorationColor, //装饰线颜色,如const Color(0xFF000000)
      }
      ){
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      //letterSpacing: 1, //字体间的宽度
      //height: 1, //行与行之间的高度
      //locale: const Locale('zh_CN'),
      decoration: decoration,
      decorationStyle:decorationStyle,
      decorationColor: decorationColor,
    );
  }


}
