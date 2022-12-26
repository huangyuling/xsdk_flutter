
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xsdk_flutter_package/xsdk/framework/bean/x_bean_group_list_item.dart';
import 'package:xsdk_flutter_package/xsdk/framework/bean/x_bean_menu.dart';
import 'package:xsdk_flutter_package/xsdk/framework/page/x_page_state.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_log.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_widget.dart';


/*
页面父类基础界面
listView通用State
 */
abstract class XPageListViewState extends XPageState {

  final GlobalKey<AnimatedListState> _listStateKey = GlobalKey<AnimatedListState>();

  //AnimatedList动画时间
  int animatedListDurationMilliseconds=200;

  //是否支持滑动删除item(使用Dismissible)
  bool _isEnableSlideRemoveItem=false;
  //分组listView,是否只有一个分组展开
  bool _isGroupSingleExpanded=true;
  //GridList的列数
  int _crossAxisCount=2;

  /*
  0:ListView(没有动画,支持滑动删除item);
  1:AnimatedList(支持手动点击添加/删除item动画,不支持拖拽item,不支持滑动删除item,常用场景:web);
  2:ReorderableListView(支持拖拽item);
  3:ExpansionPanelList分组listview
  4.GridListview
   */
  int _listViewType=0;

  //子类取消required,(这里强制required则子类会提示生成构造方法)
  XPageListViewState(
      {required super.xTag,
        required super.xData,
        super.isKeepPageState=false,
        //是否支持拖拽item
        bool isEnableItemDrag=false,
        //是否支持滑动删除item
        bool isEnableSlideRemoveItem=false,
        //是否支持手动添加删除item动画(使用AnimatedList,不支持拖拽item,不支持滑动删除item,常用场景:web)
        bool isEnableManualAddOrRemoveItemAnimation=false,
        //是否分组
        bool isGroupList=false,
        //分组是否只有1个展开
        bool isGroupSingleExpanded=true,
        //是否网格GridList
        bool isGridList=false,
        //网格GridList的列数
        int crossAxisCount=2,
      }
      ){

    if(isGridList){
      //网格griview
      _listViewType=4;
      _crossAxisCount=crossAxisCount;
    }else if(isGroupList){
      //分组
      _listViewType=3;
      _isGroupSingleExpanded=isGroupSingleExpanded;
    }else{
      //不分组
      if(isEnableItemDrag){
        //启用拖拽item(使用ReorderableListView)
        _isEnableSlideRemoveItem=isEnableSlideRemoveItem;
        _listViewType=2;
      }else if(isEnableSlideRemoveItem){
        //不启用拖拽item,但启用滑动删除item(使用ListView)
        _isEnableSlideRemoveItem=isEnableSlideRemoveItem;
        _listViewType=0;
      }else if(isEnableManualAddOrRemoveItemAnimation){
        //支持手动添加删除item动画(使用AnimatedList,不支持拖拽item,不支持滑动删除item)
        _listViewType=1;
      }else{
        _listViewType=0;
      }
    }
  }


  //重写方法///////////////////////////////////////////////////

  /*
  构建item的widget
  强转: Car item= listItem as Car;
  注意:
  1.getListItemWidget要以item绘制widget,避免使用position
  2.删除操作时,可以使用position(避免相同item情况),使用removeUsePosition
   */
  @required
  Widget getListItemWidget(dynamic listItem,int removeUsePosition);

  /*
  构建分组头groupItem的widget
  强转: Car item= listItem as Car;
  注意:
  1.getListItemWidget要以item绘制widget,避免使用position
  2.删除操作时,可以使用position(避免相同item情况),使用removeUsePosition
   */
  @required
  Widget getGroupItemWidget(dynamic groupItem, bool isExpanded);


  //私有方法/////////////////////////////////////////////////////////

  /*
  添加AnimatedList控件
   */
  @override
  Widget getBodyWidget({XBeanMenuItem? menuItem}) {

    if(_listViewType==1){
      //使用有动画效果的 AnimatedList
      return XWidgetUtils.getWidgetAnimatedList(
        key:_listStateKey,
        listData:listData,
        listItemWidgetFunction: (BuildContext context, int index, Animation<double> animation){
          //支持item左右上下滑动
          return _buildAnimatedListItemWidget(listData[index],index,animation,true);
        },
      );
    }else if(_listViewType==2){
      //支持拖拽item的ReorderableListView
      return XWidgetUtils.getWidgetReorderableListView(
        listData:listData,
        listItemWidgetFunction: (BuildContext context, int index){
          //支持item左右上下滑动
          return _isEnableSlideRemoveItem?_buildDismissibleForSupportItemSlideRemove(listData[index],index):getListItemWidget(listData[index],index);
        },
        onReorder:  (int oldIndex, int newIndex){
          //拖拽位置变动
          if(oldIndex!=newIndex){
            setState(() {
              if(newIndex>oldIndex) {
                newIndex -= 1;
              }
              var tempItem = listData.removeAt(oldIndex);
              listData.insert(newIndex, tempItem);
            });
          }
        },
      );
    }else if(_listViewType==3){

      if(_isGroupSingleExpanded){
        //只有1个分组展开
        return XWidgetUtils.getWidgetExpansionPanelRadioList(
          listData: listData,
          groupItemWidgetFunction: (dynamic groupItem, bool? isExpanded){
            return getGroupItemWidget(groupItem,isExpanded!);
          },
          listItemWidgetFunction: (dynamic listItem,int index){
            return getListItemWidget(listItem,index);
          },
        );

      }else{
        //多个分组可展开
        return XWidgetUtils.getWidgetExpansionPanelList(
            listData: listData,
            groupItemWidgetFunction: (dynamic groupItem, bool? isExpanded){
              return getGroupItemWidget(groupItem,isExpanded!);
            },
            listItemWidgetFunction: (dynamic listItem,int index){
              return getListItemWidget(listItem,index);
            },
            expansionCallback: (int panelIndex, bool isExpanded){
              setState(() {
                XBeanExpansionItem item= listData[panelIndex] as XBeanExpansionItem;
                item.isExpanded = !isExpanded;
              });
            });
      }

    }else if(_listViewType==4){
      //网格Listview
      return XWidgetUtils.getWidgetGridView(
          crossAxisCount: _crossAxisCount,
          listData: listData,
          listItemWidgetFunction: (BuildContext context,int index){
            return getListItemWidget(listData[index],index);
          });
    }else{
      //使用普通的ListView(支持滑动删除item)
      return XWidgetUtils.getWidgetListView(
        listData:listData,
        listItemWidgetFunction:(BuildContext context,int index){
          //支持item左右上下滑动
          return _isEnableSlideRemoveItem?_buildDismissibleForSupportItemSlideRemove(listData[index],index):getListItemWidget(listData[index],index);
        },
      );
    }

  }

  //(私有方法)创建listItem的Widget,支持动画
  /*
    使用position(删除item后导致listData下标变化),注意:删除动作执行此方法,动画效果时,
    问题1: 实测删除最后1个item时会报错的情况:
    原因在此方法外执行listData删除item动作,因为动画线程异步,实际listData已经删除item(已经不存在任何item),则不能再让其执行下面的getListItemWidget绘制widget了,
    解决办法: 返回一个没有position关联的widget;
    问题2:在此方法外执行listData删除item动作,因为动画线程异步,实际listData已经删除item,删除动画中的item并不是对应删除item,而是它的下一个item的widget动画,
    如果改为:不在此方法外删除listData中的item,而在此方法中添加监听动画状态,当动画消失时,再删除对应listData中的item,则可以保证删除动画对应的是删除的那个item,
    但存在的问题更严重,界面显示没有删除的下1个item先变成要删除的那个item,然后再变回正常没有删除的item,原因是同时绘制界面造成的;
    因此最好的解决办法:getListItemWidget不使用position,而直接使用item绘制widget,则不会存在上面的问题
     */
  // Widget _buildAnimatedListItemWidget(
  //     int position,
  //     Animation<double> animation,
  //     bool isAddItem//是否添加item,否则为删除item
  //     ){
  //   if(listData.length==0){
  //     return XWidgetUtils.getLayoutContainer();
  //   }
  //   // if(!isAddItem){
  //   //   animation.addStatusListener((status) {
  //   //     if(status==AnimationStatus.dismissed){
  //   //       XLogUtils.printLog('----删除item:$status');
  //   //       listData.removeAt(position);
  //   //     }
  //   //   });
  //   // }
  //
  //   //渐变
  //   return FadeTransition(
  //     opacity: animation.drive(CurveTween(curve:isAddItem? Curves.easeIn:Curves.easeOut)),
  //     //位置移动(右入右出)
  //     child: SlideTransition(
  //       //easeInCirc,easeInExpo,bounceOut fastLinearToSlowEaseIn 速度节奏等不一样
  //       position: animation.drive(CurveTween(curve:isAddItem? Curves.fastLinearToSlowEaseIn:Curves.easeOutExpo))
  //           .drive(Tween<Offset>(begin: const Offset(1,0),end: const Offset(0,0))),
  //       child: getListItemWidget(position),
  //     ),
  //   );
  // }
  //getListItemWidget以item绘制widget,避免使用position
  Widget _buildAnimatedListItemWidget(
      dynamic listItem,
      int position,
      Animation<double> animation,
      bool isAddItem//是否添加item,否则为删除item
      ){

    //渐变
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve:isAddItem? Curves.easeInExpo:Curves.easeOutExpo)),
      //位置移动(右入右出)
      child: SlideTransition(
        //easeInCirc,easeInExpo,bounceOut fastLinearToSlowEaseIn 速度节奏等不一样
        position: animation.drive(CurveTween(curve:isAddItem? Curves.easeInExpo:Curves.easeOutExpo))
            .drive(Tween<Offset>(begin: const Offset(1,0),end: const Offset(0,0))),
        //支持item滑动删除
        child: getListItemWidget(listItem,position),
      ),
    );
  }


  /*
  使用Dismissible支持item滑动:

  direction 为限制滑动关闭方向，在 onDismissed / confirmDismiss 中也可以进行判断；
DismissDirection.vertical 竖直方向，包括 up / down 两种
DismissDirection.horizontal 水平方向，包括 endToStart / startToEnd 两种
DismissDirection.endToStart 结束到开始方向(与语言设置的 rtl 和 ltr 相关)，汉英等日常方向一般是从右至左
DismissDirection.startToEnd 开始到结束方向(与语言设置的 rtl 和 ltr 相关)，汉英等日常方向一般是从左至右
DismissDirection.up 由下向上
DismissDirection.down 由上向下

confirmDismiss 返回的是 Future 类型的数据，用于判断是否可清除当前 Widget，
返回 true 时清除此 Widget，否则将其移回到其原始位置；
当返回 false / null 时，均不会进入 onDismissed / onResize 回调；
其中 onDismissed 为确认清除当前 Widget 的回调，onResize 为当前 Widget 改变尺寸时的回调；
在 confirmDismiss / onDismissed 中可以根据 direction 滑动方向进行单独判断；

  dismissThresholds 可根据各方向设置不同的阀值，对应的是一个 Map 集合；范围在(0.0, 1.0) 之间，设置的阀值越大，代表滑动范围越大才可以触发 onDismissed 回调；
  dismissThresholds: {
  DismissDirection.startToEnd: 0.8,
  DismissDirection.endToStart: 0.3
},
   */

  Widget _buildDismissibleForSupportItemSlideRemove(dynamic listItem,int position){
    return Dismissible(
      key:UniqueKey(),
      //onUpdate: ,//每个滑动像素事件
      //confirmDismiss: ,//默认item全都可删除
      //onResize:,//重新修改尺寸回调(优先onDismissed执行)
      onDismissed: (DismissDirection direction){
        //滑动有效触发后回调(ui移除item)
        //XLogUtils.printLog('----item滑动方向= $direction,position=$position');
        //删除数据ok(注意:实测Dismissible的删除并没有更新ui的位置,即position没有更新,因此不能用removeAt(),Dismissible只能和ListView一起使用,不能和AnimatedList使用(无法更新AnimatedList的ui中的item位置))
        setState(() {
          listData.remove(listItem);
        });
      },
      //滑动方向(向左向右滑动都可删除)
      direction: DismissDirection.horizontal,//!isItemSupportSlideRemove?DismissDirection.none:DismissDirection.horizontal,
      background: _createDismissibleRemoveBackgroundWidget(),
      secondaryBackground: _createSecondDismissibleRemoveBackgroundWidget(),
      child: getListItemWidget(listItem,position),
    );

  }


  //滑出item删除时(向左滑),Dismissible的背景widget,显示删除图标
  _createDismissibleRemoveBackgroundWidget() {
    return XWidgetUtils.getLayoutContainer(
        backgroundColor: const Color(0xffff0000),
        child: XWidgetUtils.getLayoutAlign(
          alignment:Alignment.centerLeft,
          child:XWidgetUtils.getLayoutPadding(
              padding:const EdgeInsets.symmetric(horizontal: 15.0),
              child:XWidgetUtils.getLayoutFittedBox(
                  XWidgetUtils.getLayoutColumn(
                      children:[
                        const Icon(Icons.delete, color: Colors.white),
                        const Text('删除', style: TextStyle(color: Colors.white,fontSize: 12))
                      ]))
          ),
        )
    );
  }

  //Dismissible的第二背景(向右滑)
  _createSecondDismissibleRemoveBackgroundWidget() {
    return XWidgetUtils.getLayoutContainer(
        backgroundColor: const Color(0xffff0000),
        child: XWidgetUtils.getLayoutAlign(
          alignment:Alignment.centerRight,
          child:XWidgetUtils.getLayoutPadding(
              padding:const EdgeInsets.symmetric(horizontal: 15.0),
              child:XWidgetUtils.getLayoutFittedBox(
                  XWidgetUtils.getLayoutColumn(
                      children:[
                        const Icon(Icons.delete, color: Colors.white),
                        const Text('删除', style: TextStyle(color: Colors.white,fontSize: 12))
                      ]))
          ),
        )
    );
  }



  //增删item公开方法///////////////////////////////////////////////////////////////

  //手动点击按钮添加,替换,删除(按位置删除,适合存在重复item的情况,适合ListView,AnimatedList使用,但不适合Dismissible使用),/////////////////////////////////////////////////////////
  //添加单条数据
  void addSingleItem(
      dynamic item,
      {
        int? position, //插入位置
      }
      ){
    //先添加item,后更新
    if(position==null || position<0){
      //在末尾添加
      position=listData.length;
      listData.add(item);
    }else{
      //按位置插入
      listData.insert(position, item);
    }

    /*
    更新
    ListView,使用setState
    AnimatedList实测使用setState更新无效,和使用_listStateKey.currentState!.setState();也是无效的)
     */
    if(_listViewType==1){
      //AnimatedList, _listStateKey?.currentState等同于AnimatedList.maybeOf(BuildContext context)
      _listStateKey.currentState?.insertItem(position,duration:  Duration(milliseconds: animatedListDurationMilliseconds));
    }else{
      //ListView
      setState((){});
    }

  }

  //添加多条
  void addMultipleItems(
      List<dynamic> items,
      {
        int? position, //插入位置
      }
      ){
    //先添加item,后更新
    if(position==null || position<0){
      //在末尾添加
      position=listData.length;
      listData.addAll(items);
    }else{
      //按位置插入
      listData.insertAll(position, items);
    }

    /*
    更新
    ListView,使用setState
    AnimatedList实测使用setState更新无效,和使用_listStateKey.currentState!.setState();也是无效的)
     */
    if(_listViewType==1){
      //AnimatedList, _listStateKey?.currentState等同于AnimatedList.maybeOf(BuildContext context)
      for (int offset = 0; offset < items.length; offset++) {
        _listStateKey.currentState?.insertItem(position + offset,duration:  Duration(milliseconds: animatedListDurationMilliseconds));
      }
    }else{
      //ListView
      setState((){});
    }
  }

  //删除数据(适合存在重复相同的数据,按位置删除)
  void removeItemByPosition(int position){
    if(_listViewType==1){
      //删除
      dynamic removeItem=listData.removeAt(position);

      //AnimatedList, _listStateKey?.currentState等同于AnimatedList.maybeOf(BuildContext context)
      _listStateKey.currentState?.removeItem(
          position,
          duration: Duration(milliseconds: animatedListDurationMilliseconds),
              (context, animation){
            //测试不能在这里删除或获得item,点击过快会报错!
            //dynamic removeItem= listData.removeAt(position);
            //dynamic removeItem= listData[position];
            //
            return _buildAnimatedListItemWidget(removeItem,position, animation,false);
          });

    }else{
      //ListView,先删除后更新
      listData.removeAt(position);
      setState((){});
    }

  }

  //删除数据(注意:不适合存在重复相同的数据情景)
  // void removeItem(dynamic item){
  //   if(isUseAnimatedList){
  //     //删除
  //     int position=listData.indexOf(item);
  //     dynamic removeItem=listData.removeAt(position);
  //
  //     //AnimatedList, _listStateKey?.currentState等同于AnimatedList.maybeOf(BuildContext context)
  //     _listStateKey.currentState?.removeItem(
  //         position,
  //         duration: Duration(milliseconds: animatedListDurationMilliseconds),
  //             (context, animation){
  //           //测试不能在这里删除或获得item,点击过快会报错!
  //           //dynamic removeItem= listData.removeAt(position);
  //           //dynamic removeItem= listData[position];
  //           //
  //           return _buildListItemWidget(removeItem,position, animation,false);
  //         });
  //
  //   }else{
  //     //ListView,先删除后更新
  //     listData.remove(item);
  //     setState((){});
  //   }
  // }

  //删除所有数据
  void removeAllItems(){

    if(_listViewType==1){
      //AnimatedList, 先更新,后删除, AnimatedList不能使用listData.clear();后数量不对报错!
      while(listData.length>0){
        // _listStateKey?.currentState等同于AnimatedList.maybeOf(BuildContext context)
        //从第1个开始删除
        dynamic removeItem= listData.removeAt(0);
        //
        _listStateKey.currentState?.removeItem(
            0,
            duration: Duration(milliseconds: animatedListDurationMilliseconds),
                (context, animation){
              //
              return _buildAnimatedListItemWidget(removeItem,0, animation,false);
            });
      }

    }else{

      //删除所有数据
      listData.clear();
      //ListView
      setState((){});
    }

  }

  //替换所有数据
  void replaceAllItems(List<dynamic> items){
    //删除所有数据
    removeAllItems();
    //添加新数据
    addMultipleItems(items);
  }




}