import 'dart:developer';
import 'dart:io';

import 'package:deepfake/Controllers/EditingController.dart';
import 'package:deepfake/Controllers/ImageController.dart';
import 'package:image/image.dart' as imglib;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';



class GridGallery extends StatefulWidget {
  final ScrollController? scrollCtr;

   GridGallery({
    Key? key,
    this.scrollCtr,
  }) : super(key: key);

  @override
  _GridGalleryState createState() => _GridGalleryState();
}

class _GridGalleryState extends State<GridGallery> {
ImageController image=Get.find();
EditingController edit=Get.find();
@override
void dispose(){
  widget.scrollCtr?.dispose();
  super.dispose();
}
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        image.handleScrollEvent(scroll);
        return false;
      },
      child: GridView.builder(
          controller: widget.scrollCtr,
          itemCount: image.mediaList.length>15?15:image.mediaList.length,
          gridDelegate:
           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 10,
          childAspectRatio: 0.65.h/0.7.h),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(onTap:()async{
              //await EasyLoading.show(status: 'Loading...');

              imglib.Image? image1 = imglib.decodeImage(image.mediaList[index]);
             var img= await imgTofile(image1!);
             await edit.cropImage(img, false);
               var pickedFile = image.mediaList[index];
                        log(image.filesssss.toString());

               // EasyLoading.dismiss();

            },child:ClipRRect(
                         borderRadius: BorderRadius.circular(20),child:Image.memory(image.mediaList[index],fit: BoxFit.cover,))
            );
          }),
    );
  }
imgTofile(imglib.Image image) async {

  Directory? directory = await getApplicationDocumentsDirectory();

  bool directoryExists =
  await Directory('${directory.path}/Pictures/Saved').exists();

  if (!directoryExists) {
    print("\n Directory not exist");
    //  navigateToShowPage(path, -1);
    await Directory("${directory.path}/Documents/Folders/Recents").create(recursive: true);

    //Getting all images of chapter from firectory

  }

  print("\n direcctoryb = ${directory}");
  final fullPath =
      '${directory.path}/Documents/Folders/Recents/MS ${DateTime
      .now()}.png';
  final imgFile = File('$fullPath');
  log(imgFile.path);
  imgFile.writeAsBytesSync(imglib.encodePng(image));
  return imgFile;

}

}
