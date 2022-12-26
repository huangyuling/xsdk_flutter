import 'package:flutter/material.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_flutter.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_log.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_widget.dart';


/*
 通用StatefulWidget父类,与XState联合使用,只需自定义XState即可
 XStatefulWidget(XState());
 用于控件
 */
class XStatefulWidget<T extends State> extends StatefulWidget {

  /*
  官方是一个State对应要一个StatefulWidget,为了避免重复写多个StatefulWidget,这里实现State共用统一个StatefulWidget
   */

  //注意:这种在构造函数中传入State会在返回切换路由时报错(TabBar/BottomNavigationBar),因为State已经被销毁,但是StatefulWidget不会被销毁,导致返回路由,再次获得State为null值
  //另外:dart支持反射,但flutter禁用发射,也不能通过类Type创建实例方式实现
  // T xState;
  // XStatefulWidget(this.xState, {super.key});
  // @override
  // T createState() {
  //   return xState;
  // }

  //ok通过传入方法function方式实现共用同一个StatefulWidget,就算state销毁了,StatefulWidget重新调用createState()方法,实际调用的外部实现传入的ValueGetter方法,达到创建新实例;
  ValueGetter<T> createStateFunction;

  XStatefulWidget(this.createStateFunction, {super.key});

  @override
  T createState() {
    return createStateFunction();
  }


}

//使用State要嵌套XStatefulWidget中/////////////////////////////////

/*
 所有XState父类
 State生命周期: 构造方法 -> initState -> didChangeDependencies -> build -> deactivate -> dispose
 */
abstract class XState<T extends XStatefulWidget> extends State<T> with AutomaticKeepAliveClientMixin {

  //
  dynamic xData;

  /*
  实现with AutomaticKeepAliveClientMixin 保存页面状态(使用TabBar和BottomNavigationBar)
  注意: 在build()中必须调用super.build(context);
   */
  //是否保留TabBar和BottomNavigationBar的子界面
  bool isKeepPageState=false;
  //重写AutomaticKeepAliveClientMixin的wantKeepAlive( bool get wantKeepAlive => true;)
  @override
  bool get wantKeepAlive => isKeepPageState;

  //子类取消required,(这里强制required则子类会提示生成构造方法)
  XState(
      {
        required this.xData,
        this.isKeepPageState=false,
      }
      );


  /*
  1.生命周期,初始化,只会执行一次,相当于onCreate()方法
  注意:重写该方法,要加入super.initState();实现父类的api
  在此方法中,可以配置动画或订阅platform services,通常用于初始化数据
  //注意:不能用于获得数据,否则报错,如:  final Map<String,dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
   */
  @override
  void initState() {
    super.initState();
    //初始化数据(只执行一次)
    onCreate();
  }
  //用于初始化数据
  @required
  void onCreate();

  /*
  2.生命周期,相当于onStart,在initState()之后执行,
  注意:重写该方法,要加入super.didChangeDependencies();实现父类的api
  在这里可以跨组件获得数据:
  调用BuildContext.inheritFromWidgetOfExactType()获得InheritedWidget(State中的子InheritedWidget)。
  获得上一界面传递的数据:
  final Map<String,dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;

  注意:调用setState后不会触发此方法

  专门用来处理 State 对象依赖关系变化: State 对象的依赖关系发生变化后，Flutter 会回调该方法，随后触发组件构建。
  State 对象依赖关系发生变化的典型场景：系统语言 Locale 或应用主题改变时，系统会通知 State 执行 didChangeDependencies 回调方法
   */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //获得数据
    onStart();
  }
  //用于获得数据
  @required
  void onStart();

  /*
  3.生命周期:build显示界面
  1.新建在第一次initState()等最后执行,显示ui
  2.每次setState()会触发执行,从而对UI的更新(因此数据初始化或获得数据方法都不能放在这里)
   */
  @override
  Widget build(BuildContext context) {
    //实现with AutomaticKeepAliveClientMixin,并且isKeepPageState为true时调用,注意:isKeepPageState为false时不要调用,否则报错
    // if(isKeepPageState){
    //   super.build(context);
    // }

    super.build(context);


    return onBuild(context);
  }

  //用于创建UI界面
  @required
  Widget onBuild(BuildContext context);

  /*
  4.生命周期:停止,相当于onStop,在dispose()之前执行
  注意:重写该方法,要添加super.deactivate();实现父类的api

  当组件的可见状态发生变化时，deactivate 方法会被调用，这时 State 会被暂时从视图树中移除。
  注意：页面切换时，由于 State 对象在视图树中的位置发生了变化，需要先暂时移除后再重新添加，重新触发组件构建，因此也会调用 deactivate 方法
   */
  @override
  void deactivate() {
    super.deactivate();
    onStop();
  }
  //停止
  @required
  void onStop();

  /*
  5.生命周期:最后结束,相当于onDestroy,在deactivate()之后执行
  注意:重写该方法,要添加super.dispose();实现父类的api

  当 State 被永久地从视图树中移除时，Flutter 会调用 dispose 方法，而一旦 dispose 方法被调用，组件就要被销毁了，
  因此可以在 dispose 方法中进行最终的资源释放、移除监听、清理环境等工作
   */
  @override
  void dispose() {
    //ok放在super.dispose()前
    onDestroy();
    super.dispose();
  }

  //销毁
  @required
  void onDestroy();

  /*
  生命周期,组件的状态改变的时候就会调用didUpdateWidget, 当Widget 的配置发生变化时，或热重载时，系统会回调该方法
  实际上这里flutter框架会创建一个新的Widget,绑定本State，并在这个函数中传递老的Widget。
  这个函数一般用于比较新、老Widget，看看哪些属性改变了，并对State做一些调整。
  需要注意的是，涉及到controller的变更，需要在这个函数中移除老的controller的监听，并创建新controller的监听。
  注意:调用setState后不会触发此方法
   */
  // @override
  // void didUpdateWidget(XStatefulWidget oldPage) {
  //   super.didUpdateWidget(oldPage);
  // }


//////////////////////////////////////////////////////

  //通知State更新,重新执行build()方法
  // void notifyStateDataChange(VoidCallback fn) {
  //   setState(fn);
  // }



  OverlayEntry? _loadingOverlayEntry;

  void showLoading(){

    try {

      if(_loadingOverlayEntry!=null){
        return;
      }

      _loadingOverlayEntry = OverlayEntry(
        builder: (_) {
          return IgnorePointer(
            child: XWidgetUtils.getLayoutColumn(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  XWidgetUtils.getLayoutCenter(
                      const SizedBox(
                          width: 20,height: 20,
                          child:CircularProgressIndicator(
                            strokeWidth: 2.0,
                            // backgroundColor: Colors.blue,
                            // valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          )
                      )
                  )
                ]
            ),
          );
        },
      );
      Overlay.of(context)?.insert(_loadingOverlayEntry!);

    }catch (e) {
      XLogUtils.printLog(e.toString());
    }


  }
  void hideLoading(){
    _loadingOverlayEntry?.remove();
    _loadingOverlayEntry = null;
  }

}