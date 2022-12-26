
import 'package:flutter/material.dart';
import 'package:xsdk_flutter_package/xsdk/framework/bean/x_bean_data_table.dart';
import 'package:xsdk_flutter_package/xsdk/framework/bean/x_bean_group_list_item.dart';
import 'package:xsdk_flutter_package/xsdk/framework/callback/x_function.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_log.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_string.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_style.dart';

/*
阴影效果:
shadows: [
  Shadow(
    color: Colors.cyanAccent,
    offset:Offset(1,1),
    blurRadius: 10,
  ),
  Shadow(
    color: Colors.blue,
    offset:Offset(1,1),
    blurRadius: 10,
  ),
],
 */


/*
  Overlay //浮窗
  IgnorePointer //忽略点击事件，不影响下层的点击事件
  AbsorbPointer //消费掉点击事件，下层也收不到，不会做出相应
   */

//工具类使用abstract定义时,写代码时不会提示创建实例选项
abstract class XWidgetUtils{

/*
EdgeInsets是属性值,
与Padding区别: Padding是widget
 */
  static EdgeInsets getEdgeInsets(
      double left,
      double top,
      double right,
      double bottom
      )
  {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  /*
  BoxDecoration  Widget(layout)的装饰，使其改变其显示形式
  用于设置布局/控件的圆角,边框,阴影,形状,背景色,背景图等
  如: Container布局结合使用
  https://www.jianshu.com/p/ba7eb561ba17

  阴影
  boxShadow: [
  BoxShadow(
    offset: Offset(6, 7), // 阴影的偏移量
    color: Color.fromRGBO(16, 20, 188, 1), // 阴影的颜色
    blurRadius: 5, // 阴影的模糊程度
    spreadRadius: 0, // 扩散的程度，如果设置成正数，则会扩大阴影面积；负数的话，则会缩小阴影面积
  )
]


  背景色设置为渐变色
  BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFffffff), Color(0xFFEC592F)]),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)))
   */
  static BoxDecoration getBoxDecoration(
      {
        Border? border,//边框 ,如:Border.all()
        BorderRadius? borderRadius,//设置全圆角: BorderRadius.all(Radius.circular(10)), 单侧圆角BorderRadius.only(topLeft: Radius.circular(64)),
        BoxShape shape=BoxShape.rectangle,// 形状:默认矩形   ,圆形BoxShape.circle
        Color? backgroundColor,//背景色,注意:在这里设置背景色,就不能在Container中设置背景色,否则会报错
      }
      ){
    return BoxDecoration(
      border: border,
      borderRadius: borderRadius,
      shape: shape,
      color:backgroundColor,
      /*
      渐变
      gradient: RadialGradient( // 圆形渐变，从中心开始渐变
  colors: [
    Color.fromRGBO(7, 102, 255, 1),
    Color.fromRGBO(3, 28, 128, 1)
  ]
),
线性渐变:
gradient: LinearGradient( // 线性渐变，如果没有指定开始和结束的地方，则默认从左边到右边
  colors: [
    Color.fromRGBO(7, 102, 255, 1),
    Color.fromRGBO(3, 28, 128, 1)
  ],
  begin: Alignment.topCenter, // 开始
  end: Alignment.bottomCenter, // 结束
),
       */
    );
  }


  //布局Layout////////////////////////////////////////////////////////////////

/*
Container布局(最基本的布局),可让您创建矩形视觉元素。
可以使用如 background、一个边框、或者一个阴影,边距（margins）、填充(padding)和应用于其大小的约束(constraints)。
参数:
    width:null,则不限宽度,占满父控件,单位:dp
    height:null,同上,单位:dp
    背景:decoration(支持颜色,图片)和color(背景色)只能设置一个,注意:如果2个同时设置会报错;
new Container(
      height: 56.0, // 单位是逻辑上的像素（并非真实的像素，类似于浏览器中的像素）
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: new BoxDecoration(color: Colors.blue[500]),
      // Row 是水平方向的线性布局（linear layout）
      child: new Row(
        //列表项的类型是 <Widget>
        children: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null, // null 会禁用 button
          ),
          // Expanded expands its child to fill the available space.
          new Expanded(
            child: new Text('Expanded'),
          ),
          new IconButton(
            icon: new Icon(Icons.search),
            tooltip: 'Search',
            onPressed: (){
               ...
            },
          ),
        ],
      ),
    );


注意:Container+Column+Expanded会提示超过屏幕可视高度区域;因此需要改为Column+Expanded+Container
注意:如果外层是Expanded,如果内部itemlayout不重新使用row或Column或UnconstrainedBox去掉父类约束,
则默认都会占满可用空间(设置width固定大小无效)double.infinity
 */
  static Container getLayoutContainer(
      {
        Widget? child,
        double? width,//注意:不能设置占满double.infinity,否则报错
        double? height,//注意:不能设置占满double.infinity,否则报错
        EdgeInsets? margin,//getEdgeInsets(left,top,right,bottom)
        EdgeInsets? padding,//getEdgeInsets(left,top,right,bottom)
        BoxDecoration? decoration, //用于设置布局/控件的圆角,边框,阴影,形状,背景色,背景图等
        Color? backgroundColor,//简单实现背景色
      }
      )
  {
    //注意:背景色:不能同时在decoration中设置和在Container设置,否则会报错
    if(decoration!=null && decoration.color!=null){
      backgroundColor=null;
    }

    return Container(
      key: UniqueKey(),
      width: width,
      height: height, // 单位是逻辑上的像素（并非真实的像素，类似于浏览器中的像素）
      margin: margin,
      padding: padding,
      decoration: decoration,//用于设置布局/控件的圆角,边框,阴影,形状,背景色,背景图等
      color: backgroundColor,//注意:在这里设置背景色,就不能在decoration中设置背景色,否则会报错,因此同其他布局一样吗,不在布局中设置背景色
      child: child,
    );
  }


  /*
  常用布局,带圆角布局(简便),替代Container+BoxDecoration方式
   */
  static ClipRRect getLayoutClipRRect(
      Widget child,
      {
        double radius=10,//圆角大小
      }
      ){
    return ClipRRect(
      borderRadius: radius<=0?BorderRadius.zero:BorderRadius.all(Radius.circular(radius)),
      child: child,
    );
  }

  /*
  Row 是水平方向的线性布局（linearlayout横向排列）
   */
  static Row getLayoutRow(
      List<Widget> children) {
    return Row(
      children: children,
    );
  }

  /*
上下排列图标文字
static Column getIconText(
      IconData icon,
      Color iconColor,
      String label,
      TextStyle textStyle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: textStyle,
          ),
        ),
      ],
    );
  }
 */
  /*
  Column为竖直方向的线程布局,如list列(linearlayout竖向排列)
   */
  static Column getLayoutColumn(
      {
        required List<Widget> children,
        MainAxisAlignment mainAxisAlignment=MainAxisAlignment.start,
        MainAxisSize mainAxisSize=MainAxisSize.max,
      }
      ) {
    return Column(
      mainAxisAlignment:mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }

  /*
  自动占满剩余横向或竖向可用空间的布局,
  注意:直接外层需要嵌套(只能是)Row、Column
   */
  static Expanded getLayoutExpanded(
      Widget child,
      ){
    return Expanded(
      child: child,
    );
  }

  static Padding getLayoutPadding(
      {
        required EdgeInsets padding,//getEdgeInsets(left,top,right,bottom)
        required Widget child
      }
      ){
    return Padding(
      padding: padding,
      child: child,
    );
  }

  //带动画效果的Padding
  static AnimatedPadding getLayoutAnimatedPadding(
      EdgeInsets padding,//getEdgeInsets(left,top,right,bottom)
      Duration duration, //动画时间Duration(milliseconds: 1000)
      Widget child,
      {void Function()? onEndCallback} //动画结束回调  () {print("动画结束时的回调");}
      ){
    return AnimatedPadding(
      padding: padding,
      duration: duration,
      curve: Curves.easeInOut,
      onEnd: onEndCallback,
      child: child,
    );
  }


  //对齐适应大小布局////////////////////////////////////////////////////////////////
  /*
  FittedBox 对齐+适应 会在自己的尺寸范围内调整child尺寸使其适合大小,
  一般需要在其外层再套一个可以设定大小的布局以确定FittedBox自己的大小
  使用情景,类似android的imageView
   */
  static FittedBox getLayoutFittedBox(
      Widget child,
      {
        /*
        缩放方式:
        contain: child保持其宽高比,在FittedBox范围内尽可能的大，宽度或者高度达到布局边界范围最大值时，就会停止缩放,不超出其尺寸;
         none: 不缩放,超出范围默认截取;
         fill: child不按原比例缩放填满布局大小;
         cover: child按原大小填满布局,不缩放, 超过范围则截取;
        fitWidth:  child按原比例缩放,填满布局宽度最大值, 高度超出则截取;
        fitHeight: child按原比例缩放,填满布局高度最大值, 宽度超出则截取;
         */
        BoxFit fit=BoxFit.contain,
        //对齐方式: topLeft...
        Alignment alignment=Alignment.center,
      }
      ){
    return FittedBox(
      fit: fit, //缩放方式
      alignment: alignment,//对齐方式
      child: child,
    );
  }

  /*
  AspectRatio适用于需要固定宽高比的情景,可设置宽度比例,
  一般需要在其外层再套一个可以设定宽高的布局以确定AspectRatio自己的大小
   */
  static AspectRatio getLayoutAspectRatio(
      Widget child,
      double aspectRatio //宽高比,必须>0,不能为null,必须有限大小
      ){

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: child,
    );

  }

  //SizedBox：用于给子元素指定固定的宽高 (也可用Container替代),有可作为space
  static SizedBox getLayoutSizedBox(
      Widget child,
      {
        double? width, //注意:不能设置占满double.infinity,否则报错
        double? height,//注意:不能设置占满double.infinity,否则报错
      }
      ){
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }

  //约束限制大小布局////////////////////////////////////////////////////////////////
  /*
  1.ConstrainedBox 用于对子组件添加额外的约束。例如，如果你想让子组件的最小高度是 80 像素
  2.SizedBox：用于给子元素指定固定的宽高
  3.UnconstrainedBox：不会对子组件产生任何限制，它允许其子组件按照其本身大小绘制,一般用来去掉父约束
   */
  static ConstrainedBox getLayoutConstrainedBox(
      Widget child,
      {
        double minWidth=0.0,
        double maxWidth= double.infinity,
        double minHeight=0.0,
        double maxHeight= double.infinity,
      }
      ){
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth:minWidth,
        maxWidth:maxWidth,
        minHeight:minHeight,
        maxHeight:maxHeight,
      ),
      child: child,
    );
  }
  //UnconstrainedBox：不会对子组件产生任何限制，它允许其子组件按照其本身大小绘制,一般用来去掉父约束
  static UnconstrainedBox getLayoutUnconstrainedBox(
      Widget child,
      {
        double minWidth=0.0,
        double maxWidth= double.infinity,
        double minHeight=0.0,
        double maxHeight= double.infinity,
      }
      ){
    return UnconstrainedBox(
      child: child,
    );
  }



  //卡片
  static Card getLayoutCard(
      {
        required Widget child,
        Color? backgroundColor,//背景色
        Color? shadowColor,//阴影颜色
        double? elevation, //阴影高度
        ShapeBorder? shape, //形状,RoundedRectangleBorder,CircleBorder
        EdgeInsets? margin,//外边距
      }
      ){
    return Card(
      color: backgroundColor,
      shadowColor: shadowColor,
      elevation: elevation,
      shape: shape,
      margin: margin,
      child: child,
    );
  }

  /*
  显示/隐藏(不推荐,用Visibility替代)
  Offstage: 隐藏不会占位，显示隐藏widget都会加载
  Offstage不能保存组件的状态，组件重新加载,当Offstage不可见时，如果child有动画等，需要手动停掉，Offstage并不会停掉动画等操作
   */
  static Offstage getLayoutOffstage(
      {
        required Widget child,
        bool isVisible=true,
      }
      ){
    return Offstage(
      offstage: isVisible,
      child: child,
    );
  }

  /*
  显示/隐藏(推荐)
  Visibility: 隐藏可选择是否占位; 如不占位隐藏时Widget不会加载，如占位，显示/隐藏Widget都会加载
   */
  static Visibility getLayoutVisibility(
      {
        required Widget child,
        bool isVisible=true,
        bool isGone=false,//是否占位
      }
      ){
    return Visibility(
      visible: isVisible,
      //隐藏需要占位，前俩个maintainState和maintainSize需要为true,不需要时都为false,maintainState影响是否加载
      maintainState: isGone,
      maintainSize: isGone,
      maintainAnimation: true,
      child: child,
    );
  }


//相对定位布局////////////////////////////////////////////////////////////////


  //居中(Container(width:double.infinity)+Center) 等同Align的 Alignment.center
  static Center getLayoutCenter(
      Widget child
      ){
    return Center(child:child);
  }

  static Align getLayoutAlign(
      {
        Widget? child,
        Alignment alignment=Alignment.center,//对齐方式
      }
      ){
    return Align(
      alignment: alignment,
      child: child,
    );
  }


//绝对定位布局////////////////////////////////////////////////////////////////
/*
  Stack层叠布局(类似Android的Frame布局)，子组件可以堆叠;
  结合Positioned绝对定位布局使用（根据Stack的四个角定位）.
  Stack(
            children: [
              Positioned(
                left: 0,
                top: 10,
                child: XWidgetUtils.getWidgetText('hello world hello worldhello worldhello worldhello worldhello worldhello worldhello world'),
              ),
              Positioned(
                left: 20,
                top: 10,
                child: XWidgetUtils.getWidgetText('我要忘了你的样子我要忘了你的样子我要忘了你的样子我要忘了你的样子我要忘了你的样子'),
              )
            ],
          )
   */
  static Stack getLayoutStack(
      List<Widget> children
      ){
    return Stack(
//此参数决定如何去对齐没有定位（没有使用Positioned）或部分定位的子widget。
//所谓部分定位，在这里特指没有在某一个轴上定位：left、right为横轴，top、bottom为纵轴，只要包含某个轴上的一个定位属性就算在该轴上有定位。
      alignment: AlignmentDirectional.topStart,
      textDirection: TextDirection.ltr,
//设置没有定位的子widget如何去适应Stack的大小。StackFit.loose表示使用子widget的大小，StackFit.expand表示扩伸到Stack的大小。
      fit: StackFit.loose,
//超出Stack显示空间的子widget，值为hardEdge时，超出部分会被剪裁（隐藏）
      clipBehavior: Clip.hardEdge,
      children: children,
    );
  }

/*
  绝对定位布局,集合Stack布局使用
  Positioned参数:
  left、top 、right、 bottom分别代表离Stack左、上、右、底四边的距离。
  width和height用于指定定位元素的宽度和高度，
  注意，此处的width、height 和其它地方的意义稍微有点区别，此处用于配合left、top 、right、 bottom来定位widget，
  例:在水平方向时，你只能指定left、right、width三个属性中的两个，如指定left和width后，right会自动算出(left+width)，
  如果同时指定三个属性则会报错，垂直方向同理。
   */
  Positioned getLayoutPositioned(
      {
        double? left,
        double? top,
        double? right,
        double? bottom,
        double? width,
        double? height,
        required Widget child,
      }

      ){
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }


//widget/////////////////////////////////////////////

/*
  ListView列表
  ListView(
        padding: EdgeInsets.symmetric(horizontal: 5),
        children: data.map((color) => Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 50,
                  color: color,
                  child: Text(
                    colorString(color),
                    style: TextStyle(color: Colors.white, shadows: [
                      Shadow(
                          color: Colors.black,
                          offset: Offset(.5, .5),
                          blurRadius: 2)
                    ]),
                  ),
                ))
            .toList(),
      )
   */
  static ListView getWidgetListView(
      {
        required List<dynamic> listData,
        required IndexedWidgetBuilder listItemWidgetFunction,
        Axis scrollDirection=Axis.vertical,//滚动方向
        EdgeInsets? padding, //内边距
        //shrinkWrap: 该属性将决定列表的长度是否仅包裹其内容的长度。当ListView嵌在一个无限长的容器组件中时，shrinkWrap必须为true，否则Flutter会给出警告；
        bool shrinkWrap=false,
      }
      ){
    return ListView.builder(
      scrollDirection: scrollDirection,
      padding: padding,
      itemBuilder: listItemWidgetFunction,
      itemCount: listData.length,
      shrinkWrap: shrinkWrap,
      //itemExtent: 每条item的高度,设置item的固定高度，有助于提高列表的渲染速度
      //keyboardDismissBehavior: 键盘关闭模式
      //controller: 列表滚动控制器
    );
  }

  /*
  动画listview
  实测:不支持Dismissible搭配(Dismissible删除ui后没有方法通知到AnimatedList的item的position改变)
   */
  static AnimatedList getWidgetAnimatedList(
      {
        required GlobalKey<AnimatedListState> key,//在page中初始化传入即可:final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
        required List<dynamic> listData,
        required AnimatedListItemBuilder listItemWidgetFunction,
        Axis scrollDirection=Axis.vertical,//滚动方向
        EdgeInsets? padding, //内边距
      }
      ) {
    return AnimatedList(
      key: key,
      initialItemCount: listData.length,
      itemBuilder: listItemWidgetFunction,
      padding: padding,
      scrollDirection: scrollDirection,
      //primary: ,//这是否是与父控件PrimaryScrollController相关联的主滚动视图。
      //controller: ,//控制滚动到的位置
      //physics 滑动效果控制 ，BouncingScrollPhysics 是列表滑动 iOS 的回弹效果；AlwaysScrollableScrollPhysics 是 列表滑动 Android 的水波纹回弹效果；ClampingScrollPhysics 普通的滑动效果
    );
  }


  //拖拽item的listView, 实测:不支持Dismissible搭配(Dismissible删除ui后没有方法通知到ReorderableListView的item的position改变)
  static ReorderableListView getWidgetReorderableListView(
      {
        required List<dynamic> listData,
        required IndexedWidgetBuilder listItemWidgetFunction,
        required ReorderCallback onReorder,//拖拽位置变动
        Axis scrollDirection=Axis.vertical,//滚动方向
        EdgeInsets? padding, //内边距
      }
      ) {
    return ReorderableListView.builder(
      key: UniqueKey(),
      scrollDirection: scrollDirection,
      padding: padding,
      itemBuilder: listItemWidgetFunction,
      itemCount: listData.length,
      onReorder:onReorder,//拖拽位置变动
    );
  }


  /*
  分组ListView(注意:分组item要是XBeanExpansionItem类型)
  ExpansionPanelList/ExpansionPanel：实现多个展开或1个展开,在item中的isExpanded决定,需要在回调中setState())
  注意事项：
  ExpansionPanelList必须在可滚动组件中，例如SingleChildScrollView
  ExpansionPanel内加入子ListView的时候需要设置shrinkWrap: true不然是无法显示的，因为ExpansionPanel自己也是个高度无法确定的组件
   */
  static Widget getWidgetExpansionPanelList(
      {
        required List<dynamic> listData,
        //分组头widget
        required XFunctionGroupItemWidget<dynamic> groupItemWidgetFunction,
        //子widget(这里已listview作为子widget,适配多个或1个item)
        required XFunctionListItemWidget<dynamic> listItemWidgetFunction,
        //展示隐藏点击回调,需要通知更新数据
        // expansionCallback: (int panelIndex, bool isExpanded){
        //   setState(() {
        //   XBeanExpansionItem item= itemData[panelIndex] as XBeanExpansionItem;
        //     item.isExpanded = !isExpanded;
        //   });
        // },
        required ExpansionPanelCallback expansionCallback,
        Color? backgroundColor,
      }
      ) {
    return SingleChildScrollView(
      child: getLayoutContainer(
        backgroundColor: backgroundColor,
        child: ExpansionPanelList(
          expansionCallback:expansionCallback,
          animationDuration: const Duration(milliseconds: 200),
          children: listData.map((dynamic listDataItem){
            XBeanExpansionItem item= listDataItem as XBeanExpansionItem;

            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded){
                return groupItemWidgetFunction(item.groupItem,isExpanded);
              },
              //这里使用listview,已设置shrinkWrap=true,适配多个或1个子item
              body: getWidgetListView(
                listData: item.itemList,
                listItemWidgetFunction: (BuildContext context, int index){
                  return listItemWidgetFunction(item.itemList[index],index);
                },
                shrinkWrap:true,
              ),
              canTapOnHeader: true,
              isExpanded:item.isExpanded,
              backgroundColor: item.backgroundColor,
            );
          }).toList(),
        ),
      ),
    );
  }

  /*
  分组ListView(注意:分组item要是XBeanExpansionItem类型)
  ExpansionPanelList.radio/ExpansionPanelRadio：只有1个展开,自动更新ui,不需要在回调中setState()
  ExpansionTile：扩展面板
   */
  static Widget getWidgetExpansionPanelRadioList(
      {
        required List<dynamic> listData,
        //分组头widget
        required XFunctionGroupItemWidget<dynamic> groupItemWidgetFunction,
        //子widget(这里已listview作为子widget,适配多个或1个item)
        required XFunctionListItemWidget<dynamic> listItemWidgetFunction,
        //初始化展开的item,可不设置
        dynamic initialOpenPanelValue,
        Color? backgroundColor,
      }
      ) {
    return SingleChildScrollView(
      child: getLayoutContainer(
        backgroundColor: backgroundColor,
        child: ExpansionPanelList.radio(
          initialOpenPanelValue: initialOpenPanelValue,
          animationDuration: const Duration(milliseconds: 200),
          children: listData.map((dynamic listDataItem){
            XBeanExpansionItem item= listDataItem as XBeanExpansionItem;

            return ExpansionPanelRadio(
              value: item,
              headerBuilder: (BuildContext context, bool isExpanded){
                return groupItemWidgetFunction(item.groupItem,isExpanded);
              },
              //这里使用listview,已设置shrinkWrap=true,适配多个或1个子item
              body: getWidgetListView(
                listData: item.itemList,
                listItemWidgetFunction: (BuildContext context, int index){
                  return listItemWidgetFunction(item.itemList[index],index);
                },
                shrinkWrap:true,
              ),
              canTapOnHeader: true,
              backgroundColor: item.backgroundColor,
            );
          }).toList(),
        ),
      ),
    );
  }


  /*
  GridView 网格布局
  //静态布局
  return new GridView.extent(
        maxCrossAxisExtent: 150.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: list.map((var item){
          return showGridViewItem(item);
        }).toList()
    );
    return GridView.count(
      scrollDirection: scrollDirection,
      padding: padding,
      crossAxisCount: crossAxisCount,
      //childAspectRatio: , //设置宽高的比例,GridView的子组件直接设置宽高没有反应，可以通过childAspectRatio修改宽高
      children: children,
    );
   */
  static GridView getWidgetGridView(

      {
        required int crossAxisCount, //列数
        required List<dynamic> listData,
        required IndexedWidgetBuilder listItemWidgetFunction,
        Axis scrollDirection=Axis.vertical,//滚动方向
        EdgeInsets? padding, //内边距
      }
      ){
    //动态
    return GridView.builder(
      itemCount: listData.length,
      scrollDirection: scrollDirection,
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(//网格代理：定交叉轴数目
        crossAxisCount: crossAxisCount,//列数
        //childAspectRatio:1/0.618, //比例
      ),
      itemBuilder: listItemWidgetFunction,
    );

  }

  /*
  https://www.jianshu.com/p/07999c8157d7
  SliverAppBar
  SliverList
  SliverGrid

   */

  /*
  DataTable控件显示表格数据,与Gridview类似,但它是用来显示行数据,超出屏幕宽度,可左右滑动
   */
  static DataTable getLayoutDataTable(
      {
        //列标签
        required List<XBeanDataTableLabel> columnsLabels,
        //行数据
        required List<DataRow> rows,
        //注意DataTable本身不能对数据进行排序，这些参数仅仅是外观上的控制
        int? sortColumnIndex,//设置显示当前排序图标的列(外部传入)
        bool sortAscending=false,//当前排序顺序,默认降序排列(外部传入)
      }
      ){
    return DataTable(
      columns: columnsLabels.map((XBeanDataTableLabel label){
        return DataColumn(
          label: XWidgetUtils.getWidgetText(label.text,style: label.style),
          //长按提示
          tooltip: label.tooltip,
          //是否靠右对齐
          numeric: !label.isAlignLeft,
          onSort: label.onSort,
        );
      }).toList(),
      //行数据
      rows: rows,
      //默认降序
      sortAscending: sortAscending,
      //显示排序图标
      sortColumnIndex: sortColumnIndex,
    );
  }

  /*
  流式布局:
  Wrap({
    Key key,
    this.direction = Axis.horizontal,   //排列方向，默认水平方向排列
    this.alignment = WrapAlignment.start,  //子控件在主轴上的对齐方式
    this.spacing = 0.0,  //主轴上子控件中间的间距
    this.runAlignment = WrapAlignment.start,  //子控件在交叉轴上的对齐方式
    this.runSpacing = 0.0,  //交叉轴上子控件之间的间距
    this.crossAxisAlignment = WrapCrossAlignment.start,   //交叉轴上子控件的对齐方式
    this.textDirection,   //textDirection水平方向上子控件的起始位置
    this.verticalDirection = VerticalDirection.down,  //垂直方向上子控件的其实位置
    List<Widget> children = const <Widget>[],   //要显示的子控件集合
  })
  另外一个Flow
  https://www.jianshu.com/p/83f4da35da17
  https://zhuanlan.zhihu.com/p/360229936
  https://blog.csdn.net/chuyouyinghe/article/details/120050050
   */
//   static Wrap getWidgetWrap(
//       List<dynamic> itemData,
//       IndexedWidgetBuilder listItemWidgetFunction,
//       {
//         Axis scrollDirection=Axis.vertical,//滚动方向
//         EdgeInsets? padding, //内边距
//       }
//
//       ){
//     return Wrap(
//       children: [],
//     );
//
//   }


  //进度条
  //LinearProgressIndicator
  //CircularProgressIndicator

//分割线
  static Divider getWidgetDivider(
      {
        Color color=const Color(0xffbdbdbd),
        double height=0, //默认自动设为设备1像素值
        double marginLeft=10,
        double marginRight=10,
      }
      ) {

    if(height<0){
      height=0;
    }

    return Divider(
      height: height,//上下空间
      thickness: height, //厚度
      color: color,//颜色
      indent: marginLeft,//距左边间距
      endIndent: marginRight,//距右边间距
    );
  }


  /*
  Checkbox 多选(勾选)
  onChanged:(bool? value) {
          setState(() {
            isCurrentSelect = value!;
          }),
   */
  static Checkbox getWidgetCheckbox(
      {
        required bool isCurrentSelect,
        required ValueChanged<bool?>? onChanged,
      }

      ){
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(_getColor),
      value: isCurrentSelect,
      onChanged: onChanged,
    );
  }

  //选中和未选颜色
  static Color _getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  /*
  Radio(单选)
  currentSelectValue在外面传入的值(默认值)

  注意:要在onChanged()方法中,要使用setState更新当前选择值currentSelectValue
  (value){
    setState(() {
                currentSelectValue=value;
              });
    print('$value')
  }

  使用(多个单选):
  XWidgetUtils.getWidgetRadio(
            currentSelectValue: currentSelectValue,
            labelValue: 'a',
            onChanged: (value){
              setState(() {
                currentSelectValue=value;
              });
              XLogUtils.printLog('$value');
            }),
  XWidgetUtils.getWidgetRadio(
            currentSelectValue: currentSelectValue,
            labelValue: 'b',
            onChanged: (value){
              setState(() {
                currentSelectValue=value;
              });
              XLogUtils.printLog('$value');
            }),
   */
  static Widget getWidgetRadio(
      {
        required String? currentSelectValue,
        required String labelValue,
        required ValueChanged<String?>? onChanged,
        TextStyle? textStyle,
      }
      ){
    return getLayoutRow([
      Radio<String>(
        groupValue: currentSelectValue,
        value: labelValue,
        onChanged: onChanged,
      ),
      getWidgetText(
          labelValue,
          style: textStyle
      ),
    ]);
  }

  /*
  Switch 开关
  currentValue当前值,外面传入
  注意:要在onChanged()方法中,要使用setState更新当前选择值currentSelectValue
  (value){
    setState(() {
                currentValue=value;
              });
    print('$value')

    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber;
        }
        // Otherwise return null to set default track color
        // for remaining states such as when the switch is
        // hovered, focused, or disabled.
        return null;
      },
    );
    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber.withOpacity(0.54);
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }
        // Otherwise return null to set default material color
        // for remaining states such as when the switch is
        // hovered, or focused.
        return null;
      },
    );
  }
   */
  static Switch getWidgetSwitch(
      {
        required bool currentValue,
        required ValueChanged<bool>? onChanged,
        MaterialStateProperty<Color?>? overlayColor,
        MaterialStateProperty<Color?>? trackColor,
        //MaterialStateProperty.all<Color>(Colors.black)
        MaterialStateProperty<Color?>? thumbColor,
      }
      ){
    return Switch(
      value: currentValue,
      onChanged: onChanged,
      overlayColor: overlayColor,
      trackColor: trackColor,
      thumbColor: thumbColor,
    );
  }


  /*
  Slider 滑块
   */
  static Slider getWidgetSlider(
      {
        required double currentValue,
        required ValueChanged<double>? onChanged,
      }
      ){
    return Slider(
      value: currentValue,
      onChanged: onChanged,
    );
  }

  /*
  Stepper 步骤条
  Stepper必须在滑动组中,如SingleChildScrollView

  Step 属性	介绍
  title	@required 标题控件
  subtitle	副标题控件
  content	@required 内容控件
  state	当前 step 的状态，StepState 会改变每一个 step 的图标，默认为 StepState.indexed
  isActive	是否激活状态，默认为 false，isActive == true 时会变成蓝色

  Stepper(

          controlsBuilder: (BuildContext context, {VoidCallback? onStepContinue, VoidCallback? onStepCancel}){
            return Row(
              children: [
                TextButton(
                  child: Text('批准',style: tsct,),
                  onPressed: onStepContinue,
                ),
                TextButton(
                  child: Text('截断',style: tsce,),
                  onPressed: onStepCancel,
                ),
              ],
            );
          },
          currentStep: _currentStep,
          onStepContinue: (){
            if(_currentStep<4)
              setState(() {
                stlist[_currentStep]=StepState.complete;
                _currentStep++;
              });
            else
              setState(() {
                stlist[_currentStep]=StepState.complete;
                _currentStep=4;
              });
          },
          steps: [
            Step(
              title: Text('2021-07-24'),
              subtitle: Text('李亚彤老师'),
              state: stlist[0],
              content: Text('使用多媒体教室108'),
            ),
            Step(
                title: Text('2021-07-25'),
                subtitle: Text('张利荣老师'),
                state: stlist[1],
                content: Text('通过')
            ),
          ],
        ),
   */
  static Widget getWidgetStepper(
      {
        required List<Step> steps,
        int currentStep=0,
        ControlsWidgetBuilder? controlsBuilder,
        StepperType type=StepperType.vertical,
        ValueChanged<int>? onStepTapped,
        VoidCallback? onStepContinue,
        VoidCallback? onStepCancel,
        Color? backgroundColor,
      }
      ){
    return SingleChildScrollView(
        child: getLayoutContainer(
            backgroundColor: backgroundColor,
            child: Stepper(
              steps: steps,
              type: type,
              currentStep: currentStep,
              onStepTapped: onStepTapped,//step 点击回调函数(自定义)
              onStepContinue: onStepContinue,//Next 按钮点击回调函数
              onStepCancel: onStepCancel,//Cancel 按钮点击回调函数
              controlsBuilder:controlsBuilder, //控制栏(内容下方按钮构建函数)
              //physics 滑动的物理效果
            )
        )
    );

  }

//手势,点击事件控件/////////////////////////////////////////////////////////
/*
https://flutter.cn/docs/development/ui/advanced/gestures
  缩放手势: 可结合OverflowBox控件使用(使用OverflowBox可以让子组件宽高超过父组件)
  onScaleUpdate: (ScaleUpdateDetails e) {
      setState(() {
        //缩放倍数在0.8到10倍之间
        width = 200 * e.scale.clamp(0.8, 10);
      });
    },

  拖动:
  child: GestureDetector(
        onPanDown: (DragDownDetails e) {
          //打印手指按下的位置
          print("手指按下：${e.globalPosition}");
        },
        //手指滑动
        onPanUpdate: (DragUpdateDetails e) {
          setState(() {
            left += e.delta.dx;
            top += e.delta.dy;
          });
        },
        onPanEnd: (DragEndDetails e) {
          //打印滑动结束时在x、y轴上的速度
          print(e.velocity);
        },

        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(36)
          ),
        ),
      ),

      其他手势:
      垂直滑动
      onVerticalDragDown: (details) {},
      onVerticalDragStart: (details) {},
      onVerticalDragUpdate: (details) {},
      onVerticalDragEnd: (details) {},
      onVerticalDragCancel: () {},
      水平滑动
      onHorizontalDragDown: (details) {},
      onHorizontalDragStart: (details) {},
      onHorizontalDragUpdate: (details) {},
      onHorizontalDragEnd: (details) {},
      onHorizontalDragCancel: () {},
   */
  static GestureDetector getWidgetGestureDetector(
      {
        Widget? child,
        void Function()? onTap, //单击, (){print('单击')}
        void Function()? onDoubleTap, //双击 ()=> print('双击')
        void Function()? onLongPress, //长按
        void Function()? onTapCancel, //取消
        void Function(TapDownDetails details)? onTapDown, //按下
        void Function(TapUpDetails details)? onTapUp, //松开
        void Function(ScaleUpdateDetails details)? onScaleUpdate, //缩放
        void Function(DragDownDetails details)? onPanDown, //拖动-按下位置
        void Function(DragEndDetails details)? onPanEnd, //拖动-结束(松开)位置
        void Function(DragUpdateDetails details)? onPanUpdate, //拖动滑动中
      }
      ){
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapCancel: onTapCancel,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onScaleUpdate: onScaleUpdate,
      onPanDown: onPanDown,
      onPanEnd: onPanEnd,
      onPanUpdate: onPanUpdate,
      child: child,
    );
  }

  /*
  Focus 焦点监听控件
  return Focus(
    child: Builder(
      builder: (context) {
        final bool hasPrimary = Focus.of(context).hasPrimaryFocus;
        print('Building with primary focus: $hasPrimary');
        return const SizedBox(width: 100, height: 100);
      },
    ),
  );
   */

  /*
  水波纹效果的点击控件(类似按钮)
  设置背景为渐变色:
  BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFffffff), Color(0xFFEC592F)]),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
   */

  static Ink getWidgetInkWellButton(
      {
        required Widget child,
        required GestureTapCallback onTap,
        //边框圆角半径
        double borderRadius=2,
        //背景颜色
        Color? backgroundColor,
        //点击时水波纹颜色
        Color? splashColor,
      }
      ){

    return Ink(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        onTap: onTap,
        splashColor: splashColor,
        child: child,
      ),
    );
  }


//按钮 TextButton,OutlinedButton,ElevatedButton,IconButton//////////////////////////////////////
/*
  注意:按钮的字体样式并不在Text的TextStyle中修改,而是在本身的style使用ButtonStyle修改
   */
/*
  ElevatedButton,功能强大,用于替代旧的FlatButton、OutlineButton、RaisedButton
  注意: 按钮大小默认自身大小,
  如果外层嵌套Column/Row+Expanded则占满横向或竖向剩余空间
  如果外层是Container/SizedBox,如果不指定width或height,则默认自身大小,如果指定,则自动占满
   */
  static Widget getWidgetButtonElevated(
      {
        required Widget child,
        required VoidCallback onPressed,
        double? width, //double.infinity,横向占满
        double? height,//注意不能为double.infinity
        ButtonStyle? buttonStyle,
      }
      ){
    if((width!=null&&width>0) || (height!=null&&height>0)){
//指定大小
      if(width!=null&&width<=0){
        width=null;
      }

      if(height!=null&&(height<=0 || height==double.infinity)){
        height=null;
      }

      return XWidgetUtils.getLayoutContainer(
          child: ElevatedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: child,
          ),
          width: width,
          height: height
      );

    }else{
//默认大小, 也可在外层套用Column+Expanded 竖向占满
      return ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: child,
      );

    }

  }

/*
  OutlinedButton 文本按钮(有边框),透明背景
   */
  static OutlinedButton getWidgetButtonOutlined(
      {
        required Widget child,
        required VoidCallback onPressed,
        ButtonStyle? buttonStyle,
      }
      ){

    return OutlinedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: child,
    );
  }

/*
  TextButton 文本按钮(没有边框),透明背景
   */
  static TextButton getWidgetButtonText(
      {
        required String text,
        required VoidCallback onPressed,
        ButtonStyle? buttonStyle,
      }
      ){
    return TextButton(
      onPressed: onPressed,
      style: buttonStyle??XStyleUtils.getButtonStyle(),
      child: Text(text),
    );
  }

  /*
  下拉菜单按钮DropdownButton
   */
  static DropdownButton<dynamic> getWidgetDropdownButton(
      {
        required List<dynamic> itemData,
        //当前选择变量值,外面传入的变量,在onChanged中改变,注意:当前值需要在itemData中存在,否则报错
        required dynamic currentSelectItemValue,
        required XFunctionWidget<dynamic> buildItemWidget,
        /*
        选择后改变值回调:
        onChanged:(dynamic item){
            XLogUtils.printLog('--onChanged=$item');
            setState(() {
              currentItemValue=item;
            });
          }
         */
        required ValueChanged<dynamic> onChanged,
      }
      ){

    //注意:如果currentSelectItemValue不在itemData中会报错
    if(!itemData.contains(currentSelectItemValue)){
      XLogUtils.printLog('---currentSelectItemValue在itemData中不存在!');
      currentSelectItemValue=itemData.first;
    }

    //
    return DropdownButton<dynamic>(
      items: itemData.map((dynamic item){
        return DropdownMenuItem(
          value: item,
          child: buildItemWidget(item),
        );
      }).toList(),
      value: currentSelectItemValue,//实测如果不设置则报错
      onChanged: onChanged,
    );
  }


  /*
  PopupMenuButton标题栏菜单(类似下拉菜单按钮)
  onSelected:(dynamic item){
            XLogUtils.printLog('--onChanged=$item');
            setState(() {
              currentItemValue=item;
            });
          }
   */
  static PopupMenuButton<dynamic> getWidgetPopupMenuButton(
      {
        required List<dynamic> itemData,
        //当前选择变量值,外面传入的变量,在onChanged中改变,注意:当前值需要在itemData中存在,否则报错
        required dynamic currentSelectItemValue,
        required XFunctionWidget<dynamic> buildItemWidget,
        PopupMenuItemSelected<dynamic>? onSelected,
        PopupMenuCanceled? onCanceled,

      }
      ){
    return PopupMenuButton<dynamic>(
      onSelected: onSelected,
      onCanceled: onCanceled,
      initialValue: currentSelectItemValue,
      itemBuilder: (BuildContext context){
        return itemData.map((dynamic item){
          return PopupMenuItem<dynamic>(
            value: item,
            child: buildItemWidget(item),
          );
        }).toList();
      },
    );
  }


  //浮动按钮在Scaffold中的子控件
  static FloatingActionButton getWidgetFloatingActionButton(
      {
        required Widget icon,
        String? label,
        required VoidCallback onPressed,
        Color? backgroundColor,
      }
      ){
    if(XStringUtils.isEmpty(label)){
      return FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        child: icon,
      );
    }else{
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        label:Text(label!),
        icon: icon,
      );
    }

  }


//输入框TextField控件///////////////////////////////////////////////
  static TextField getWidgetTextField(
      {
        bool enabled=true,//输入框是否可用，默认为 true
        TextInputType keyboardType=TextInputType.text,//输入类型
        TextInputAction textInputAction=TextInputAction.done,//键盘回车键文本显示
        TextStyle? style,//字体样式
        String? labelText,//提示语，位于输入框上方
        TextStyle? labelTextStyle,
        String? helperText,//辅助文本，位于输入框下方，errorText 为空时显示
        TextStyle? helperStyle,
        Widget? icon,//位于输入框外侧坐标的图标
        Widget? prefixIcon,//头部图标，位于输入框内部最左侧
        Widget? suffixIcon,//尾部图标，位于输入框内部最右侧
        void Function()? onTap, //输入框点击监听
        void Function(String)? onChanged,//输入内容改变监听
        void Function(String)? onSubmitted,//提交按钮点击回调
        void Function()? onEditingComplete, //输入框完成回调
/*
        控制器，可以控制 textField 的输入内容，也可以监听 textField 改变,替代onChanged等
        TextEditingController _controller = TextEditingController(
      text: "123333",
    );
    _controller.addListener(() {
      print(_controller.text);
    });
         */
        TextEditingController? controller,
      }
      ){

    return TextField(
      style: style,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      controller: controller,
      decoration: InputDecoration( //装饰
//filled: true,
// hintText: hintText, //使用labelText替代
// hintStyle: hintTextStyle,
        labelText: labelText,
        labelStyle: labelTextStyle,
//auto : labelText 显示在输入框中，当开始输入时，会有一个动画，字体变小并显示在输入框上方。 never : labelText 显示在输入框中，当开始输入时，labelText 隐藏。 always: LabelText 永远显示在最上方。
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        helperText: helperText,
        helperStyle: helperStyle,
        icon:icon,
        prefixIcon:prefixIcon,
        suffixIcon: suffixIcon,
// counter | 备注组件 Widget，位于输入框右下角外侧，与 counterText 不能同时使用
// counterText | 备注文本，位于输入框右下角外侧，与 counter 不能同时使用
// counterStyle | 备注文本样式 TextStyle
        enabled:enabled,
      ),

    );
  }




  //文本Text控件///////////////////////////////////////////////
  //鼠标悬停文字后显示详细提示
  static Tooltip getWidgetTooltip(
      {
        //内容
        required String text,
        //提示
        required String tooltip,
        TextStyle? textStyle,//字体样式
        TextStyle? tooltipStyle,//字体样式
        /*
        背景色,形状
        BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient:
        const LinearGradient(colors: <Color>[Colors.amber, Colors.red]),
      )
         */
        BoxDecoration? decoration,
        double? height,
        /*
        const EdgeInsets.all(8.0)
         */
        EdgeInsetsGeometry? padding,
      }
      ){
    return Tooltip(
      message: tooltip,
      decoration: decoration,
      height: height,
      padding: padding,
      textStyle: tooltipStyle,
      //preferBelow: false,
      //showDuration: const Duration(seconds: 2),
      //waitDuration: const Duration(seconds: 1),
      child: getWidgetText(text,style: textStyle),
    );
  }

  //一种左右结构的文字(圆角),左边为圆形标签文字(短),右边也是文字(稍长)
  static Chip getWidgetChipText(
      {
        required String leftShortText,
        required String rightText,
        required Color leftBackgroundColor,
        TextStyle? leftTextStyle,//字体样式
        TextStyle? rightTextStyle,//字体样式
        Color? rightBackgroundColor,
      }
      ){
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: leftBackgroundColor??Colors.grey.shade800,
        child: Text(leftShortText,style: leftTextStyle,textAlign:TextAlign.center),
      ),
      label: Text(rightText),
      backgroundColor: rightBackgroundColor,
      labelStyle: rightTextStyle,
    );
  }

  //一种左右结构的文字(圆角),左边为图标,右边也是文字(稍长)
  static Chip getWidgetChipIconText(
      {
        required Widget leftWidget,
        required String rightText,
        TextStyle? rightTextStyle,//字体样式
        Color? rightBackgroundColor,
      }
      ){
    return Chip(
      avatar: leftWidget,
      label: Text(rightText),
      backgroundColor: rightBackgroundColor,
      labelStyle: rightTextStyle,
    );
  }

  //基本文字显示控件
  static Text getWidgetText(
      String str,
      {
        TextStyle? style,//字体样式
        TextAlign textAlign=TextAlign.left,//对齐方式
        bool softWrap=true, //默认换行(超出范围)
        int? maxLines,//设置最大行数,如果>0,则自动设置softWrap=false,已maxLines为准;只设置softWrap为false,不设置maxLines则默认1行
      }
      ){

//注意: TextOverflow.ellipsis省略号只能处理英文符号字符,处理中文会乱码,
// 解决中文字符串超出范围自动省略号问题在每个中文字符之间插入零宽空格字符,即能被TextOverflow.ellipsis处理
    String chineseWord='';
    str.runes.forEach((element) {
      chineseWord+=String.fromCharCode(element);
      chineseWord+='\u200B';
    });

//以maxLines为准,自动更改softWrap的值
    if(maxLines!=null && maxLines>0){
      if(maxLines<=0){
        maxLines=null;
      }else{
        softWrap=false;
      }
    }

    return Text(
      chineseWord,
      style: style??XStyleUtils.textStyle_333_14(),
//softWrap: softWrap, //是否换行, 这里直接设置overflow,以其值为准
      maxLines: maxLines,
      overflow: softWrap?TextOverflow.visible:TextOverflow.ellipsis, //溢出控件大小处理 , TextOverflow.ellipsis 省略号,  clip 裁剪, fade 淡出, visible 依然可视
      textAlign: textAlign,
    );
  }


}
