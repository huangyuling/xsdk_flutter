import 'package:flutter/material.dart';
import 'package:xsdk_flutter_package/xsdk/utils/x_utils_style.dart';


/*
 DataTable的行标签
 */
class XBeanDataTableLabel {
  String text;
  String? tooltip;//长按提示信息
  bool isAlignLeft=true;
  TextStyle style;//字体样式

  /*
  点击列标签,重新排序
  onSort: (int columnIndex, bool ascending){
            setState(() {
              _sortColumnIndex = columnIndex;
              _sortAscending = ascending;
              if(ascending){
                data.sort((a, b) => a.name.compareTo(b.name));
              }else {
                data.sort((a, b) => b.name.compareTo(a.name));
              }
            });
   */
  DataColumnSortCallback? onSort;

  XBeanDataTableLabel(
      this.text,
      {
        this.tooltip,
        this.isAlignLeft=true,
        this.style=const TextStyle(color: Color(0x00333333),fontSize: 14),
        this.onSort
      }
      );
}

