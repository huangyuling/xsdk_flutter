
/*
 页面父类基础界面
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xsdk_flutter_package/xsdk/framework/bean/x_bean_menu.dart';
import 'package:xsdk_flutter_package/xsdk/operation/x_temp.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_flutter.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_log.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_toast.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_widget.dart';
import 'package:xsdk_flutter_package/xsdk/framework/base/xsdk_widget_stateful.dart';


/*
 通用页面: XPage(XStatePage());
 */
class XPage<T extends XState> extends XStatefulWidget<T> {

  XPage(super.createStateFunction, {super.key});

  //这里因XPage为通用,重写toString,改为显示具体XStatePage名称,(用于指定导航返回)//////////////////////////////////////////
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // final String type = objectRuntimeType(super.createStateFunction(), '');
    // XLogUtils.printLog('---type类型=$type');
    // return type;

    XLogUtils.printLog('---type类型=${T.toString()}');
    return T.toString();
  }

  @override
  String toStringShort() {
    return toString();
  }

}



//通用页面实现State
abstract class XPageState extends XState<XPage> with WidgetsBindingObserver,TickerProviderStateMixin{

  //已自带BuildContext变量 context
  //已自带变量widget,指向XPage

  //
  String? xTag;
  List<dynamic> listData=[];

  //这里强制required则子类会提示生成构造方法
  XPageState(
      {required this.xTag,
        required super.xData,
        super.isKeepPageState=false, //值true时:TabBar/BottomNavigationBar切换时,保留上次页面状态
      }
      );

  //重写toStringShort方法,获得具体XStatePage名称
  @override
  String toStringShort() {
    return objectRuntimeType(this, '');
  }
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return toStringShort();
  }

  //生命周期////////////////////////////////////////////////////////


  //重写父类生命周期方法
  @override
  void initState() {
    XLogUtils.printLog('[Page] ----- ${toStringShort()} -----');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /*
    监听 App 生命周期,需重写didChangeAppLifecycleState方法
    注意：这里app的生命周期并不是像 Android 那样页面切换的生命周期，而是监听点击 home、物理返回键、屏幕锁定和解锁;
    实测web端不适用?
   */
    WidgetsBinding.instance.addObserver(this);
  }

  //1.(创建时)用于初始化数据,只执行一次,
  //注意:不能在这里接收数据,否则报错,如: final Map<String,dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
  // @override
  // void onInitOnce() {
  // }


  //2.用于获得数据(接收上一界面传递信息等工作),如: final Map<String,dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
  //注意:可初始化Object?数据,使用??=赋值初始化(避免特殊情况再次触发执行,造成资源无法释放等)
  // @override
  // void onStart() {
  // }

  /*
  3.创建页面widget
  如果启用tabBar或bottomNavigation,则这里为对应各个tabOrbottomNavigationItem的内容View,
  判断各自item创建不同的widget,可以是XPage(推荐)/StatefulWidget/XStatelessWidget
  参数:
  menuItem: tabBar或者bottomNavigation的Item
   */
  @required
  Widget getBodyWidget(
      {
        XBeanMenuItem? menuItem
      }
      );

  /*
  4.停止
    当组件的可见状态发生变化时会被调用，这时 State 会被暂时从视图树中移除。
    如: 页面切换时，由于 State 对象在视图树中的位置发生了变化，需要先暂时移除后再重新添加;
   */
  @override
  void onStop() {
    //XLogUtils.printLog("---onStop");
  }

  /*
  5.销毁 释放资源
   */
  //ok重写集成的TickerProviderStateMixin的dispose,最后自动执行state的dispose方法
  @override
  void dispose() {
    //注意:使用TickerProviderStateMixin的controller都需要手动释放
    //XLogUtils.printLog("----dispose");

    //手动释放动画控制器,注意:要在super.dispose();前执行,否则报错!
    _animationControllerMengcheng?.dispose();
    //手动释放tabBar的controller
    _tabController?.dispose();
    //手动释放bottomNavigationBar的PageController
    _bottomNavigationBarPageController?.dispose();

    //
    super.dispose();
  }

  @override
  void onDestroy() {
    //XLogUtils.printLog("---onDestroy");
    //左右半边蒙层
    if (toStringShort()==XTempData.mengcengLeftOpenPageName){
      XTempData.isPageMengcengLeftOpen=false;
    }
    if (toStringShort()==XTempData.mengcengRightOpenPageName){
      XTempData.isPageMengcengRightOpen=false;
    }

    //取消监听App 生命周期
    WidgetsBinding.instance.removeObserver(this);

  }


  //页面设置//////////////////////////////////////////////////////////////////////

  //设置页面背景颜色
  Color? _pageBackgroundColor;
  void setXPageBackgroundColor(
      Color? backgroundColor
      ){
    _pageBackgroundColor=backgroundColor;
  }

  //状态栏/////////////////////////////////////////////////////
  /*
  由于使用Scaffold,则在Scaffold中属性设置
   */
  Color? _statusBarColor;
  Brightness? _statusBarTextAndIconBrightness;

  void setXStatusBarColor(
      Color? backgroundColor,
      Brightness? Brightness_light_text_icon,
      ){
    _statusBarColor=backgroundColor;
    _statusBarTextAndIconBrightness=Brightness_light_text_icon;

  }

  //标题栏/////////////////////////////////////////////////////

  //是否显示标题栏
  bool _isShowTitleBar=false;
  //是否显示左按钮图标
  bool _isShowTitleBarLeftWidget=false;
  //是否底部分割线
  bool _isShowTitleBarBottomDivider=true;
  //标题是否居中
  bool _isShowTitleBarTitleTextCenter=true;
  //居中标题
  String? _titleBarCenterText;
  //标题栏背景
  Color? _titleBarBackgroundColor;
  //标题栏默认左按钮
  Widget? _titleBarLeftWidget;
  //标题栏右按钮
  List<Widget>? _titleBarRightWidgets;
  //标题栏高度
  double? _titleBarHeight;

  //设置标题栏
  void setXTitle(
      {
        bool isShowTitleBar=true,//是否标题栏
        double? titleBarHeight,//高度
        String ?titleText,
        bool isShowTitleTextCenter=true,//标题是否居中
        Color? backgroundColor=const Color(0xFFFFFFFF),//标题栏背景颜色
        bool isShowBottomDivider=true,//是否显示底部分割线
        bool isShowLeftWidget=true,//是否显示左按钮图标
        Widget? leftWidget,//更新左按钮图标(更新替代)
        List<Widget>? rightWidgets,
      }
      ){
    _isShowTitleBar=isShowTitleBar;
    _titleBarCenterText=titleText;
    _isShowTitleBarBottomDivider=isShowBottomDivider;
    _titleBarBackgroundColor=backgroundColor;
    _isShowTitleBarTitleTextCenter=isShowTitleTextCenter;
    _titleBarHeight=titleBarHeight;

    //左按钮图标
    _isShowTitleBarLeftWidget=isShowLeftWidget;
    _titleBarLeftWidget=leftWidget;

    //右按钮图标
    _titleBarRightWidgets=rightWidgets;

  }



  //TabBar,类似android的Tab+Fragment/////////////////
  /*
  注意:
  在此base页面父类中集成TabBar支持,但需要继承XPageTabBottomNavigationBarState使用;
  因为重写getBodyWidget()方法,指定使用XPage+XPageState有状态的页面(切换时支持是否保存状态),
  而不是普通的StatelessWidget(每次切换都会重新更新)
   */
  //是否使用TabBar
  bool _isEnableTabBar=false;
  //tabBar是否在appBar内(同一背景),否则可以单独设置不同背景等
  bool _isTabBarInAppBar=false;
  //是否可滚动
  bool _isTabBarScrollable=true;
  //是否居中(设置可滚动时按item宽度,居中显示,否则靠左)
  bool _isTabBarAlignCenter=false;
  //tabBar高度
  double _tabBarHeight=46;
  //tabBar背景
  Color? _tabBarBackgroundColor;
  //注意:这里不使用DefaultTabController套在最外层,使用TabController实例传入tab
  TabController? _tabController;
  /*
  开启tabBar,初始化tabBar数据
  _listTabItems.addAll(<XTabItemData>[
      XTabItemData(text: 'CAR', icon: Icons.directions_car),
      XTabItemData(text: 'BICYCLE', icon: Icons.directions_bike),
      XTabItemData(text: 'BOAT', icon: Icons.directions_boat),
      XTabItemData(text: 'BUS', icon: Icons.directions_bus),
      XTabItemData(text: 'TRAIN', icon: Icons.directions_railway),
      XTabItemData(text: 'WALK', icon: Icons.directions_walk),
    ]);
   */
  final List<XBeanMenuItem> _listTabItems=[];//注意:item不能为null
  void setXTabBar(
      {
        bool isEnableTabBar=true,
        bool isTabBarInAppBar=false,//tabBar是否在appBar内(同一背景),否则可以单独设置不同背景等
        bool isAlignCenter=false,//是否居中(设置可滚动时按item宽度,居中显示,否则靠左)
        bool isScrollable=true,//是否可滚动,可滚动则按每个item宽度, 如果不可滚动则所有item的总宽度适应占满总屏幕宽度
        double height=46,//tabBar高度
        Color? backgroundColor,
        List<XBeanMenuItem>? items,
      }
      ){

    //TabBar和BottomNavigationBar一次只能使用一个
    _isEnableBottomNavigationBar=false;

    _isEnableTabBar=isEnableTabBar;
    _isTabBarInAppBar=isTabBarInAppBar;
    _isTabBarScrollable=isScrollable;
    _isTabBarAlignCenter=isAlignCenter;
    _tabBarHeight=height;
    _tabBarBackgroundColor=backgroundColor;


    //先释放旧的controller,再更新
    _tabController?.dispose();

    //
    _listTabItems.clear();
    if(items!=null){
      _listTabItems.addAll(items);
    }

    //注意:这里不使用DefaultTabController套在最外层方式,声明切换length的个数,保证与listTabItems个数一致，否则会报错。
    _tabController=TabController(
      animationDuration: const Duration(milliseconds: 200),
      //注意:TabController初始化声明length只能设置一次,不能更改,因此需要预先加载确认tab的个数
      length:_listTabItems.length,
      vsync: this,
    );

  }

  //手动切换tabView(tabBar已自动关联tabView)
  void changeTab(int index) {
    if (index < 0
        || index >= _tabController!.length
        || index == _tabController!.index) return;
    _tabController!.animateTo(index);
  }

  /*
  设置TabItemView(Tab)
  注意:设置Tab时,其text与child不能同时设置,否则报错;
  icon,text上下排列,可单独设置其中一个使用
  也可只设置child自定义使用
  Tab(
      text: tabItemData.title,
      icon: new Icon(tabItemData.icon),
      //child: new Text(tabItemData.title+'*'),
      );
   */
  //可重写自定义Tab
  Tab getTabItemWidget(XBeanMenuItem tabItem){
    //默认Tab为图标文字上下结构,这里设定只显示1个(图标或文字)

    //图标显示优先文字,二选一,避免撑破高度(tab上下结构)
    if(tabItem.icon!=null){
      return Tab(
        //text: tabItem.text,
        icon: Icon(tabItem.icon,color: tabItem.iconColor),
      );
    }else{
      return Tab(
        text: tabItem.text,
        //icon: Icon(tabItem.icon),
      );
    }
  }

  //创建TabBar(私有,内部实现)
  TabBar _createTabBar() {
    return TabBar(
      //注意:使用DefaultTabController时不能设置TabBar的controller,否则会报错
      controller: _tabController,
      isScrollable:_isTabBarScrollable,
      //indictiorColor,//指示器颜色
      //indicatorWeight指示器高
      //indicatorPadding指示器边距【EdgensetsGeometry】
      //indicatorSize指示器大小计算方式，TabbarIndicatorSize.label跟文字等宽 TabbarIndicatorSize.tab跟每个tab等宽
      //labekStyle页签文字样式
      //labelColor选中label颜色
      //labelPadding每个label的padding值
      //unselectedLabelColor未选中文字颜色
      //unselectedLabelStyle未选中文字样式
      //使用map将原始数据list转换成Tab的list
      tabs: _listTabItems.map((XBeanMenuItem tabItemData) {
        return XWidgetUtils.getLayoutColumn(children:[XWidgetUtils.getLayoutExpanded(getTabItemWidget(tabItemData))]);
      }).toList(),
    );
  }

  //创建tabView(私有,内部实现)
  TabBarView _createTabBarView() {
    return TabBarView(
      //注意:使用DefaultTabController时不能设置TabBar的controller,否则会报错
      controller: _tabController,
      children: _listTabItems.map((XBeanMenuItem tabItemData) {
        return getBodyWidget(menuItem:tabItemData);
      }).toList(),
    );
  }

  //BottomNavigatorBar (底部导航栏,图标方式显示)////////////////////////////////////////////////////////////////////////
  /*
  注意:
  在此base页面父类中集成TabBar支持,但需要继承XPageTabBottomNavigationBarState使用;
  因为重写getBodyWidget()方法,指定使用XPage+XPageState有状态的页面(切换时支持是否保存状态),
  而不是普通的StatelessWidget(每次切换都会重新更新)
   */
  //是否启用BottomNavigationBar
  bool _isEnableBottomNavigationBar=false;
  //背景颜色
  Color? _bottomNavigationBarBackgroundColor;
  //字体颜色
  Color _bottomNavigationBarTextColor=const Color(0xff666666);
  //当前字体颜色
  Color? _bottomNavigationBarCurrentTextColor=const Color(0xff000000);
  final List<XBeanMenuItem> _listBottomNavigationItems=[];//注意:item不能为null
  int _bottomNavigationBarIndex=0;//底部导航下标

  PageController? _bottomNavigationBarPageController;//PageView使用

  //初始时同时加载所有页面,使用IndexedStack
  bool _isLoadAllPagesForBottomNavigationBar=false;

  //开启BottomNavigatorBar和初始化数据,参考tabBar
  void setXBottomNavigationBar(
      {
        bool isEnableBottomNavigationBar=true,
        bool isLoadAllPages=false,
        Color? backgroundColor,
        List<XBeanMenuItem>? items,
        Color textColor=const Color(0xff666666),
        Color currentTextColor=const Color(0xff000000),
      }
      ){

    //TabBar和BottomNavigationBar一次只能使用一个
    _isEnableTabBar=false;
    _isEnableBottomNavigationBar=isEnableBottomNavigationBar;
    _isLoadAllPagesForBottomNavigationBar=isLoadAllPages;

    _bottomNavigationBarBackgroundColor=backgroundColor;
    _bottomNavigationBarTextColor=textColor;
    _bottomNavigationBarCurrentTextColor=currentTextColor;

    //
    _listBottomNavigationItems.clear();
    if(items!=null){
      _listBottomNavigationItems.addAll(items);
    }

    //IndexedStack不需要Controller
    if(!_isLoadAllPagesForBottomNavigationBar){
      _bottomNavigationBarPageController?.dispose();
      _bottomNavigationBarPageController = PageController();
    }

  }

  //创建BottomNavigationBar(私有)
  BottomNavigationBar _createBottomNavigationBar(){
    return BottomNavigationBar(
      //List<BottomNavigationBarItem> items=[];
      items:_listBottomNavigationItems.map((XBeanMenuItem tabItemData) {
        return BottomNavigationBarItem(
          label: tabItemData.text??'',//不能为空,否则报错
          icon: Icon(tabItemData.icon,color: tabItemData.iconColor),
          activeIcon:tabItemData.activeIcon == null?Icon(tabItemData.icon,color: tabItemData.iconColor):Icon(tabItemData.activeIcon,color: tabItemData.activeIconColor,),
        );
      }).toList(),
      //点击监听
      onTap: (int index){
        //通知更新state,切换界面,下标从0开始
        //XLogUtils.printLog('_bottomNavigationBarIndex=$index');
        if(_bottomNavigationBarIndex!=index){
          setState(() {
            //更新
            _bottomNavigationBarIndex=index;

            //切换页面,PageView方式(IndexedStack不需要)
            if(!_isLoadAllPagesForBottomNavigationBar){
              //没有动画效果
              //_bottomNavigationBarPageController?.jumpToPage(index);

              //使用动画效果
              _bottomNavigationBarPageController?.animateToPage(index,
                  duration: const Duration(milliseconds: 200), curve: Curves.ease);
            }

          });
        }
      },
      /*
      类型:
      shifting: 默认值,背景白色(设置背景色无效),只显示当前item的lable,其他不显示,鼠标悬停会弹出label提示
      fixed: 设置背景色生效,所有item都显示label
       */
      type: BottomNavigationBarType.fixed,
      //背景色
      backgroundColor: _bottomNavigationBarBackgroundColor,
      //当前位置下标值
      currentIndex: _bottomNavigationBarIndex,
      //当前字体颜色
      //fixedColor: _bottomNavigationBarCurrentTextColor,//同selectedItemColor??
      selectedItemColor: _bottomNavigationBarCurrentTextColor,
      unselectedItemColor: _bottomNavigationBarTextColor,


    );
  }






  //页面中间主体部分上下空间 ////////////////////////////////////////////////////////
  Widget? _page_topbar_widget;
  Widget? _page_bottombar_widget;

  void setXTopBarWidget(
      double height,
      Widget topBarWidget,
      {
        Color? backgroundColor
      }
      ){

    _page_topbar_widget=XWidgetUtils.getLayoutContainer(
      width: double.infinity,
      height: height,
      backgroundColor: backgroundColor,
      child: topBarWidget,
    );

  }

  void setXBottomBarWidget(
      double height,
      Widget bottomBarWidget,
      {
        Color? backgroundColor
      }
      ){

    _page_bottombar_widget=XWidgetUtils.getLayoutContainer(
      width: double.infinity,
      height: height,
      backgroundColor: backgroundColor,
      child: bottomBarWidget,
    );

  }

  //页面左右两边空间 ////////////////////////////////////////////////////////
  Widget? _page_left_space;
  Widget? _page_right_space;
  //左右蒙层自身动画
  AnimationController? _animationControllerMengcheng;
  CurvedAnimation? _curvedAnimationMengcheng;

  void setXLeftFixSpace(
      {
        double? width,
        Widget? replaceWidget
      }
      ){
    if(replaceWidget==null){
      //默认空白半透明

      //蒙层颜色(默认透明,多层时避免加深)
      Color mengcengColor=Colors.transparent;
      if (!XTempData.isPageMengcengLeftOpen){
        XTempData.isPageMengcengLeftOpen=true;
        mengcengColor=XTempData.pageMengcengColor;
        XTempData.mengcengLeftOpenPageName=toStringShort();
      }

      //itemWidget实现动画
      _animationControllerMengcheng??= AnimationController(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 50),
        vsync: this,
      );
      _curvedAnimationMengcheng??= CurvedAnimation(parent: _animationControllerMengcheng!, curve: Curves.easeIn);
      // bounceIn = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
      // linear = CurvedAnimation(parent: controller, curve: Curves.linear);
      // decelerate = CurvedAnimation(parent: controller, curve: Curves.decelerate);
      // 也可使用简单的: Tween(begin: 50.0, end: 120.0).animate(animationController500);

      // curvedAnimation.addStatusListener((status) {
      //   if (status == AnimationStatus.completed) {
      //     _animationControllerMengcheng?.reverse();
      //   } else if (status == AnimationStatus.dismissed) {
      //     _animationControllerMengcheng?.forward();
      //   }
      // });

      _page_left_space=FadeTransition(
        opacity: _curvedAnimationMengcheng!,
        child: XWidgetUtils.getLayoutColumn(
            children:[
              XWidgetUtils.getLayoutExpanded(
                  XWidgetUtils.getLayoutContainer(
                      width: width,
                      backgroundColor: mengcengColor,
                      child:XWidgetUtils.getWidgetGestureDetector(
                          onTap: (){
                            finishPage();
                          }
                      )
                  )
              )
            ]),
      );

      //蒙版动画正方向执行
      _animationControllerMengcheng?.forward();

    }else{
      //替代layout widget
      _page_left_space=replaceWidget;
    }
  }
  void setXRightFixSpace(
      {
        double? width,
        Widget? replaceWidget
      }
      ){
    if(replaceWidget==null){
      //默认空白半透明

      //蒙层颜色(默认透明,多层时避免加深)
      Color mengcengColor=Colors.transparent;
      if (!XTempData.isPageMengcengRightOpen){
        XTempData.isPageMengcengRightOpen=true;
        mengcengColor=XTempData.pageMengcengColor;
        XTempData.mengcengRightOpenPageName=toStringShort();
      }

      //itemWidget实现动画
      _animationControllerMengcheng??= AnimationController(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 50),
        vsync: this,
      );
      _curvedAnimationMengcheng??= CurvedAnimation(parent: _animationControllerMengcheng!, curve: Curves.easeIn);
      // bounceIn = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
      // linear = CurvedAnimation(parent: controller, curve: Curves.linear);
      // decelerate = CurvedAnimation(parent: controller, curve: Curves.decelerate);
      // 也可使用简单的: Tween(begin: 50.0, end: 120.0).animate(animationController500);

      _page_right_space=FadeTransition(
        opacity: _curvedAnimationMengcheng!,
        child: XWidgetUtils.getLayoutColumn(
            children:[
              XWidgetUtils.getLayoutExpanded(
                  XWidgetUtils.getLayoutContainer(
                      width: width,
                      backgroundColor: mengcengColor,
                      child:XWidgetUtils.getWidgetGestureDetector(
                          onTap: (){
                            finishPage();
                          }
                      )
                  )
              )
            ]),
      );
    }else{
      //替代layout widget
      _page_right_space=replaceWidget;
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////
  /*
  监听 App 生命周期(非web),重写方法实现
  注意：didChangeAppLifecycleState 管理的生命周期并不是像 Android 那样页面切换的生命周期，而是监听点击 home、物理返回键、屏幕锁定和解锁
   */
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // The application is not currently visible to the user, not responding to
      // user input, and running in the background.
      // 不可见，不可操作
      XLogUtils.printLog('---监听App生命周期,paused,不可见，不可操作');
    }else if (state == AppLifecycleState.resumed) {
      // The application is visible and responding to user input.
      // 可见，可操作
      XLogUtils.printLog('---监听App生命周期,resumed,可见，可操作');
    }else if (state == AppLifecycleState.inactive) {
      // The application is in an inactive state and is not receiving user input.
      // 可见，不可操作 (过渡时期)
      XLogUtils.printLog('---监听App生命周期,inactive,可见，不可操作 (过渡时期)');
    }else if (state == AppLifecycleState.detached) {
      // The application is still hosted on a flutter engine but is detached from any host views.
      // 虽然还在运行，但已经没有任何存在的界面。
      XLogUtils.printLog('---监听App生命周期,detached,虽然还在运行，但已经没有任何存在的界面');
    }

  }


  //构建页面
  @override
  Widget onBuild(BuildContext context) {
    try {
      //已自带context变量
      //xContext=context;

      //页面左中右结构
      List<Widget> pageRowLayout = [];
      //页面左结构部分
      if (_page_left_space != null) {
        pageRowLayout.add(_page_left_space!);
      }
      //页面中间结构部分
      pageRowLayout.add(_createPageCenterWidget());
      //页面右结构部分
      if (_page_right_space != null) {
        pageRowLayout.add(_page_right_space!);
      }

      //Material是一种标准的移动端和web端的视觉设计语言。 Flutter提供了一套丰富的Material widgets。需要位于MaterialApp内才能正常显示
      return Material(
        // Scaffold 是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性。
        //使用Scaffold是最容易的，它提供了一个默认banner，背景颜色，并且具有添加drawer，snack bar和底部sheet的API
        color: Colors.transparent,
        //Material背景透明
        // Scaffold 是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性。
        //使用Scaffold是最容易的，它提供了一个默认banner，背景颜色，并且具有添加drawer，snack bar和底部sheet的API
        child: XWidgetUtils.getLayoutRow(pageRowLayout), //左中右结构
      );

    }catch(error, stacktrace){
      //第一个参数 error 类型为 Object，也就是异常是可以抛出任意对象。
      //第二个参数 stacktrace，表示异常堆栈。
      XLogUtils.printLog('异常: $error');
      XLogUtils.printLog('异常: $stacktrace');
      return Text('Widget build异常: $error');
    }
  }




//私有方法////////////////////////////////////////////////////////////////////////////

  /*
  Scaffold创建页面中间部分Widget(页面结构左中右)

  设置悬浮按钮显示的位置
FloatingActionButtonLocation.startTop,FloatingActionButtonLocation.miniStartTop 显示在左上角
FloatingActionButtonLocation.endFloat 默认使用 浮动右下角,显示在右下角但是离底部有距离,
FloatingActionButtonLocation.endDocked 显示在右下角紧挨着底部
FloatingActionButtonLocation.centerFloat 底部中间浮动,显示在底部中间但是离底部有距离
FloatingActionButtonLocation.centerDocked 底部中间不浮动,显示在底部中间紧挨着底部
FloatingActionButtonLocation.endTop 显示在右上角

   */
  Widget _createPageCenterWidget(){
    //外层Row,中间部分占满屏幕剩余空间,如果内部itemlayout不重新使用row或Column或UnconstrainedBox去掉父类约束,则默认都会占满可用空间(设置width固定大小无效)
    return XWidgetUtils.getLayoutExpanded(
        Scaffold(
          //标题栏
          appBar: !_isShowTitleBar ? null : _createAppBar(),
          //primary: true,是否在屏幕顶部显示Appbar, 默认为 true，Appbar 是否向上延伸到状态栏，如电池电量，时间那一栏
          //底部栏
          bottomNavigationBar: !_isEnableBottomNavigationBar?null:_createBottomNavigationBar(),
          persistentFooterButtons:null,//在底部导航条bottomNavigationBar上方显示一组按钮
          bottomSheet:null,//底部弹出半屏控件,会在底部导航条bottomNavigationBar上方,BottomSheet
          //左右侧栏
          drawer: !_isEnableDrawer?null:_createDrawer(),
          endDrawer: !_isEnableEndDrawer?null:_createEndDrawer(),
          drawerEdgeDragWidth: 25,//设置可拖拽区域宽度，在区域内才能拖拽出抽屉
          drawerEnableOpenDragGesture: _isEnableDrawer?true:false,//左侧侧滑栏是否可以滑动
          endDrawerEnableOpenDragGesture:_isEnableEndDrawer?true:false,//右侧侧滑栏是否可以滑动
          drawerScrimColor: XTempData.pageMengcengColor,//左右侧栏蒙层颜色,null时为默认半透明
          //drawerDragStartBehavior: DragStartBehavior.start,//处理拖动行为的开始方式，默认是DragStartBehavior.start
          //悬浮按钮
          floatingActionButton: null,//FloatingActionButton
          floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,//悬浮按钮位置
          floatingActionButtonAnimator:FloatingActionButtonAnimator.scaling,//悬浮按钮动画
          //主体body,使用Builder来包装获得Scaffold的context
          body: Builder(builder:(BuildContext context){
            contextOfScaffold=context;
            return _createScaffoldBodyWidget();
          }),
          //extendBody: false,//默认false,如果为true则[body主体]延伸到脚手架的屏幕底部,不是只扩展到[bottomNavigationBar和persistentFooterButtons]的顶部
          //extendBodyBehindAppBar: false, //默认false, 如果为true时，则body会置顶到屏幕顶, 那么appbar会覆盖在body上，如appbar 为半透明色，可以有毛玻璃效果
          //resizeToAvoidBottomInset: true,//默认true,设置键盘弹起时是否会遮挡底部的布局，false则会进行遮挡，true则不会进行遮挡。
          backgroundColor: _pageBackgroundColor ?? const Color(0xfff8f8f8), //Colors.transparent,//Scaffold背景色(页面)
        )
    );
  }

  //Drawer, EndDrawer////////////////////////////////////////////////////////////////////////////

  //是否启用左侧栏
  bool _isEnableDrawer=false;
  //左侧栏宽度
  double _drawerWidth=150;
  //左侧栏背景颜色
  Color? _drawerBackgroundColor;
  Widget? _leftDrawer;
  void setXDrawer(
      Widget leftDrawer,
      {
        bool isEnableDrawer=true,
        Color? backgroundColor,
        double width=150,
      }
      ){

    _isEnableDrawer=isEnableDrawer;
    _drawerBackgroundColor=backgroundColor;
    _drawerWidth=width;
    _leftDrawer=leftDrawer;
  }

  //是否启用右侧栏
  bool _isEnableEndDrawer=false;
  //左侧栏宽度
  double _endDrawerWidth=150;
  //左侧栏背景颜色
  Color? _endDrawerBackgroundColor;
  Widget? _rightDrawer;
  void setXEndDrawer(
      Widget rightDrawer,
      {
        bool isEnableEndDrawer=true,
        Color? backgroundColor,
        double width=150,
      }
      ){

    _isEnableEndDrawer=isEnableEndDrawer;
    _endDrawerBackgroundColor=backgroundColor;
    _endDrawerWidth=width;
    _rightDrawer=rightDrawer;
  }


  //使用Builder来包装获得Scaffold的context
  BuildContext? contextOfScaffold;
  void openDrawer(){
    if(contextOfScaffold!=null){
      XFlutterUtils.openDrawer(contextOfScaffold!);
    }
  }
  void closeDrawer(){
    if(contextOfScaffold!=null){
      XFlutterUtils.closeDrawer(contextOfScaffold!);
    }
  }
  void openEndDrawer(){
    if(contextOfScaffold!=null){
      XFlutterUtils.openEndDrawer(contextOfScaffold!);
    }
  }
  void closeEndDrawer(){
    if(contextOfScaffold!=null){
      XFlutterUtils.closeEndDrawer(contextOfScaffold!);
    }
  }


  //左侧栏
  Drawer _createDrawer(){
    return Drawer(
      backgroundColor: _drawerBackgroundColor,
      width: _drawerWidth,
      child: _leftDrawer,
    );
  }

  //右侧栏
  Drawer _createEndDrawer(){
    return Drawer(
      backgroundColor: _drawerBackgroundColor,
      width: _drawerWidth,
      child: _leftDrawer,
    );
  }


  //创建标题栏
  AppBar _createAppBar(){
    return AppBar(
      toolbarHeight: _titleBarHeight,
      //状态栏颜色
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: _statusBarColor ?? const Color(0xFFffffff),
        statusBarBrightness: _statusBarTextAndIconBrightness ??
            Brightness.dark,
        statusBarIconBrightness: _statusBarTextAndIconBrightness ??
            Brightness.dark,
      ),
      //标题文字
      title: Text(
        _titleBarCenterText ?? '',
        style: const TextStyle(
            color: Color(0xFF000000),
            fontSize: 16
        ),
      ),
      //标题居中显示
      centerTitle: _isShowTitleBarTitleTextCenter,
      //背景颜色
      backgroundColor: _titleBarBackgroundColor,
      //分割线阴影颜色
      shadowColor: const Color(0xFFbdbdbd),
      //影深(标题栏分割线阴影高度)
      elevation: _isShowTitleBarBottomDivider ? 1 : 0,
      //支持tabBar(判断是否在appBar中)
      bottom: (_isEnableTabBar && _isTabBarInAppBar)
          ? PreferredSize(
        preferredSize: Size.fromHeight(_tabBarHeight),
        child: XWidgetUtils.getLayoutContainer(
          //是否居中显示,否则靠左
          child: _isTabBarAlignCenter?Center(child: _createTabBar()):_createTabBar(),
          backgroundColor: _tabBarBackgroundColor,
          height: _tabBarHeight,
          width: double.infinity,
        ), //创建tabBar
      )
          : null,//bottom
      leading: !_isShowTitleBarLeftWidget
          ? null
          : _titleBarLeftWidget ?? IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF333333),
        ),
        onPressed: () {
          //返回上一页
          finishPage();
        },
      ),
      //左边按钮Widget, ImageIcon()
      actions: _titleBarRightWidgets, //右边按钮Widget
    );
  }

//创建Scaffold的body,支持tabBar/bottomNavigationBar,支持自定义topBar和bottomBar
// Widget _createScaffoldBodyWidget(){
//   //判断tabBar是否在body中
//   return (_isEnableTabBar && !_isTabBarInAppBar) ?
//   XWidgetUtils.getLayoutColumn([
//     //tabBar
//     XWidgetUtils.getLayoutContainer(
//       //是否居中显示,否则靠左
//       child: _isTabBarAlignCenter?Center(child: _createTabBar()):_createTabBar(),
//       height: _tabBarHeight,
//       width: double.infinity,
//       color: _tabBarBackgroundColor,
//     ),
//     //tabBarView
//     XWidgetUtils.getLayoutExpanded(_createTabBarView())
//   ])
//   //tabBar不在body中,判断是否启用tabBar(即在appBar中,则创建TabBarView)
//       : _isEnableTabBar ? _createTabBarView()
//   //没有启用tabBar,判断是否启用BottomNavigationBar
//       : _isEnableBottomNavigationBar?_createBottomNavigationBarView()
//   //没有启用BottomNavigationBar(普通页面)
//       :getBodyWidget();
// }

  Widget _createScaffoldBodyWidget(){

    //页面上中下结构
    List<Widget> columnLayout = [];

    //topBar
    if (_page_topbar_widget != null) {
      columnLayout.add(_page_topbar_widget!);
    }

    if(_isEnableTabBar) {
      //启用tabBar

      if (_isTabBarInAppBar) {
        //tabBar在AppBar中,直接添加TabBarView
        columnLayout.add(XWidgetUtils.getLayoutExpanded(_createTabBarView()));

      } else {
        //tabBar不在AppBar中
        //添加tabBar
        columnLayout.add(
            XWidgetUtils.getLayoutContainer(
              //是否居中显示,否则靠左
              child: _isTabBarAlignCenter
                  ? Center(child: _createTabBar())
                  : _createTabBar(),
              height: _tabBarHeight,
              width: double.infinity,
              backgroundColor: _tabBarBackgroundColor,
            ));
        //添加tabBarView
        columnLayout.add(XWidgetUtils.getLayoutExpanded(_createTabBarView()));
      }

    }else if(_isEnableBottomNavigationBar){
      //启用BottomNavigationBar
      columnLayout.add(XWidgetUtils.getLayoutExpanded(_createBottomNavigationBarView()));
    }else{
      //没有启用TabBar和BottomNavigationBar
      columnLayout.add(XWidgetUtils.getLayoutExpanded(getBodyWidget()));
    }

    //bottomBar
    if (_page_bottombar_widget != null) {
      columnLayout.add(_page_bottombar_widget!);
    }

    return XWidgetUtils.getLayoutColumn(children:columnLayout);

  }

//创建BottomNavigationBarView
  Widget _createBottomNavigationBarView(){

    if(_isLoadAllPagesForBottomNavigationBar){
      //IndexedStack,初始化所有页面,不需要设置super.isKeepPageState,自动缓存所有页面的状态
      //IndexedStack没有过渡动画
      return IndexedStack(
        index: _bottomNavigationBarIndex,
        children: _listBottomNavigationItems.map((XBeanMenuItem menuItem) {
          return getBodyWidget(menuItem: menuItem);
        }).toList(),
      );

    }else{
      //只初始当前页面的索引页,后期点击每个item显示时再加载,页面缓存状态需要设置super.isKeepPageState=true
      // return PageView(
      //   ///禁止左右滑动
      //   physics: const NeverScrollableScrollPhysics(),
      //   controller: _bottomNavigationBarPageController,
      //   children: _listBottomNavigationItems.map((XBeanMenuItem menuItem) {
      //     return getBodyWidget(menuItem: menuItem);
      //   }).toList(),
      // );
      //PageView有过渡动画,实测使用此切换动画更流畅
      return PageView.builder(
        //禁止左右滑动
        physics: const NeverScrollableScrollPhysics(),
        //允许左右滑动时,监听滑动切换,更新bottomNavigationBar的按钮当前位置
        // onPageChanged: (index){
        //   setState(() {
        //     if (_bottomNavigationBarIndex != index) {
        //       _bottomNavigationBarIndex = index;
        //     }
        //   });
        // },
        itemBuilder: (context, index) {
          return getBodyWidget(menuItem: _listBottomNavigationItems[index]);
        },
        itemCount: _listBottomNavigationItems.length,
        controller: _bottomNavigationBarPageController,
      );

    }

  }



  //跳转页面////////////////////////////////////////////////////////////////////////

  //获得上一界面传递的数据(RouteSettings.arguments)
  dynamic getPrePageDataFromRouteSettings(){
    //final Map<String,dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    return XFlutterUtils.getPrePageDataFromRouteSettings(context);
  }

  //返回上一页
  void finishPage(
      {
        dynamic result,
        String? backToPointPageName,//指定返回界面:   返回首页'/'
      }
      ) {

    //蒙层动画正方向运行
    //_animationControllerMengcheng?.forward();
    //蒙层动画反方向运行
    _animationControllerMengcheng?.reverse();

    //
    XFlutterUtils.finishPage(context,result: result, backToPointPageName: backToPointPageName);
  }


  ////////////////////////

  void toast(String msg){
    XToastUtils.toast(context: context, msg: msg);
  }



}