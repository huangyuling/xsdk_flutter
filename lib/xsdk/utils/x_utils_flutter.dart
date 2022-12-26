
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xsdk_flutter_package/xsdk/framework/callback/x_function.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_log.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_string.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_style.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_widget.dart';

import '../framework/bean/x_enum.dart';

//界面携带数据返回上一界面的处理回调接收方法
typedef void XPageCallback<T>(T result);


abstract class XFlutterUtils{

  //注意:不能在XDKApp中赋值初始化context,因为App的的context不含Navigator,否则使用时会报错:Navigator operation requested with a context that does not include a Navigator
  //static late BuildContext context;

  // XFlutterUtils._(); // 把构造方法私有化
  // static XFlutterUtils? _instance;
  // // 通过 getInstance 获取实例
  // static XFlutterUtils? getInstance() {
  //   _instance ??= XFlutterUtils._();
  //   return _instance;
  // }

  //获得当前应用对应的硬件系统名称
  static String getSystemName() {
    //注意:实测编译成web应用时报错,Unsupported operation: Platform._operatingSystem
    String systemName='Other';
    try{
      if (Platform.isAndroid) {
        systemName = 'Android'; //系统名称
      } else if (Platform.isIOS) {
        systemName = 'iOS'; //系统名称
      }else if (Platform.isFuchsia) {
        systemName = 'Fuchsia'; //系统名称
      }else if (Platform.isWindows) {
        systemName = 'Windows'; //系统名称
      } else if (Platform.isLinux) {
        systemName = 'Linux'; //系统名称
      }else if (Platform.isMacOS) {
        systemName = 'MacOS'; //系统名称
      }
    }catch (e) {
      systemName = 'Web'; //系统名称
    }
    return systemName;
  }

  // 判断是否是暗黑模式
  static bool isDarkMode() {
    bool isDarkMode;
    const ThemeMode themeMode = ThemeMode.system;
    if (themeMode == ThemeMode.light || themeMode == ThemeMode.dark) {
      isDarkMode = themeMode == ThemeMode.dark;
    } else {
      isDarkMode = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    }
    return isDarkMode;
  }

  /*
  获得当前Theme的primaryColor
 */
  static Color getPrimaryColorOfTheme(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  /*
  获得屏幕宽度
   */
  static double getScreen(BuildContext context,{bool isScreenWidth=true}){
    if(isScreenWidth){
      return MediaQuery.of(context).size.width;
    }else{
      return MediaQuery.of(context).size.height;
    }
  }

  //延迟执行
  static void delay(
      {
        required int milliseconds,
        required FutureOr Function() functionDo,
      }
      ){
    Future.delayed(Duration(milliseconds: milliseconds),functionDo);
  }

  //跳转页面////////////////////////////////////////////////////////////////////////////

/*
跳转页面,适用:动态路由
需要等待返回数据进一步处理:
startPage(context, XPage(XPageState(xData:'kkkkk')),(result){
    });

//MaterialPageRoute不支持背景色透明
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => page,
//     //跳转的页面设置 name（路由名字）才会允许别的页面指定返回到此页面
//     settings: RouteSettings(name: page.toStringShort()),//XLogUtils.printLog(page.toStringShort());
//   ),
// );


//Navigator.of(context).restorablePush((context, arguments) => null) 用于静态路由?能否用于动态路由?
//Navigator.removeRoute(context, route)

/*
      静态路由(界面跳转: Navigator.restorablePushNamed(context, SettingsView.routeName);)
       */
      // onGenerateRoute: (RouteSettings routeSettings) {
      //   return MaterialPageRoute<void>(
      //     settings: routeSettings,
      //     builder: (BuildContext context) {
      //       switch (routeSettings.name) {
      //         case SettingsView.routeName:
      //           return SettingsView(controller: settingsController);
      //         case SampleItemDetailsView.routeName:
      //           return const SampleItemDetailsView();
      //         case SampleItemListView.routeName:
      //         default:
      //           return const SampleItemListView();
      //       }
      //     },
      //   );
      // },

 */

  //XFlutterUtils.startPage(context,XPage(Detail2StatePage()));
  static void startPage(
      BuildContext context,
      Widget page, //XPage
          {
        XPageCallback? resultCallback, //传入等待数据返回进一步处理,则传入响应方法(result){...}
        //默认每次都新建一个页面(不管栈中是否存在相同名称的),如果为false,则判断栈中是否含有同名page,有则使用pop返回到同名page(适配实际使用开发时不知道使用push还是pop的情况)
        bool isNewPage=true,
        //跳转后是否关闭当前页
        bool isFinish=false,
        dynamic data,//传递到下一页的数据,获取final Map<String,dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
        XAnimationType pageAnimationType=XAnimationType.custom,//跳转页面动画
      }
      ) async {

    //如果栈中存在相同名称的pageStare,则返回到指定page,不再新建页面
    if(!isNewPage){
      //Navigator.of(context).
    }


    //注意: push的方式每次都会新建一个新的页面!
    //PageRouteBuilder支持背景色透明
    PageRouteBuilder pageRoute= PageRouteBuilder(
      //跳转背景透明路由
        opaque: false,//不透明,设置为false即透明
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        //跳转的页面设置 name（路由名字）才会允许别的页面指定返回到此页面
        settings: RouteSettings(
          name: page.toStringShort(),
          arguments: data,//传递到下一页的数据,获取final Map<String,dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
        ),//XLogUtils.printLog(page.toStringShort());
        pageBuilder: (context, animation, secondaryAnimation) {
          //新页面
          //动画widget: SizeTransition,FadeTransition,RotationTransition,ScaleTransition,SlideTransition

          if(pageAnimationType==XAnimationType.custom){
            //自定义: 从右滑出+渐变

            //从左边滑入
            Offset fromLeft = const Offset(-1, 0.0);
            //从右边滑入
            Offset fromRight = const Offset(1.0, 0.0);
            //从下滑上
            Offset fromBottom = const Offset(0.0, 1.0);
            //从上滑下
            Offset fromTop = const Offset(0.0, -1.0);

            //开始位置
            Offset startOffset = fromRight;
            //结束位置(0,0,不偏移)
            Offset endOffset = Offset.zero;

            return SlideTransition(
              position: Tween<Offset>(
                begin: startOffset,
                end: endOffset,
              ).animate(animation),
              child: FadeTransition(
                opacity: Tween<double>(
                    begin: 0,
                    end: 1
                ).animate(animation),
                /*
                      Semantics 视力障碍者读屏功能
                      Semantics(
                        scopesRoute: true,
                        explicitChildNodes: true,
                        child: page,
                      )
                       */
                child: page,
              ),
            );
          }else if(pageAnimationType==XAnimationType.fade){
            //渐变清晰
            return FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(animation),
                child: page
            );
          }else if(pageAnimationType==XAnimationType.rotation){
            //逆时针围绕中心旋转
            return RotationTransition(
              alignment: Alignment.center,
              turns: Tween<double>(begin: 0.5,end: 0.0).animate(animation),
              child: page,
            );
          }else if(pageAnimationType==XAnimationType.scale){
            //放大动画
            return ScaleTransition(
              alignment: Alignment.center,
              scale: Tween<double>(
                begin: 0,
                end: 1.0,
              ).animate(animation),
              child: page,
            );
          }else if(pageAnimationType==XAnimationType.slideLeft
              || pageAnimationType==XAnimationType.slideRight
              || pageAnimationType==XAnimationType.slideTop
              || pageAnimationType==XAnimationType.slideBottom
          ){
            //从左边滑入
            Offset fromLeft = const Offset(-1, 0.0);
            //从右边滑入
            Offset fromRight = const Offset(1.0, 0.0);
            //从下滑上
            Offset fromBottom = const Offset(0.0, 1.0);
            //从上滑下
            Offset fromTop = const Offset(0.0, -1.0);

            //开始位置
            Offset startOffset = fromLeft;

            if(pageAnimationType==XAnimationType.slideLeft){
              //滑向左边(从右边开始滑入)
              startOffset = fromRight;
            }else if(pageAnimationType==XAnimationType.slideRight){
              //滑向右边(从左边开始滑入)
              startOffset = fromLeft;
            }else if(pageAnimationType==XAnimationType.slideTop){
              //滑向上边(从下边开始滑入)
              startOffset = fromBottom;
            }else if(pageAnimationType==XAnimationType.slideBottom){
              //滑向下边(从上边开始滑入)
              startOffset = fromTop;
            }

            //结束位置(0,0,不偏移)
            Offset endOffset = Offset.zero;
            return SlideTransition(
              position: Tween<Offset>(
                begin: startOffset,
                end: endOffset,
              ).animate(animation),
              child: page,
            );
          }else{
            //没有动画
            return page;
          }

        });

    //注意:带Name的方法只适用静态路由使用,如:Navigator.of(context).pushNamed(routeName)
    if (resultCallback != null) {
      //等待返回数据接收处理,等同:
      // Navigator.of(context)
      //     .push(pageRoute)
      //     .then((result) async{
      //   String resultJson = await result as String;
      //   resultCallback(resultJson);
      // });
      dynamic result =await Navigator.of(context).push(pageRoute);
      //挂起等待返回结果
      resultCallback(result);
    } else {
      //直接跳转,不需要处理返回值
      if(isFinish){
        //跳转并关闭当前页面(替换掉栈顶的页面)
        Navigator.of(context).pushReplacement(pageRoute);
      }else{
        //跳转不关闭当前页
        Navigator.of(context).push(pageRoute);
      }



    }

    //注意:这个方法会先创建一个新页面,然后退出栈中的其他页面(返回false则不保留)
    //Navigator.of(context).pushAndRemoveUntil(pageRoute, (route) => false);//除了新页面,退出栈中其他所有界面
    // String retainPageName='保留页面名称';
    // Navigator.of(context).pushAndRemoveUntil(pageRoute, (Route route){
    //   if(route.settings.name == retainPageName){
    //     //保留页面,并停止继续删除栈中后面的页面
    //     return true;
    //   }else{
    //     //从栈顶开始判断,不保留页面
    //     return false;
    //   }
    // });


  }

  //获得上一界面传递的数据(RouteSettings.arguments)
  static dynamic getPrePageDataFromRouteSettings(BuildContext context){
    //final Map<String,dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    return ModalRoute.of(context)?.settings.arguments;
  }


/*
返回上一页面(如有动画则自动(按进入的)反方向效果)
适用:动态路由
 */
  static void finishPage(
      BuildContext context,
      {
        dynamic result,//携带数据返回上一界面响应
        String? backToPointPageName,//指定返回界面: 返回首页'/',  xsdk框架为具体XState名称
      }
      ) {

    //注意:带Name的方法只适用静态路由使用,如:Navigator.popAndPushNamed(context, backToPointPageName);

    //判断返回到首页则不能再退出了,再退则成空白页
    //替代Navigator.maybePop(),兼容双击退出app
    if(Navigator.canPop(context)){
      if(XStringUtils.isEmpty(backToPointPageName)){
        //返回上1界面
        Navigator.pop(context, result);
      }else{
        //返回指定界面,跳过的中间界面会被移除
        if('首页'==backToPointPageName){
          backToPointPageName='/';
        }

        Navigator.popUntil(context, ModalRoute.withName(backToPointPageName!));
      }
    }else{
      //已返回到首页,双击2次退出app
      //如果flutter作为module依赖，则原生也需要处理退出app，由原生来退出整个app
      //SystemNavigator.pop();//web端无效
      //不用理会原生,直接退出app
      //exit(0);//web端无效

    }

  }

  ////////////////////////////////////////////////////////////


  // static int exitTime=0;
  // //int delaytime:3000
  // static void exitAppByDoubleClick(String warnMessage, int delaytime) {
  //   int nowTime = XDateUtils.getCurrentTime_ms();
  //   if (nowTime - exitTime > delaytime) {
  //     toastx(warnMessage);
  //     exitTime = nowTime;
  //   } else {
  //     //完全退出
  //     exitApp();
  //   }
  // }
  //
  //
  // static void goBackToScreenByDoubleClick(String warnMessage, int delaytime) {
  //   long nowTime = System.currentTimeMillis();
  //   if (nowTime - exitTime > delaytime) {
  //     toastx(warnMessage);
  //     exitTime = nowTime;
  //   } else {
  //     goBackToScreen();
  //   }
  // }




  //打开侧栏
  /*
  注意: context要传入contextOfScaffold!(Scaffold的context,已在框架中赋值设置)
  如直接传入内部自带属性context并不是Scaffold的,会报错
   */
  static void openDrawer(BuildContext contextOfScaffold){
    Scaffold.maybeOf(contextOfScaffold)?.openDrawer();
  }
  static void closeDrawer(BuildContext contextOfScaffold){
    Scaffold.maybeOf(contextOfScaffold)?.closeDrawer();
  }
  static void openEndDrawer(BuildContext contextOfScaffold){
    Scaffold.maybeOf(contextOfScaffold)?.openEndDrawer();
  }
  static void closeEndDrawer(BuildContext contextOfScaffold){
    Scaffold.maybeOf(contextOfScaffold)?.closeEndDrawer();
  }

  ////////////////////////////////////////////////////////

  /*
  uuid: https://pub.dev/packages/uuid
  dependencies:
    uuid: ^3.0.6
  import 'package:uuid/uuid.dart';
   */
  static String getUUID(){

    /*
    // Generate a v1 (time-based) id
    uuid.v1(); // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'

    // Generate a v4 (random) id
    uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

    // Generate a v5 (namespace-name-sha1-based) id
    uuid.v5(Uuid.NAMESPACE_URL, 'www.google.com'); // -> 'c74a196f-f19d-5ea9-bffd-a2742432fc9c'
     */
    return const Uuid().v1();

  }

  /*
  图片选择器(相册,摄像头):
  image_picker: https://pub.dev/packages/image_picker
  dependencies:
    image_picker: ^0.8.5+3
  import 'package:image_picker/image_picker.dart';
 */
  static void openImagePicker(
      {
        required XFunctionResultCallback<XFile?> callback,
        bool isCamera=false,

      }
      ) {
    /*
    // Pick a video
    final XFile? image = await _picker.pickVideo(source: ImageSource.gallery);
    // Capture a video
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    // Pick multiple images
    final List<XFile>? images = await _picker.pickMultiImage();
     */
    ImagePicker _picker = ImagePicker();
    if(isCamera){
      //拍照
      _picker.pickImage(source: ImageSource.camera).then((XFile? image) {
        callback(image);
      });
    }else{
      //相册选择
      _picker.pickImage(source: ImageSource.gallery).then((XFile? image) {
        callback(image);
      });
    }
  }


  /*
  日期选择器(自带)
  DateTime currentSelectDate=DateTime.now();
   */
  static void openDatePicker(
      {
        required BuildContext context,
        //当前选中的日期
        required DateTime currentSelectDate,
        //注意:按取消则返回null
        required XFunctionResultCallback<DateTime?> callback,
        /*
        // 自定义哪些日期可选
        (dayTime) {
        if (dayTime == DateTime(2022, 5, 6) ||
            dayTime == DateTime(2022, 6, 8)) {
          return false;
        }
        return true;
        },
         */
        SelectableDayPredicate? checkCanSelectDateFunction,
        //选择日期模式,否则是选择年模式
        bool isDayMode=true,
        //主题颜色
        MaterialColor? Colors_color,//Colors.amber
        //可选开始日期
        DateTime? startDate,
        //可选结束日期
        DateTime? endDate,
      }
      ) {
    //
    showDatePicker(
      context:context,
      initialDate: currentSelectDate??DateTime.now(), // 初始化选中日期
      firstDate: startDate??DateTime(1900), // 开始日期
      lastDate: endDate??DateTime(3000), // 结束日期
      currentDate: DateTime.now(), // 系统当前日期
      selectableDayPredicate: checkCanSelectDateFunction,
      //locale: const Locale('zh'),//中文显示,要设置代理,在app中配置,否则报错
      // 日历弹框样式 calendar: 默认显示日历，可切换成输入模式，input:默认显示输入模式，可切换到日历，calendarOnly:只显示日历，inputOnly:只显示输入模式
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: isDayMode?DatePickerMode.day:DatePickerMode.year, // 日期选择模式 默认为天
      useRootNavigator: true, // 是否使用根导航器
      helpText: "请选择日期", // 左上角提示文字
      confirmText: "确认", // 确认按钮 文案
      cancelText: "取消", // 取消按钮 文案
      errorFormatText: "输入日期格式有误，请重新输入", // 输入日期 格式错误提示
      errorInvalidText: "输入日期不合法，请重新输入", // 输入日期 不在first 与 last 之间提示
      fieldLabelText: "输入所选日期", // 输入框上方 提示
      fieldHintText: "请输入日期", // 输入框为空时提示
      //设置主题颜色
      builder: Colors_color == null?null:(context, child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors_color,
          ),
          child: child!,
        );
      },
    ).then((DateTime? dateTime){
      //注意:外部要更新选中日期,这样下次进入则是上次选中的日期
      //setState(()=>_currentSelectDate=currentSelectDate);
      callback(dateTime);
    });

  }

  /*
  时间选择器(自带)
  TimeOfDay currentSelectTime=TimeOfDay.now();
   */
  static void openTimePicker(
      {
        required BuildContext context,
        //当前选中的时间
        required TimeOfDay currentSelectTime,
        //注意:按取消则返回null
        required XFunctionResultCallback<TimeOfDay?> callback,
        SelectableDayPredicate? checkCanSelectDateFunction,
        //选择日期模式,否则是选择年模式
        bool isDayMode=true,
        //主题颜色
        MaterialColor? Colors_color,//Colors.amber
        //可选开始日期
        DateTime? startDate,
        //可选结束日期
        DateTime? endDate,
      }
      ) {
    //
    showTimePicker(
      context:context,
      initialTime: currentSelectTime??TimeOfDay.now(), // 初始化选中事件
      //  默认显示时间，可切换成输入模式，input:默认显示输入模式
      initialEntryMode: TimePickerEntryMode.dial,
      useRootNavigator: true, // 是否使用根导航器
      helpText: "请选择时间", // 左上角提示文字
      confirmText: "确认", // 确认按钮 文案
      cancelText: "取消", // 取消按钮 文案
      errorInvalidText: "输入时间不合法，请重新输入", // 输入日期 不在first 与 last 之间提示
      hourLabelText: "输入小时", // 输入框上方 提示
      minuteLabelText: "输入分钟", // 输入框为空时提示
      //设置主题颜色
      builder: Colors_color == null?null:(context, child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors_color,
          ),
          child: child!,
        );
      },
    ).then((TimeOfDay? timeOfDayime){
      //注意:外部要更新选中日期,这样下次进入则是上次选中的日期
      //setState(()=>_currentSelectDate=currentSelectDate);
      callback(timeOfDayime);
    });

  }


  /*
  AlertDialog 弹框-普通提示
   */
  static void openAlertDialog(
      {
        required BuildContext context,
        required String contentStr,
        String? titleStr,
      }
      ) {
    //
    showDialog<void>(
      context: context,
      barrierDismissible: false, // 不能点击空白处关闭
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleStr == null?null:XWidgetUtils.getWidgetText(titleStr,style: XStyleUtils.textStyle_000_16()),
          //可以自定义其他widget
          content: XWidgetUtils.getWidgetText(contentStr,style: XStyleUtils.textStyle_333_14()),
          actions: <Widget>[
            TextButton(
              child: const Text('关闭'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  /*
  AlertDialog 弹框-返回处理结果
   */
  static void openAlertDialogWithResult(
      {
        required BuildContext context,
        required String contentStr,
        required XFunctionResultCallback<String> callbackResult,
        String? titleStr,
      }
      ) {
    //
    showDialog<void>(
      context: context,
      barrierDismissible: false, // 不能点击空白处关闭
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleStr == null?null:XWidgetUtils.getWidgetText(titleStr,style: XStyleUtils.textStyle_000_16()),
          //可以自定义其他widget
          content: XWidgetUtils.getWidgetText(contentStr,style: XStyleUtils.textStyle_333_14()),
          actions: <Widget>[
            TextButton(
              child: const Text('是'),
              onPressed: () {
                //返回(关闭alterDialog)
                Navigator.of(context).pop();
                //返回结果
                callbackResult('是');
              },
            ),
            TextButton(
              child: const Text('否'),
              onPressed: () {
                //返回(关闭alterDialog)
                Navigator.of(context).pop();
                //返回结果
                callbackResult('否');
              },
            ),
          ],
        );
      },
    );
  }

  /*
  AlertDialog 弹框-自定义widget
   */
  static void openAlertDialogWithCustomWidget(
      {
        required BuildContext context,
        required Widget contentWidget,
        String? titleStr,
      }
      ) {
    //
    showDialog<void>(
      context: context,
      barrierDismissible: false, // 不能点击空白处关闭
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleStr == null?null:XWidgetUtils.getWidgetText(titleStr,style: XStyleUtils.textStyle_000_16()),
          //可以自定义其他widget
          content: contentWidget,
          actions: <Widget>[
            TextButton(
              child: const Text('关闭'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*
  SimpleDialog 弹框-自定义widget
   */
  static void openSimpleDialog(
      {
        required BuildContext context,
        required List<Widget> children,
        //外部空白处是否能点击关闭
        bool canCancelAtOuter=false,
        String? titleStr,
      }
      ) {
    //
    showDialog<void>(
      context: context,
      barrierDismissible: canCancelAtOuter,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: titleStr == null?null:XWidgetUtils.getWidgetText(titleStr,style: XStyleUtils.textStyle_000_16()),
          children: children,
        );
      },
    );
  }


  /*
  BottomSheet底部弹框
  使用showBottomSheet会报错:No Scaffold widget found.的原因:
    传入的context并不是Scaffold的context,要改为传入contextOfScaffold!(Scaffold的context,已在框架中赋值设置)即可,
    但其ui交互需要定义的比较多,这里改为使用showModalBottomSheet,则可以直接传入context或contextOfScaffold!,
    showModalBottomSheet默认点击空白处关闭,或手动关闭:Navigator.of(context).pop();
   */
  static void openBottomSheet(
      {
        required BuildContext context,
        required Widget child,
        Color? backgroundColor,
        double? elevation,
        ShapeBorder? shape,
      }
      ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return XWidgetUtils.getLayoutContainer(
            child: child
        );
      },
      backgroundColor: backgroundColor,
      elevation:elevation,
      shape: shape,
    );
  }


  /*
  loading框(Dialog方式),有可能误关闭新页面,改为在各自state中用Overlay实现
  关闭:Navigator.maybePop(context);
  注意:避免多次重复关闭,会退出当前界面
  static void openLoading(
      {
        required BuildContext context,
        //外部空白处是否能点击关闭
        bool canCancelAtOuter=true,
      }
      ) {
    //
    showDialog<void>(
      context: context,
      barrierDismissible: canCancelAtOuter,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return const Center(
            child:SizedBox(
              width: 20,height: 20,
              child:CircularProgressIndicator(
                strokeWidth: 2.0,
                // backgroundColor: Colors.blue,
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
        );
      },
    );

  }
  //注意:避免多次重复关闭,会退出当前界面
  static void closeLoading(BuildContext context){
    Navigator.maybePop(context);
  }
   */









}
