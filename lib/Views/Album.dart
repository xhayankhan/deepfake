import 'dart:developer';
import 'dart:io';

import 'package:deepfake/Constant/Constants.dart';
import 'package:deepfake/Views/Home%20Page.dart';
import 'package:deepfake/Views/Savedvideoplayer.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AlbumView extends StatefulWidget {
  const AlbumView({Key? key}) : super(key: key);

  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {

  List allPagesList = [];
  List allPagesList2 = [];
  List reversedList=[];
  late VideoPlayerController controller;

  var folderName;
  List docx=[];
  List folders=[];
  var ImagesPath ;
  Directory? dir2 ;
  var foldersPath ;
  Directory? dirFolder ;
  var recents=false;
  bool isload=true;
  var args=Get.arguments;
  @override
  void initState(){
    super.initState();
    getData();
    isload=true;
  }
  @override
  void dispose(){
    super.dispose();

    controller.dispose();
  }
  void getData() async {
    allPagesList2.clear();
    allPagesList.clear();

    var appDir=await getApplicationDocumentsDirectory();
    dir2=Directory('${appDir.path}/Videos');
    ImagesPath='${appDir.path}/Videos';

    bool directoryExists =
    await Directory(ImagesPath).exists();

    if(directoryExists){
      List<FileSystemEntity> files = dir2!.listSync();
      print("\nAll Images inside");

      for (FileSystemEntity f1 in files) {
        allPagesList.add(f1.absolute.path);
        setState((){});
        print(f1.absolute.path);
      }
      allPagesList2=allPagesList.reversed.toList();
      log("allpages:${allPagesList2}");


    }
    else if(!directoryExists){
      await Directory('${ImagesPath}').create(recursive: true);
    }
    //allPagesList2.sort((a, b) => a.toString().compareTo(b.toString()));
    //reversedList=allPagesList2.reversed.toList();
    for(int i=0;i<allPagesList2.length;i++){
      reversedList.add( await VideoCompress.getFileThumbnail(
          allPagesList2[i],
          // default(100)
          position: -1 // default(-1)
      ));
    //  reversedList.add( await VideoThumbnail.thumbnailFile(
    //   video: allPagesList2[i],
    //   thumbnailPath: (await getTemporaryDirectory()).path,
    //   imageFormat: ImageFormat.JPEG,
    //   maxHeight: 100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    //   quality: 100,
    // ));
    log (reversedList.toString());

  }
    isload=false;
    setState(()
    {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: (){
          Get.off(()=> const VideoPickerPage());
         return Future.value(true);
        },
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image:AssetImage('assets/background.png'),fit: BoxFit.fill,filterQuality: FilterQuality.high,

              ),
              color: Colors.black
          ),
          child: SafeArea(
            child: Column(
              children: [
                Stack(children: [
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 7.h,
                    child:  const EasyBannerAd(
                        adNetwork: AdNetwork.admob, adSize: AdSize.mediumRectangle),
                  ),
                  Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: 7.h,
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.yellow,
                      child: const Text(
                        "Ad",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ]),
                Padding(
                  padding:  EdgeInsets.only(left: 2.w,right: 2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                      Get.off(()=>const VideoPickerPage());
                      }, icon: const Icon(Icons.arrow_back_ios)),
                       Text('Album'.tr,style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
                SizedBox(width: 5.w,)

                    ],
                  ),
                ),
                SizedBox(height: 3.h,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Builder(
                    builder: (context) {
                      if(allPagesList2.isNotEmpty){
                      return Container(
                        height: 72.h,
                        child:isload?const Center(child: CircularProgressIndicator()): GridView.builder(

                            itemCount: allPagesList2.length>15?15:allPagesList2.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 5,),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onLongPress: (){

                                  controller = VideoPlayerController.file(File(allPagesList2[index]))
                                    ..addListener(() {
                                      setState(() {});
                                    })
                                    ..setLooping(true)
                                    ..play()
                                    ..initialize().then((_) {
                                      setState(() {
                                        // controller.play();
                                      });
                                    });
                                  Get.defaultDialog(
                                    backgroundColor: buttonColor,
                                    barrierDismissible: false,
                                    title: '${allPagesList2[index].toString().split('/Videos/')[1].split('.mp4')[0]}',
                                    content: Container(
                                          height: 40.h,
                                        width: 80.w,
                                        alignment: Alignment.center,
                                        child: Center(
                                            child: VideoPlayer(controller))),
                                    onWillPop: (){

                                      controller.dispose();
                                      Navigator.pop(context);
                                      return Future.value(true);
                                    },
                                    onCancel: (){

                                      controller.dispose();
                                      Navigator.pop(context);
                                    },
                                    cancel: InkWell(
                                      onTap: (){

                                        controller.dispose();
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 20.w,
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: buttonColor,
                                            border: Border.all(
                                              width: 1.5,
                                              color: Colors.white
                                            )
                                          ),
                                          child:  Center(child: Text('Close'.tr,style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                          ),))),
                                    )
                                  );
                                  controller.pause();

                                },
                                child: InkWell(
                                  onTap: (){
                                    Get.to(()=>Video(f: File(allPagesList2[index])));

                                  },
                                  child: Column(
                                    children: [
                                      Container(

                                        height: 19.h,
                                        width: 40.w,
                                        decoration: BoxDecoration(color: Colors.white,
                                          image: DecorationImage(image: FileImage(reversedList[index]), fit: BoxFit
                                              .fill,

                                        ),
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))

                                        ),
                                        child: const Center(child: Icon(Icons.play_circle,size: 30,)),
                                      ),
                                      Container(
                                        height: 2.h,
                                        width: 40.w,
                                        decoration:  BoxDecoration(
                                           color: buttonColor,
                                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))

                                        ),
                                        child: Center(child: Text('${allPagesList2[index].toString().split('/Videos/')[1].split('.mp4')[0]}',style: const TextStyle(fontSize: 10),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                      else{
                        return Column(

                          children: [
                            Container(
                              width: 100.w,
                              height: 40.h,
                              child: Lottie.asset(
                                'assets/noData.json',
                                  frameRate: FrameRate(60),
                                fit: BoxFit.fill,
                              ),
                            ),
                            const Text("There's nothing saved yet,\nGo and save some Videos!!!",style: TextStyle(
                              fontWeight: FontWeight.bold,letterSpacing: 2
                            ),)
                          ],
                        );
                      }
                    }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
