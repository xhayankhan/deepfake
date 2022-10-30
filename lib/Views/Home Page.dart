import 'dart:developer';
import 'dart:io';

import 'package:deepfake/Controllers/ImageController.dart';
import 'package:deepfake/Views/SelectImage.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:deepfake/Controllers/EditingController.dart';
import 'package:deepfake/Controllers/ServerController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sizer/sizer.dart';


import '../Constant/Constants.dart';

import '../Widgets/NavDrawer.dart';
import 'Album.dart';
import 'Video Editor Screen.dart';

class VideoPickerPage extends StatefulWidget {
  const VideoPickerPage({Key? key}) : super(key: key);

  @override
  State<VideoPickerPage> createState() => _VideoPickerPageState();
}

class _VideoPickerPageState extends State<VideoPickerPage> {

  int _current = 0;
  final CarouselController _controller = CarouselController();
  var imgList=['assets/backgroundLand.png',
    'assets/backgroundLand.png',
    'assets/backgroundLand.png'];
  EditingController edit=Get.find();
  String result = "Let's slide!";
  final ImagePicker _picker = ImagePicker();
  ImagePicker imagePicker = ImagePicker();
  var pickedFile;
  File? image1;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ServerController server=Get.find();
  ImageController imag=Get.find();
  void _pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
    print('nsdngfmksxngjxdbngdjngdjbng:${file?.path}');
    EasyLoading.show();

    if (mounted && file != null) {
      var newFile=File(file.path);
   // var filee= await compressVideo(newFile.path);


      Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  VideoEditor(file: File(file.path),width: 500,)));
      EasyLoading.dismiss();
    }
  }


  void initState(){
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    imag.fetchNewMedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),

      key: scaffoldKey,

      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image:AssetImage('assets/background.png'),fit: BoxFit.fill,filterQuality: FilterQuality.high,

            ),
            color: Colors.black
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

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
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 10.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap:(){
                              scaffoldKey.currentState?.openDrawer();
                            },
                            child: const Icon(Icons.menu,size: 30,),

                          ),
                          SizedBox(height: 5.h,)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('SWAPUP',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          SizedBox(height: 5.h,)
                        ],
                      ),

                      InkWell(
                        onTap: () async{
                              var appDir=await getApplicationDocumentsDirectory();
                              var dir2='${appDir.path}/Documents/Folders/Recents';


                              Get.to(()=>const AlbumView(),arguments: dir2);
                        },
                        child: Column(
                          children: [
                            const Icon(Icons.photo_library),
                             Text('Album'.tr,style: TextStyle(fontSize: 12),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.h,),
              Slider(),
                  SizedBox(height: 5.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Get.to(()=>const SelectImageScreen());
                        },
                        child: Container(
                          height: 8.h,
                          width: 30.w,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(40),bottomRight: Radius.circular(40)),
                            color: buttonColor
                          ),

                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/svgs/new.svg'),
                                 Text("What's New".tr)
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _pickVideo,
                        child: Container(
                          height: 8.h,
                          width: 30.w,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(40),bottomLeft: Radius.circular(40)),
                              color: buttonColor
                          ),

                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               const Icon(Icons.local_fire_department),
                                 Text("What's Hot".tr)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
              // const Text(
              //   "Click on Pick Video to select video",
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 18.0,
              //   ),
              // ),
              // ElevatedButton(
              //   onPressed: _pickVideo,
              //   child: const Text("Pick Video From Gallery"),
              // ),


            ],
          ),
        ),
      ),
    );
  }
  Widget Slider(){

    final List<Widget> imageSliders = imgList
        .map((item) {

      return  InkWell(
        onTap: (){

          Get.to(()=>VideoEditor(file: File(item), width: 500));
        },
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(40.0)),
            child:Container(
      height: 30.h,
      width: 80.w,
                color: Colors.white,child: Stack(
              fit: StackFit.expand,

              children: [

                Container(
                    height: 30.h,
                    width: 80.w,
                      color: Colors.black,
                    child: Image.asset(item,fit: BoxFit.cover,)),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.center,
                      height: 5.h,
                      width: 30.w,
                      decoration: BoxDecoration(
                        color: Colors.black26
                      ),
                      child: Text('Description ',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),),
              ],
            )),)

      );})
        .toList();
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 45.h,
            onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });


            },
            autoPlay: false,
            aspectRatio: 2,
            enlargeCenterPage: true,
          ),
          items: imageSliders,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:  carasol.withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );


  }

}