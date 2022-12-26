

/*
1.在pubspec.yaml中设置依赖:
dependencies:
  flutter:
    sdk: flutter

  #1.1开发项目添加引用本地没发布plugin(非在开发项目内部存在),可用相对路径(也可用绝对路径)
  xsdk_flutter_package:
    path: /Users/yulinghuang/hyl_developer/hyl_workspace/workspace_flutter/xsdk_flutter_package

  #1.2开发项目添加引用本地没发布plugin(该plugin在开发项目内部建立存在)
  xsdk_flutter_package:
    path: xsdk_flutter_package


2.在项目xxx.dark中引用:
import 'package:xsdk_flutter_package/xsdk/xsdk_flutter_package.dart';
 */

//定义库名称
library xsdk_flutter_package;

//Base界面
export 'framework/x_app.dart';
export 'framework/base/xsdk_widget_stateful.dart';
export 'framework/base/xsdk_widget_stateless.dart';
export 'framework/page/x_page_state.dart';
export 'framework/page/x_page_state_listview.dart';

//bean
export 'framework/bean/x_bean_menu.dart';
export 'framework/bean/x_enum.dart';
export 'framework/bean/x_bean_group_list_item.dart';
export 'framework/bean/x_bean_data_table.dart';

//function
export 'framework/callback/x_function.dart';

//工具类
export 'utils/x_utils_flutter.dart';
export 'utils/x_utils_widget.dart';
export 'utils/x_utils_style.dart';
export 'utils/x_utils_color.dart';
export 'utils/x_utils_number.dart';
export 'utils/x_utils_date.dart';
export 'utils/x_utils_file.dart';
export 'utils/x_utils_image.dart';
export 'utils/x_utils_image_banners.dart';
export 'utils/x_utils_json.dart';
export 'utils/x_utils_log.dart';
export 'utils/x_utils_share_preferences.dart';
export 'utils/x_utils_string.dart';
export 'utils/x_utils_toast.dart';
