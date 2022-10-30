import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:language_picker/languages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:image/image.dart' as imglib;

class EditingController extends GetxController{

  final supportedLanguages = [
    Languages.english,
    Languages.french,
    Languages.spanish,
    Languages.portuguese,
    Languages.chineseSimplified,
    //Languages.arabic,
    //Languages.urdu,

  ];
  String velocity = "VELOCITY";
  late VideoPlayerController videoPlayerController;
  RxList undo=[].obs;
  CroppedFile? _croppedFile;

@override
void initState(){

  super.onInit();
}


  imgTofile(imglib.Image image) async {

    Directory? directory = await getApplicationDocumentsDirectory();

    bool directoryExists =
    await Directory('${directory.path}/Pictures/Folders/Recents').exists();

    if (!directoryExists) {
      print("\n Directory not exist");
      //  navigateToShowPage(path, -1);
      await Directory("${directory.path}/Documents/Folders/Recents").create(recursive: true);

      //Getting all images of chapter from firectory

    }

    print("\n direcctoryb = ${directory}");
    final fullPath =
        '${directory.path}/Documents/Folders/Recents/DF ${DateTime
        .now()}.png';
    final imgFile = File('$fullPath');
    log(imgFile.path);
    imgFile.writeAsBytesSync(imglib.encodePng(image));
    return imgFile;

  }
  Future<void> cropImage(File pickedFile, bool camera) async {
    if (pickedFile != null&&camera==false) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.black,
              backgroundColor: Colors.white,
              statusBarColor: Colors.black,

              cropFrameColor: Colors.black,
              cropGridColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Crop Image',
          ),

        ],
      );
      if (croppedFile != null) {

        _croppedFile = croppedFile;


      }


    }
    else{

    }


  }

  compressVideo(String path) async{
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.Res1280x720Quality,
      deleteOrigin: false,
      includeAudio: true,// It's false by default
    );


    return mediaInfo?.path;
  }

}