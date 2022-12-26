
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xsdk_flutter_package/xsdk/framework/bean/x_bean_data_table.dart';
import 'package:xsdk_flutter_package/xsdk/framework/bean/x_bean_group_list_item.dart';
import 'package:xsdk_flutter_package/xsdk/framework/bean/x_bean_menu.dart';
import 'package:xsdk_flutter_package/xsdk/framework/page/x_page_state.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_log.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_widget.dart';


/*
页面父类基础界面
DataTable通用State

https://blog.csdn.net/mengks1987/article/details/104661591

 */
abstract class XDataTableState extends XPageState {

  //列标签数据
  List<XBeanDataTableLabel> columnsLabels=[];


  //子类取消required,(这里强制required则子类会提示生成构造方法)
  XDataTableState(
      {required super.xTag,
        required super.xData,
        super.isKeepPageState=false,
      }
      );

  //重写方法///////////////////////////////////////////////////

  /*
  构建datatable的行数据
   */
  @required
  DataRow getDataTableDataRow(dynamic item);



  //私有方法/////////////////////////////////////////////////////////

  /*
  添加AnimatedList控件
   */
  @override
  Widget getBodyWidget({XBeanMenuItem? menuItem}) {

    //数据表格DataTable
    return XWidgetUtils.getLayoutDataTable(
      columnsLabels: columnsLabels,
      rows: listData.map((dynamic item) {
        return getDataTableDataRow(item);
      },
      ).toList(),
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
     */
    setState((){});

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
     */
    setState((){});
  }

  //删除数据(适合存在重复相同的数据,按位置删除)
  void removeItemByPosition(int position){
    listData.removeAt(position);
    setState((){});

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

    //删除所有数据
    listData.clear();
    //ListView
    setState((){});

  }

  //替换所有数据
  void replaceAllItems(List<dynamic> items){
    //删除所有数据
    removeAllItems();
    //添加新数据
    addMultipleItems(items);
  }



}