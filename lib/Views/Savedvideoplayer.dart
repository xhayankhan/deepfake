// ignore_for_file: file_names

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:deepfake/Controllers/ImageController.dart';
import 'package:deepfake/Controllers/ServerController.dart';
import 'package:deepfake/Views/Album.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../Constant/Constants.dart';
import '../main.dart';
import 'Video Editor Screen.dart';

class Video extends StatefulWidget {
  File f;
  Video({Key? key, required this.f}) : super(key: key);

  @override
  State<Video> createState() => VideoState();
}

class VideoState extends State<Video> {
  bool isdouble = true;
  bool isvisible = true;
  TextEditingController name=TextEditingController();
  late VideoPlayerController controller;
  ServerController server=Get.find();
  ImageController imge=Get.find();
  var album=false;
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
    controller = VideoPlayerController.file(widget.f)
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
    var alb;
    if (Platform.isAndroid) {
      alb = widget.f.path.toString().contains('cache');
      if (alb == true) {
        setState(() {
          album = false;
        });
      }
      else {
        setState(() {
          album = true;
        });
      }
      print('asdfghjkl:${widget.f}');
    }
    else if(Platform.isIOS){
      alb = widget.f.path.toString().contains('Caches');

      if (alb == true) {
        setState(() {
          album = false;
        });
      }
      else {
        setState(() {
          album = true;
        });
      }
      print('asdfghjkl:${widget.f}');
    }
    }
  @override
  Widget build(BuildContext context) {
    bool ismuted = controller.value.volume == 0;
    return Scaffold(
      body: Container(
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
                  child:  EasyBannerAd(
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
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios)),
                    const Text('Video Preview',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),),
                        SizedBox(width: 10.w,)

                  ],
                ),
              ),
              SizedBox(height: 10.h,),
              Container(
                height: 50.h,
                width: 95.w,
                child: Stack(
                  children: [
                    controller != null && controller.value.isInitialized
                        ? Stack(children: [
                      Row(
                          children:[Expanded(
                                    child: AspectRatio(
                                        aspectRatio:
                                                    controller.value.aspectRatio,
                                        child: VideoPlayer(controller))
                                )

                          ]),
                      Center(child: controller.value.isPlaying?const Text(''):const Icon(Icons.play_circle,size: 40,)),
                      Positioned.fill(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTapDown: (tap){
                                setState(() {
                                  isvisible=true;
                                });
                            },
                            onTapCancel: (){
                              Future.delayed(const Duration(milliseconds: 3000)).then((value){
                                setState(() {
                                isvisible=false;
                              });
                              });
                            },
                            onTap: () {

                                if(controller.value.isPlaying){
                                  setState(() {
                                    controller.pause();

                                  });
                                }else{
                                  setState(() {
                                    controller.play();
                                  });
                                }

                              // isvisible == true
                              //     ? isvisible = false
                              //     : isvisible = true;

                              setState(() {});
                            },
                            child: Stack(
                              children: [

                                Visibility(
                                  visible: isvisible,
                                  child: Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Row(children: [
                                        GestureDetector(
                                          onTap: () {
                                            controller.value.isPlaying
                                                ? controller.pause()
                                                : controller.play();
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: Icon(
                                                controller.value.isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: 40,
                                                color: Colors.white,
                                              )),
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: controller,
                                          builder: (context, VideoPlayerValue value,
                                              child) {
                                            //Do Something with the value.
                                            return Text(value.position
                                                .toString()
                                                .split(".")[0]);
                                          },
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: VideoProgressIndicator(controller,
                                                colors: VideoProgressColors(
                                                    playedColor: Colors.red,
                                                    backgroundColor: Colors.white12,
                                                    bufferedColor:
                                                    Colors.grey.shade600),
                                                allowScrubbing: true),
                                          ),
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: controller,
                                          builder: (context, VideoPlayerValue value,
                                              child) {
                                            //Do Something with the value.
                                            return Text(value.duration
                                                .toString()
                                                .split(".")[0]);
                                          },
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ])
                        : const Center(
                      child: SizedBox(
                          height: 200,
                          child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueGrey,
                                strokeWidth: 2,
                              ))),
                    ),
                    if (controller.value.isInitialized)
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Visibility(
                              //   visible: isvisible,
                              //   child: InkWell(
                              //       onTap: () {
                              //         Navigator.pop(context);
                              //       },
                              //       child: const Icon(Icons.arrow_back_ios)),
                              // ),
                              Visibility(
                                visible: isvisible,
                                child: InkWell(
                                  onTap: () {
                                    if (isdouble) {
                                      isdouble = false;
                                    } else {
                                      isdouble = true;
                                    }
                                    setState(() {});
                                    //controller.setVolume(ismuted ? 1 : 0);
                                  },
                                  child: SizedBox(
                                    height: 5.h,
                                    width: 5.h,

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(height:8.h),
          Container(
            height: 8.h,
            width:95.w,
            decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(40)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 8.0.w,right: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // InkWell(
                      //   onTap: ()async{
                      //
                      //     await imgTofile(widget.f);
                      //     await GallerySaver.saveVideo(widget.f.path,albumName: 'Deep Fake').then((bool? success) {
                      //       Get.off(()=>AlbumView());
                      //       print(success.toString());
                      //     });
                      //   },
                      //   child: Column(
                      //     children: [
                      //       Icon(Icons.save_outlined),
                      //       Text('Save')
                      //
                      //     ],
                      //   ),
                      // ),
                      InkWell(
                        onTap: ()async{

                          imge.share(widget.f.path);
                        },
                        child: Column(
                          children: [
                            const Icon(Icons.share),
                             Text('Share'.tr)

                          ],
                        ),
                      ),

                      album==false? InkWell(
                        onTap: ()async{
                          name.text='SU_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}-${DateTime.now().microsecond}';
                          if(Platform.isAndroid) {
                            // Get.defaultDialog(
                            //   backgroundColor: buttonColor,
                            //   title: "Video Name",
                            //   titleStyle: TextStyle(
                            //       fontWeight: FontWeight.bold, color: darkBlue),
                            //   content: Padding(
                            //     padding: const EdgeInsets
                            //         .all(8.0),
                            //     child: TextFormField(
                            //       style: const TextStyle(
                            //           color: Colors.white),
                            //       decoration: InputDecoration(
                            //         prefixIcon: Padding(
                            //           padding: const EdgeInsets
                            //               .all(8.0),
                            //           child: Icon(Icons.video_camera_front),
                            //         ),
                            //         fillColor: buttonColor,
                            //
                            //         border: OutlineInputBorder(
                            //           borderRadius: BorderRadius
                            //               .circular(10.0),
                            //         ),
                            //         filled: true,
                            //         labelStyle: TextStyle(
                            //             color: Colors.white),
                            //         labelText: 'New Name',
                            //
                            //       ),
                            //       //onTap: () => name.selection = TextSelection(baseOffset: 0, extentOffset: name.value.text.length),
                            //       controller: name,
                            //     ),
                            //   ),
                            //
                            //
                            //   confirm: InkWell(
                            //     onTap: () async {
                            //       var a = await imgTofile(
                            //           widget.f, name.text.toString());
                            //       print('adsasadsa:$a');
                            //       await GallerySaver.saveVideo(
                            //           widget.f.path, albumName: 'SwapUp').then((
                            //           bool? success) {
                            //         Get.off(() => const AlbumView());
                            //         print(success.toString());
                            //       });
                            //     },
                            //     child: Container(
                            //         margin: EdgeInsets.only(top: .8.h),
                            //         width: 80,
                            //         height: 4.5.h,
                            //         decoration: BoxDecoration(
                            //           color: Colors.green,
                            //           borderRadius: BorderRadius.circular(10),
                            //
                            //         ),
                            //
                            //         child: Center(child: Text('Ok'.tr),)
                            //     ),
                            //   ),
                            //   cancel: InkWell(
                            //     onTap: () {
                            //       Navigator.of(
                            //           Get.overlayContext!, rootNavigator: true)
                            //           .pop();
                            //     },
                            //     child: Container(
                            //       margin: EdgeInsets.only(top: .8.h),
                            //       width: 80,
                            //       height: 4.5.h,
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10),
                            //         border: Border.all(
                            //             color: darkBlue,
                            //             width: 1
                            //         ),
                            //       ),
                            //       child: Center(child: Text('Cancel'.tr,
                            //         style: TextStyle(color: darkBlue),),),
                            //     ),
                            //   ),);
                            var a = await imgTofile(
                                widget.f, name.text.toString());
                            print('adsasadsa:$a');
                            await GallerySaver.saveVideo(
                                widget.f.path, albumName: 'SwapUp').then((
                                bool? success) {
                              Get.off(() => const AlbumView());
                              print(success.toString());
                            });
                          }
                          else{
                            var a = await imgTofile(
                                widget.f, name.text.toString());
                            print('adsasadsa:$a');
                            await GallerySaver.saveVideo(
                                widget.f.path, albumName: 'SwapUp').then((
                                bool? success) {
                              Get.off(() => const AlbumView());
                              print(success.toString());
                            });
                          }
                        },
                        child: Column(
                          children:  [
                            Icon(Icons.save_outlined),
                            Text('Save'.tr)

                          ],
                        ),
                      ):InkWell(
                        onTap: () async{
                          Get.defaultDialog(
                            backgroundColor: buttonColor,
                            title: "Are you sure?".tr,
                            titleStyle:  TextStyle(fontWeight: FontWeight.bold,color: darkBlue),
                            content:  Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("This item will be deleted from app, You won't be able to restore this item.".tr)),


                            confirm: InkWell(
                              onTap: () async{
                                Navigator.pop(context);
                                await server.deleteFile(widget.f).then((value) {
                                  Get.snackbar('Success'.tr, 'Video Deleted Successfully!!!'.tr,snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red);
                                });
                                Get.off(()=>const AlbumView());
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: .8.h),
                                  width: 80,
                                  height: 4.5.h,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),

                                ),

                                child:  Center(child: Text('Ok'.tr),)
                              ),
                            ),
                            cancel: InkWell(
                              onTap: () {
                                Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: .8.h),
                                width: 80,
                                height: 4.5.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: darkBlue,
                                      width: 1
                                  ),
                                ),
                                child:  Center(child: Text('Cancel'.tr,style: TextStyle(color: darkBlue),),),
                              ),
                            ),);

                        },
                        child: Column(
                          children: [
                            const Icon(Icons.delete),
                             Text('Delete'.tr)

                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          controller.pause();
                          var tempDir= await getTemporaryDirectory();
                          var random= Random().nextInt(100000);
                          final myImagePath = "${tempDir.path}";
                          Directory documentFile = Directory(myImagePath);
                          if (!await documentFile.exists()) {
                            documentFile.create(recursive: true);
                          }
                          final fullPath =
                              '${tempDir.path}/SU${DateTime.now().millisecondsSinceEpoch}$random.mp4';
                          final imgFile = File('$fullPath');
                          Uint8List uint8list = Uint8List.fromList(widget.f.readAsBytesSync());
                          imgFile.writeAsBytes(uint8list);
                          print('asasdasdasdasdasdasdasdasd$imgFile');

                          Get.to(()=>VideoEditor(file: imgFile,width: 500,));
                        },
                        child: Column(
                          children: [
                           SvgPicture.asset('assets/svgs/edit.svg',height:24,width: 24,),
                             Text('Edit'.tr)

                          ],
                        ),
                      ),

                      // edit.undo.isEmpty?Container(width: 0,) :Expanded(
                      //    child: IconButton(
                      //      onPressed: ()
                      //      {
                      //        setState((){
                      //          _controller=edit.undo.last;
                      //        });
                      //      },
                      //      icon: const Icon(Icons.undo, color: Colors.white),
                      //    ),
                      //  ),

                      // Expanded(
                      //   child: IconButton(
                      //     onPressed: (){
                      //       if(textoptions==true){
                      //         setState((){
                      //           textoptions=false;
                      //         });
                      //       }
                      //       else{
                      //         setState((){
                      //           textoptions=true;
                      //         });
                      //       }
                      //     },
                      //     icon: const Icon(Icons.text_fields),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),

            ],
          ),
        ),
      ),
    );
  }
  imgTofile(File file,String vidName) async {

    Directory? directory = await getApplicationDocumentsDirectory();

    bool directoryExists =
    await Directory('${directory.path}/Videos').exists();

    if (!directoryExists) {
      print("\n Directory not exist");
      //  navigateToShowPage(path, -1);
      await Directory('${directory.path}/Videos').create(recursive: true);

      //Getting all images of chapter from firectory

    }
      var random= Random().nextInt(10000);
    print("\n direcctoryb = ${directory}");
    final fullPath =
        '${directory.path}/Videos/$vidName.mp4';
    final imgFile = File('$fullPath');
    Uint8List uint8list = Uint8List.fromList(file.readAsBytesSync());
  imgFile.writeAsBytes(uint8list);

    return imgFile;

  }
  Future<Duration?> getduration() async {
    Duration? duration = await controller.position;
    return duration;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    controller.dispose();
  }
}