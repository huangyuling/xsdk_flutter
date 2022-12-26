


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

abstract class XImageUtils{

  /*
  图片加载(网络,缓存): https://pub.dev/packages/cached_network_image
  依赖:
  dependencies:
    cached_network_image: ^3.2.2
  引入:
  import 'package:cached_network_image/cached_network_image.dart';
 */
  static Image imageUrl(String imageUrl){

    /*
    CachedNetworkImage(
        imageUrl: "http://via.placeholder.com/350x150",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
     )

    CachedNetworkImage(
  imageUrl: "http://via.placeholder.com/200x150",
  imageBuilder: (context, imageProvider) => Container(
    decoration: BoxDecoration(
      image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
    ),
  ),
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
     */

    /*
  加载网络图片,支持gif动画,没有占位图功能,加载完后,直接显示
  return Image.network(url);
 */

    return Image(image: CachedNetworkImageProvider(imageUrl));
  }


  /*
  本地图片素材
  在pubspec.yaml添加素材,如:
  assets:
    - images/a_dot_burr.jpeg

  Image.asset("images/ic_tab_home_normal.png",fit: BoxFit.cover,width: 40,height: 40,),
   */
  static Image imageLocal(String imagePath){
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,//显示效果 例如: BoxFit.cover cover:自适应 fill:铺满可能变形 fitWidth:宽充满 filHright:高充满 repeat:多张图片平铺
      //alignment: ,//图片相对容器的对齐方式 例如: Alignment.bottomRight
      //centerSlice:,//保留区域 例如：Rect.fromLTRB(9, 27, 60, 27 + 1.0)
      //repeat: ImageRepeat.noRepeat,//图片重复模式 ImageRepeat
      //colorBlendMode: ,//图片混合模式 BlendMode.colorBurn
    );
  }

  /*
  DecorationImage(//设置图片背景，设置image需要一个DecorationImage类
                // Load image from assets
                  image: AssetImage('images/base_widgets/icon_main_date_select@2x.png'),
                  // Make the image cover the whole area
                  fit: BoxFit.cover))
   */


  //本地系统自带图标素材 Icons.directions_car Icons.directions_bus,...
  //icon: Icon(Icons.home, color: _BottomNavigationColor,size:36),
  //IconButton
  static Icon icon(
      {
        required IconData Icons_icon,
        Color? color,
        double? size,
      }

      ){
    return Icon(
      Icons_icon,
      color: color,
      size: size,
    );
  }



}
