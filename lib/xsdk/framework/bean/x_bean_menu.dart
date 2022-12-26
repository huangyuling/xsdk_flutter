import 'package:flutter/material.dart';


/*
 TabBar,BottomNavigationBar
 */
class XBeanMenuItem {
  String? id;
  String? text;

  /*
  在pubspec.yaml添加素材,如:
  assets:
    - images/a_dot_burr.jpeg

  icon: Image.asset("images/ic_tab_home_normal.png",fit: BoxFit.cover,width: 40,height: 40,),

   */
  String? image;
  String? activeImage;

  IconData? icon;
  Color? iconColor;

  IconData? activeIcon;
  Color? activeIconColor;

  XBeanMenuItem({
    this.id,
    this.text,
    this.icon,
    this.iconColor,
    this.activeIcon,
    this.activeIconColor,
    this.image,
    this.activeImage,
  });
}
