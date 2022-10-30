import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:deepfake/Controllers/EditingController.dart';
import 'package:deepfake/Controllers/ImageController.dart';
import 'package:deepfake/Widgets/GridViewOfGallery.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:image/image.dart' as imglib;

import '../Constant/Constants.dart';
import 'FolderView.dart';

class SelectImageScreen extends StatefulWidget {
  const SelectImageScreen({Key? key}) : super(key: key);

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  EditingController edit=Get.find();
  final ImagePicker _picker = ImagePicker();
  ImagePicker imagePicker = ImagePicker();
  var pickedFile;
  File? image1;
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios)),
                    Text('Select Image'.tr,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),),
                 SizedBox(
                   width: 10.w,
                 )

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 66.h,

                    child:  GetBuilder<ImageController>(
                        init:ImageController(),
                        builder: (context) {return GridGallery();}
                    )
                ),
              ),
              Container(
                height: 9.h,
                width: 95.w,
                decoration:  BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(40)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: 10.w ,right:10.w ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async{
                              var pickedFile = await imagePicker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 60,);
                                      log('after picked');
                                      if(pickedFile!=null) {
                                        image1 = File(pickedFile.path);
                                        log(image1.toString());
                                        await EasyLoading.show(
                                          status: 'Loading...',);
                                        Uint8List uint8list = Uint8List
                                            .fromList(
                                            image1!.readAsBytesSync());
                                        // String? imagePath = await EdgeDetection.detectEdge;
                                        imglib.Image? image = imglib
                                            .decodeImage(uint8list);
                                        await edit.imgTofile(image!);
                                        EasyLoading.dismiss();
                                        var file = await edit.cropImage(
                                            image1!, false);
                                      }},
                            child: Column(
                              children: [
                                Icon(Icons.image_outlined),
                                Text('Gallery'.tr)
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () async{
                                   var version=11.0;
                                  var tr= await Permission.storage.isGranted;
                                  var tra= await Permission.storage.status.isGranted;
                                  if(Platform.isAndroid){
                                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                                    version=double.parse(androidInfo.version.release.toString());
                                    print(version.runtimeType);
                                    print("Android ${version} on ${androidInfo.model}"); // e.g. "Moto G (4)"
                                    print(Platform.operatingSystem);
                                  }
                                  if(tr==true||version<11.0){

                                    var pickedFile = await imagePicker.pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 40,);
                                    if(pickedFile!=null){
                                      var img=File(pickedFile.path);
                                      await EasyLoading.show(indicator: CircularProgressIndicator());
                                      Uint8List uint8list = Uint8List.fromList(
                                          img.readAsBytesSync());

                                      imglib.Image? image = imglib.decodeImage(uint8list);
                                      await edit.imgTofile(image!);
                                      EasyLoading.dismiss();

                                     // EasyLoading.dismiss();

                                    }

                                  }
                                  else{
                                    Get.defaultDialog(
                                        backgroundColor: Colors.white,
                                        title: 'Permission Required',
                                        titleStyle: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold
                                        ),
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              Text('We need camera permission in order to take images from your Camera to get text from them',style: TextStyle(color: Colors.blue),),
                                              Text('Go to',style: TextStyle(color: Colors.blue),),
                                              Text('Settings>Apps>Micro Scanner>Permissions',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14),),
                                              Text('and allow Camera Permission',style: TextStyle(color: Colors.blue),),

                                            ],
                                          ),
                                        ),
                                        confirm: InkWell(
                                          onTap: () async{
                                            Navigator.pop(context);
                                            PhotoManager.openSetting();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Container(
                                              height: 30,
                                              width: 80,
                                              child:  Center(
                                                child: Text('Ok'.tr,style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                          ),
                                        ),
                                        cancel: InkWell(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Fluttertoast.showToast(
                                                msg: "Camera permission was not allowed",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 80,
                                            decoration: BoxDecoration(

                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Colors.blue,width: 1)

                                            ),
                                            child:  Center(child: Text('Cancel'.tr,style: TextStyle(color: Colors.blue),)),
                                          ),
                                        )
                                    );

                                  }

                            },
                            child: Column(
                              children: [
                                Icon(Icons.camera_alt_outlined),
                                Text('Camera'.tr)
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async{

                              var appDir=await getApplicationDocumentsDirectory();
                                  var dir2='${appDir.path}/Documents/Folders/Recents';


                                  Get.to(()=>FolderView(),arguments: dir2);
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/svgs/recent.svg'),
                                Text('Recents'.tr)
                              ],
                            ),
                          ),
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
}
