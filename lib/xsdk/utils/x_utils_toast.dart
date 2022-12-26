
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xsdk_flutter_package/xsdk/framework/bean/x_enum.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_flutter.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_log.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_style.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_widget.dart';

abstract class XToastUtils{

  //底部显示SnackBar toast
  static void toastBySnackBar(BuildContext context,String msg){

    /*
    final snackBar = SnackBar(
content: Text(‘Yay! A SnackBar!’),
action: SnackBarAction(
label: ‘Undo’,
onPressed: () {
// 我们只需要在此处处理用户需要撤销的操作就行了。
},),
);
     */
    final snackBar = SnackBar(content: Text(msg));
    // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  /*
  使用Overlay实现toast(已可以用来实现loading)
   */
  static void toast(
      {
        required BuildContext context,
        required String msg,
        ToastPosition position=ToastPosition.center,
        int milliseconds=2000,
      }
      ){

    try {

      //替换新的toast内容
      if(_overlayEntry!=null){
        _closeToast();
      }

      MainAxisAlignment columnAxisAlignment=MainAxisAlignment.center;

      if(position==ToastPosition.top){
        columnAxisAlignment=MainAxisAlignment.start;
      }else if(position==ToastPosition.center){
        columnAxisAlignment=MainAxisAlignment.center;
      }else if(position==ToastPosition.bottom){
        columnAxisAlignment=MainAxisAlignment.end;
      }

      _overlayEntry = OverlayEntry(
        builder: (_) {
          return IgnorePointer(
            child: XWidgetUtils.getLayoutColumn(
                mainAxisAlignment:columnAxisAlignment,
                children: [
                  XWidgetUtils.getLayoutCenter(
                      XWidgetUtils.getLayoutCard(
                          child: XWidgetUtils.getLayoutPadding(
                              padding:XWidgetUtils.getEdgeInsets(10,10,10,10),
                              child:XWidgetUtils.getWidgetText(msg,style: XStyleUtils.textStyle_333_14())),
                          backgroundColor: const Color(0xFFEFEFEF),
                          shadowColor: const Color(0xff999999),
                          elevation: 2,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)),
                          )
                      )
                  )
                ]),
          );
        },
      );
      Overlay.of(context)?.insert(_overlayEntry!);

      //两秒后，移除Toast(注意:使用Future.delayed则计时不能重置)
      //Future.delayed(Duration(milliseconds: milliseconds),()=>_overlayEntry.remove());
      __startTimer(milliseconds:milliseconds);
    }catch (e) {
      XLogUtils.printLog(e.toString());
    }

  }

  //私有方法///////////////////////////////////////////
  static Timer? _timer;
  static OverlayEntry? _overlayEntry;

  // 移除Toast
  static void _closeToast(){
    _cancelTimer();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // 开启倒计时
  static void __startTimer({int milliseconds = 2000}) {
    if(milliseconds<=0){
      milliseconds=2000;
    }
    //
    if(_timer != null){
      _cancelTimer();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), (){
      _closeToast();
    });
  }

  // 取消倒计时
  static void _cancelTimer(){
    _timer?.cancel();
    _timer = null;
  }



}
