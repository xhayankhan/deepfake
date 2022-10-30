import 'dart:developer';
import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

class FolderView extends StatefulWidget {
  const FolderView({Key? key}) : super(key: key);

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {

  List allPagesList = [];
  List allPagesList2 = [];
  List reversedList=[];

  var folderName;
  List docx=[];
  List folders=[];
  var ImagesPath ;
  Directory? dir2 ;
  var foldersPath ;
  Directory? dirFolder ;
  var recents=false;
  var args=Get.arguments;
  @override
  void initState(){


    super.initState();
 getData();
    folderName=args.toString().split('/Folders/')[1];
    if(folderName.toString().contains('Recents')){
      recents=true;
    }
    log(folderName);

  }
  void getData() async {
    allPagesList2.clear();
    allPagesList.clear();

    var appDir=await getApplicationDocumentsDirectory();
    dir2=Directory('$args/');
    ImagesPath='$args/';

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
    reversedList=allPagesList2.reversed.toList();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
              Container(
                height: 10.h,

                child: Padding(
                  padding:  EdgeInsets.only(left: 2.w,right: 2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios)),
                      Text('Recents'.tr,style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
                SizedBox(width: 10.w,),

                    ],
                  ),
                ),
              ),

          Builder(
            builder: (context) {
              if(allPagesList2.isNotEmpty){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70.h,
                  child: GridView.builder(

                  itemCount: allPagesList2.length>15?15:allPagesList2.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.65.h/0.7.h),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){

                                arguments: allPagesList2[index];
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(allPagesList2[index]),   fit: BoxFit
                                .cover,
                              height: 60,
                              width: 40,),
                          ),
                        );
                      }),
                ),
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
                    Text("There's no recently picked Images",style: TextStyle(
                        fontWeight: FontWeight.bold,letterSpacing: 2
                    ),)
                  ],
                );
              }
            }
          )
            ],
          ),
        ),
      ),
    );
  }
}
