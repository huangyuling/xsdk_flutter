import 'package:flutter/material.dart';

// ValueGetter<T>

typedef XFunctionWidget<T> = Widget Function(T? item);

typedef XFunctionListItemWidget<T> = Widget Function(T? item,int index);

//分组Listview使用
typedef XFunctionGroupItemWidget<T> = Widget Function(T? item,bool? isExpanded);


typedef XFunctionResultCallback<T> = void Function(T? result);
