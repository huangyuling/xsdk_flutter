/*
StatelessWidget框架,
使用MaterialApp框架,需在app的main()中,使用runXAppInMain()替代原来的runApp();
注意:
即是内部多个child都是StatefulWidget,
如果它们有关联联动,其中一个child的setState方法只能通知自己更新,很难通知其他Stateful的child更新,
因此,如果有多个联动的child,则建议其所有child的根Widget开始,就使用stateful,
联动方法也在其总的stateful那层,那么通知更新时,就会重新执行build
 */

//StatelessWidget/////////////////////////////////////////////////////////
/*
 StatelessWidget父类基础界面
 */

import 'package:flutter/material.dart';

abstract class XStatelessWidget extends StatelessWidget {

  String? xData;

  XStatelessWidget({this.xData,super.key});

  late BuildContext xContext;

  @override
  Widget build(BuildContext context) {
    xContext=context;
    //
    init();

    return getWidget();
  }

  //初始化
  @required
  void init();

  //主内容body ContentView
  @required
  Widget getWidget();


}