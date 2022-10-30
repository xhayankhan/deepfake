import 'package:deepfake/Controllers/EditingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';

import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../Constant/Constants.dart';
import '../Controllers/ServerController.dart';





class NavDrawer extends StatefulWidget {


  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
ServerController server=Get.find();
EditingController edit=Get.find();
@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.transparent,
        child: Container(

          decoration: BoxDecoration(
              color: buttonColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(40),bottomRight: Radius.circular(40))
          ),
          child: Column(

            children: [

                  Container(
                    decoration: const BoxDecoration(

                    ),
                  height: 25.h,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                              height: 15.h,
                                width: 60.w,
                                child:Image.asset('assets/menuLogo.png'))
                          ],
                        ),

                        const Text(
                          'Version: 1.0.1',style:  TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 60.w,
                    child: Divider(color: Colors.white,thickness: 2,)),

              Container(
                    height: 62.h,

                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[



                    const SizedBox(height: 10,),






                    ListTile(
                      leading:  Icon(Icons.privacy_tip,color: darkBlue),
                      title: Text('Privacy Policy'.tr,style:  TextStyle(color: darkBlue),),
                      onTap: () async {
                        Get.defaultDialog(
                          backgroundColor: darkBlue,
                          title: "Privacy Policy",
                          titleStyle:  TextStyle(fontWeight: FontWeight.bold,color: darkBlue),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40.h,
                                width: 80.w,
                                child: ListView(
                              children: [
Text('BY ACCESSING OR USING THE Appexsoft Account, YOU AGREE TO BE BOUND BY THE TERMS AND CONDITIONS DESCRIBED HEREIN AND ALL TERMS AND CONDITIONS INCORPORATED BY REFERENCE. THIS PRIVACY POLICY IS PART OF AND INCORPORATED INTO Appexsoft account TERMS OF SERVICE (\"Terms of Service\"). IF YOU DO NOT AGREE TO ALL OF THE TERMS AND CONDITIONS SET FORTH BELOW, YOU MAY NOT USE THE Appexsoft account APPS. By using the account (or just \"the App\" hereafter) in any manner, you acknowledge that you accept the practices and policies outlined in this Privacy Policy, and you hereby consent that we will collect, use, process and share your information as described herein. This Privacy Policy covers our treatment of information that we gather when you are accessing or using our Services. This policy does not apply to the practices of companies that we do not own or control (including, without limitation, the third party content providers from whom you may receive content through the Services), or to individuals that we do not employ or manage. APPS at Appexsoft on Google Play (“Company,” “we,” “us,” “our”) provide you a comprehensive platform Specifically we collect following information necessary for the proper functionality of the App. Our privacy practices will be transparent to you. However we collect only minimal information essentially required for correct functionality of the App, the features of which have been adequately described to the user through Google Play. When you utilize our services, you’re trusting us with your information therefore we understand this is a major obligation and work hard to ensure your data and place you in charge and no piece of information regarding your privacy will NOT be given to third party without your consent under any circumstances')                            ],
                            )),
                          ),                        radius: 20.0,
                          confirm: Container(
                            width: 100,
                            child: ElevatedButton(onPressed: () async {
                              Navigator.pop(context);
                              final Uri url = Uri.parse('https://sites.google.com/view/microscanappex/home');

                              //server.launchUrl1(url);
                            },
                              child: const Center(child: Text('See more'),),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    darkBlue),),),
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
                              child:  Center(child: Text('Cancel',style: TextStyle(color: darkBlue),),),
                            ),
                          ),);

                      },
                    ),

                    // ListTile(
                    //   leading: Icon(Icons.book,color: darkBlue),
                    //   title: Text('Terms of Services'.tr,
                    //     style: TextStyle(color: darkBlue),),
                    //   onTap: () async {
                    //
                    //   },
                    // ),
                    ListTile(
                      leading:  Icon(Icons.apps,color: darkBlue),
                      title: Text('More Apps'.tr,
                        style:  TextStyle(color: darkBlue),),
                      onTap: () async {
                        final Uri url = Uri.parse('https://play.google.com/store/apps/dev?id=4730059111577040107');

                        //server.launchUrl1(url);
                      },
                    ),
                    ListTile(
                      leading:  Icon(Icons.translate_sharp,color: darkBlue),
                      title: Text('Languages'.tr,
                        style:  TextStyle(color: darkBlue),),
                      onTap: () async {
                  _openLanguagePickerDialog();
                        //server.launchUrl1(url);
                      },
                    ),
                    ListTile(
                      leading:  Icon(Icons.share,color: darkBlue),
                      title: Text('Share App'.tr,
                        style:  TextStyle(color: darkBlue),),
                      onTap: () async {
                        Share.share('Try this app,\nhttps://play.google.com/store/apps/details?id=com.appexsoft.microscan.image.to.text');

                      },
                    ),

                    ListTile(
                      leading:  Icon(Icons.star,color: darkBlue,),
                      title: Text('Rate App'.tr,
                        style:  TextStyle(color: darkBlue),),
                      onTap: () async {
                        final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.appexsoft.microscan.image.to.text');

                       // server.launchUrl1(url);
                      },
                    ),

                    ListTile(
                      leading:  Icon(Icons.rate_review,color: darkBlue,),
                      title: Text('Feedback'.tr,
                        style:  TextStyle(color: darkBlue),),
                      onTap: () async {
                      final Email email = Email(

                      subject: 'FeedBack For Micro Scan App ',
                      recipients: ['appexsoft@gmail.com'],

                      isHTML: false,
                      );

                      await FlutterEmailSender.send(email);


                      },
                    ),


                    ListTile(
                      leading:  Icon(Icons.exit_to_app,color: darkBlue,),
                      title: Text('Exit'.tr,
                        style:  TextStyle(color: darkBlue),),
                      onTap: () async {
                    // `folder.openDialog(context);`
                      },
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
