
/*
图片Banners:  https://pub.dev/packages/banner_carousel
依赖:
dependencies:
  banner_carousel: ^1.2.1
引入:
import 'package:banner_carousel/banner_carousel.dart';

 */

import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter/material.dart';


abstract class XImageBannersUtils{

  //
  static Widget getBannerCarousel(List<String> imagePaths,bool isFullScreen){

    List<BannerModel> listBanners = [];
    //pathImage支持本地或网络图片

    for (int i = 0; i <= imagePaths.length; i++) {
      listBanners.add(BannerModel(imagePath: imagePaths[i], id: '${i}'));
    }


    /*
      BannerCarousel(
  banners: listBanners,
  customizedIndicators: IndicatorModel.animation(width: 20, height: 5, spaceBetween: 2, widthAnimation: 50),
  height: 120,
  activeColor: Colors.amberAccent,
  disableColor: Colors.white,
  animation: true,
  borderRadius: 10,
  width: 250,
  indicatorBottom: false,
),
    点击事件:
    BannerCarousel(
  banners: listBanners,
  onTap: (id) => print(id),
)
     */
    if(isFullScreen){
      //全屏
      return BannerCarousel.fullScreen(
        banners: listBanners,
        animation: false,
      );

    }else{
      //非全屏
      return BannerCarousel(banners: listBanners);
    }




  }




}
