import 'package:deepfake/Controllers/EditingController.dart';
import 'package:deepfake/Controllers/ServerController.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';
import 'package:sizer/sizer.dart';
import 'package:slidable_button/slidable_button.dart';

import 'Home Page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  EditingController edit=Get.find();
  ServerController server=Get.find();
  @override
  void initState(){
    server.permissionCheck();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
              Container(
                height: 83.h,
                child: Stack(
                  children: [


                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:AssetImage('assets/backgroundLand.png'),fit: BoxFit.fill,filterQuality: FilterQuality.high
                        ),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 5.w,),
                              const Text('Version: 1.0.1'),
                              InkWell(
                                onTap: (){
                                  _openLanguagePickerDialog();
                                },
                                  child: const Icon(Icons.translate_sharp))
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(left: 6.w),
                                child: Container(
                                  height: 12.h,

                                  width: 65.w,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image:AssetImage('assets/appName.png'),fit: BoxFit.fill,filterQuality: FilterQuality.high
                                    ),
                                  ),

                                ),
                              ),


                            ],
                          ),

                          Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(left: 10.w,top: 10.h),
                                child: Container(
                                  height: 9.h,
                                  width: 55.w,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image:AssetImage('assets/entertainment.png'),fit: BoxFit.fill,filterQuality: FilterQuality.high
                                    ),
                                  ),

                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 10.w),
                                child: const Text('Swap images on any video you want.',style: TextStyle(fontSize: 14),),
                              ),
                              SizedBox(height: 4.h,),
                              HorizontalSlidableButton(
                                height: 7.h,
                                width: 90.w,
                                buttonWidth: 60.0,
                                color:Colors.grey[800],

                                dismissible: false,

                                label: Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Container(height:35,
                                    width:35,
                                    decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        image: DecorationImage(image: AssetImage('assets/face.png',),fit: BoxFit.fill)
                                    ),
                                  ),
                                ),
                                child:

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                   SizedBox(width: 8.w,),
                                    Row(
                                      children: [
                                        Text("Let's Start".tr,style: const TextStyle(
                                          fontWeight: FontWeight.bold,fontSize: 16
                                        ),),
                                        Image.asset('assets/arrow.png',color: Colors.white,height: 40,)
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0,bottom: 3),
                                      child: Container(height:300,width:50, decoration: const BoxDecoration(
                                          image: DecorationImage(image: AssetImage('assets/face2.png',
                                          ),fit: BoxFit.fill)
                                      ),),
                                    ),
                                  ],
                                ),

                                onChanged: (position) {
                                  setState(() {
                                    if (position == SlidableButtonPosition.end) {
                                      Get.to(()=>const VideoPickerPage());
                                    } else {
                                      // result = 'Button is on the left';
                                    }
                                  });
                                },
                              ),
                              SizedBox(height: 2.h,),
                              Text('Privacy Policy'.tr),
                              SizedBox(height: 2.h,),
                            ],
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
  void _openLanguagePickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: LanguagePickerDialog(
            languages: edit.supportedLanguages,
            titlePadding: const EdgeInsets.all(8.0),
            title: const Text('Select your language'),
            onValuePicked: (Language language) => setState(() {
              //Constants.currentlang = language.isoCode;
              Get.updateLocale(Locale(language.isoCode));
            }),
            itemBuilder: _buildDialogItem)),
  );
  Widget _buildDialogItem(Language language) => Row(
    children: <Widget>[
      Text(language.name),
      const SizedBox(width: 8.0),
      //Flexible(child: Text("(${language.name})"))
    ],
  );
}
