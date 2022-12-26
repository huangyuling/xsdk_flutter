import 'package:flutter/material.dart';
import 'package:xsdk_flutter_package/xsdk/framework/support/xsdk_navigator_observers.dart';


/*
App的Base父类

捕获异常: 在main.dart中使用runZonedGuarded包裹runApp(MyApp());
runZonedGuarded<Future<void>>(() async {
    runApp(MyApp());
  }, (Object error, StackTrace stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    XLogUtils.printLog('runZonedGuarded捕获异常: $error');
    XLogUtils.printLog('runZonedGuarded捕获异常: $stackTrace');
  });


 */

abstract class XDKApp extends StatelessWidget {
  const XDKApp({
    super.key
  });


  @override
  Widget build(BuildContext context) {
    //注意:这里的context没有Navigator,不能在这里初始化xContext,否则使用时会报错:Navigator operation requested with a context that does not include a Navigator
    //XFlutterUtils.xContext=context;

    //使用MaterialApp,Material是一种标准的移动端和web端的视觉设计语言。 Flutter提供了一套丰富的Material widgets。
    return MaterialApp(
      restorationScopeId: 'xsdk_app',
      locale: const Locale('zh'),
      //showPerformanceOverlay: true,//实测:web端报错
      onGenerateTitle: (BuildContext context) =>'XSDK_Flutter',
      //全局设置控制
      // theme: ThemeData(
      //     textButtonTheme: TextButtonThemeData(
      //         style: ButtonStyle()
      //     ),
      //     elevatedButtonTheme: ElevatedButtonThemeData(
      //         style: ButtonStyle()
      //     ),
      //     outlinedButtonTheme: OutlinedButtonThemeData(
      //         style: ButtonStyle()
      //     )
      // ),
      /*
      ThemeData(
        //primaryColor: //主色
      ),
       */
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false, //在测试模式中,不在右上角显示debug标签
      //静态路由(界面跳转: Navigator.restorablePushNamed(context, SettingsView.routeName);)
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
      //全局路由监听
      navigatorObservers: [XSDKNavigatorObserver()],
      home: initFirstPage(),

    );
  }


  //加载第1页(通常是欢迎页)
  @required
  Widget initFirstPage();



}
