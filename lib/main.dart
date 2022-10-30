import 'dart:developer';
import 'dart:io';



import 'package:deepfake/Views/LandingPage.dart';
import 'package:deepfake/Views/Savedvideoplayer.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:helpers/helpers.dart'
    show OpacityTransition, SwipeTransition, AnimatedInteractiveViewer;

import 'package:sizer/sizer.dart';


import 'Ads/AdIds.dart';
import 'Binding/binding.dart';
import 'Translations/Languages.dart';
import 'Views/Home Page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyAds.instance.initialize(
    adIdManager,
    unityTestMode: true,
    adMobAdRequest: const AdRequest(),
    admobConfiguration: RequestConfiguration(testDeviceIds: [
      '072D2F3992EF5B4493042ADC632CE39F', // Mi Phone
      '00008030-00163022226A802E',
    ]),
  );
 runApp(const MyApp());}
const IAdIdManager adIdManager = TestAdIdManager();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Sizer(builder: (context, orientation, deviceType) {

        return GetMaterialApp(
          locale: Get.deviceLocale,
          translations: Languages(),
          fallbackLocale: const Locale('en', 'US'),
          builder: EasyLoading.init(),
          initialBinding: defaultBinding(),
          title: 'Deep Fake',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            textTheme: const TextTheme(
              bodyText1: TextStyle(),
              bodyText2: TextStyle(),
            ).apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,

            ),
          ),
          home: const LandingPage(),

        );

      }
    );
  }
}



