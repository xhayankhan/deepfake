import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';

class ImageController extends GetxController{
  List mediaList = [];
  int currentPage = 0;
  int? lastPage;
  Uint8List? uint8list1;
  List filesssss = [];

  handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        fetchNewMedia();
      }
    }
  }

  fetchNewMedia() async {


    lastPage = currentPage;
    mediaList.clear();
    List<AssetPathEntity> albums =
    await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true);

    List<AssetEntity> media =
    await albums[0].getAssetListPaged(
        size: 20, page: currentPage); //preloading files




    for (var asset in media) {

      Uint8List? uint8list=await asset.thumbnailDataWithSize(const ThumbnailSize(500,500));
      mediaList.add(uint8list);

    }

  }
  share(String path){
    Share.shareFiles([path], text: 'Courtesy of SwapUp\nhttps://play.google.com/store/apps/details?id=com.appexsoft.microscan.image.to.text');

  }
}