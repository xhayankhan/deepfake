import 'dart:io';

import 'package:deepfake/Views/Savedvideoplayer.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:helpers/helpers/transition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/ui/cover/cover_selection.dart';
import 'package:video_editor/ui/cover/cover_viewer.dart';
import 'package:video_editor/ui/crop/crop_grid.dart';
import 'package:video_editor/ui/trim/trim_slider.dart';
import 'package:video_editor/ui/trim/trim_timeline.dart';
import 'package:video_player/video_player.dart';

import '../Constant/Constants.dart';
import '../Controllers/EditingController.dart';
import 'VideoCropScreen.dart';

class VideoEditor extends StatefulWidget {
  final double width;
  const VideoEditor({Key? key, required this.file,required this.width}) : super(key: key);

  final File file;

  @override
  State<VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  final List<Color> _colors = [
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 128, 0),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 128, 255, 0),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 0, 255, 128),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 0, 128, 255),
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 127, 0, 255),
    Color.fromARGB(255, 255, 0, 255),
    Color.fromARGB(255, 255, 0, 127),
    Color.fromARGB(255, 128, 128, 128),
  ];
  double x=100;
  double y=100;
  double _colorSliderPosition = 0;
  double _shadeSliderPosition=0.0;
  Color _currentColor=Colors.white;
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;
  TextEditingController text=TextEditingController();
  bool _exported = false;
  String _exportText = "";
  bool textoptions=false;
  var tempDir;
  EditingController edit=Get.put(EditingController());
  late VideoEditorController _controller;

  RxDouble textSize=12.0.obs;
  Color shadedColor=Colors.deepPurple;
  @override
  void initState() {

    _controller = VideoEditorController.file(widget.file,
        maxDuration: const Duration(seconds: 30))
      ..initialize().then((_) => setState(() {}));
    _currentColor = _calculateSelectedColor(_colorSliderPosition);
    _shadeSliderPosition = widget.width / 2; //center the shader selector
    shadedColor = _calculateShadedColor(_shadeSliderPosition);
    //createDriectory();
    super.initState();
  }
  // createDriectory() async{
  //   tempDir=await getApplicationDocumentsDirectory();
  //   await Directory('${tempDir.path}/Videos/').create();
  //   await File('${tempDir.path}/Videos/${DateTime.now().millisecondsSinceEpoch}newfile.mp4').create();
  //
  //   final myImagePath = "${tempDir}/Documents/Folders/Saved";
  //   File documentFile = File(myImagePath);
  //   if (!await documentFile.exists()) {
  //     documentFile.create(recursive: true);
  //   }
  // }
  _colorChangeHandler(double position) {
    //handle out of bounds positions
    if (position > widget.width) {
      position = widget.width;
    }
    if (position < 0) {
      position = 0;
    }
    print("New pos: $position");
    setState(() {
      _colorSliderPosition = position;
      _currentColor = _calculateSelectedColor(_colorSliderPosition);
      shadedColor = _calculateShadedColor(_shadeSliderPosition);
    });
  }
  _shadeChangeHandler(double position) {
    //handle out of bounds gestures
    if (position > widget.width) position = widget.width;
    if (position < 0) position = 0;
    setState(() {
      _shadeSliderPosition = position;
      shadedColor = _calculateShadedColor(_shadeSliderPosition);
      print(
          "r: ${shadedColor.red}, g: ${shadedColor.green}, b: ${shadedColor.blue}");
    });
  }
  Color _calculateShadedColor(double position) {
    double ratio = position / widget.width;
    if (ratio > 0.5) {
      //Calculate new color (values converge to 255 to make the color lighter)
      int redVal = _currentColor.red != 255
          ? (_currentColor.red +
          (255 - _currentColor.red) * (ratio - 0.5) / 0.5)
          .round()
          : 255;
      int greenVal = _currentColor.green != 255
          ? (_currentColor.green +
          (255 - _currentColor.green) * (ratio - 0.5) / 0.5)
          .round()
          : 255;
      int blueVal = _currentColor.blue != 255
          ? (_currentColor.blue +
          (255 - _currentColor.blue) * (ratio - 0.5) / 0.5)
          .round()
          : 255;
      return Color.fromARGB(255, redVal, greenVal, blueVal);
    } else if (ratio < 0.5) {
      //Calculate new color (values converge to 0 to make the color darker)
      int redVal = _currentColor.red != 0
          ? (_currentColor.red * ratio / 0.5).round()
          : 0;
      int greenVal = _currentColor.green != 0
          ? (_currentColor.green * ratio / 0.5).round()
          : 0;
      int blueVal = _currentColor.blue != 0
          ? (_currentColor.blue * ratio / 0.5).round()
          : 0;
      return Color.fromARGB(255, redVal, greenVal, blueVal);
    } else {
      //return the base color
      return _currentColor;
    }
  }
  Color _calculateSelectedColor(double position) {
    //determine color
    double positionInColorArray =
    (position / widget.width * (_colors.length - 1));
    print(positionInColorArray);
    int index = positionInColorArray.truncate();
    print(index);
    double remainder = positionInColorArray - index;
    if (remainder == 0.0) {
      _currentColor = _colors[index];
    } else {
      //calculate new color
      int redValue = _colors[index].red == _colors[index + 1].red
          ? _colors[index].red
          : (_colors[index].red +
          (_colors[index + 1].red - _colors[index].red) * remainder)
          .round();
      int greenValue = _colors[index].green == _colors[index + 1].green
          ? _colors[index].green
          : (_colors[index].green +
          (_colors[index + 1].green - _colors[index].green) * remainder)
          .round();
      int blueValue = _colors[index].blue == _colors[index + 1].blue
          ? _colors[index].blue
          : (_colors[index].blue +
          (_colors[index + 1].blue - _colors[index].blue) * remainder)
          .round();
      _currentColor = Color.fromARGB(255, redValue, greenValue, blueValue);
    }
    return _currentColor;
  }
  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openCropScreen() => Navigator.push(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              CropScreen(controller: _controller)));

  void _exportVideo() async {
    print('asdasdasdsadsadsadsadsadsda: ${_controller.video.dataSource.toString()}');

    _exportingProgress.value = 0;
    _isExporting.value = true;
    // NOTE: To use `-crf 1` and [VideoExportPreset] you need `ffmpeg_kit_flutter_min_gpl` package (with `ffmpeg_kit` only it won't work)
    await _controller.exportVideo(
      // preset: VideoExportPreset.medium,
      // customInstruction: "-crf 17",
      onProgress: (stats, value) => _exportingProgress.value = value,
      onError: (e, s) => _exportText = "Error on export video :(",

      onCompleted: (file) async{

        var a=_controller.getMetaData(onCompleted: (a){
          print('hahahahahahahahahaah: $a');
        });
        print("aghwgshghghgdhgdhsgddddddddhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh${file.path}");
        _isExporting.value = false;
        if (!mounted) return;
        // var tempDir = await getApplicationDocumentsDirectory();

        final VideoPlayerController videoController =
        VideoPlayerController.file(file);

        Get.to(()=>Video(f: file));
        var path1=file.path;



        _exportText = "Video success export!";
        setState(() => _exported = true);

        Future.delayed(const Duration(seconds: 2),
                () => setState(() => _exported = false));

      },

    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image:AssetImage('assets/background.png'),fit: BoxFit.fill,filterQuality: FilterQuality.high,

            ),
            color: Colors.black
        ),
            child: SafeArea(
            child: Stack(children: [
              Column(
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
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios)),
                      Text('Video Editor'.tr,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: _exportVideo,
                          child: Column(
                            children: [
                             Image.asset('assets/export.png',height: 28,width: 28,),
                             Text('Export'.tr)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                    child: DefaultTabController(
                        length: 2,
                        child: Column(children: [
                          Expanded(
                              child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  Stack(alignment: Alignment.center, children: [

                                    CropGridViewer(
                                      controller: _controller,
                                      showGrid: false,
                                    ),
                                    AnimatedBuilder(
                                      animation: _controller.video,
                                      builder: (_, __) => OpacityTransition(
                                        visible: !_controller.isPlaying,
                                        child: GestureDetector(
                                          onTap: _controller.video.play,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.play_arrow,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: x,
                                      top: y,
                                      child: Draggable(feedback:Text('${text.text}',style: TextStyle(fontSize: textSize.value,color: shadedColor)),

                                          childWhenDragging: Container(),
                                          onDragEnd: (dragDetails) {
                                            setState(() {
                                              x = dragDetails.offset.dx-10;
                                              // if applicable, don't forget offsets like app/status bar
                                              y = dragDetails.offset.dy-100;
                                            });
                                          },
                                          child: Text('${text.text}',style: TextStyle(fontSize: textSize.value,color: shadedColor),)),
                                    ),
                                  ]),
                                  CoverViewer(controller: _controller),

                                ],
                              )),
                          Container(
                              height: 30.h,
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(children: [
                                // TabBar(
                                //   indicatorColor: Colors.white,
                                //   tabs: [
                                //     Row(
                                //         mainAxisAlignment:
                                //         MainAxisAlignment.center,
                                //         children: const [
                                //           Padding(
                                //               padding: EdgeInsets.all(5),
                                //               child: Icon(Icons.content_cut)),
                                //           Text('Trim')
                                //         ]),
                                //     // Row(
                                //     //     mainAxisAlignment:
                                //     //     MainAxisAlignment.center,
                                //     //     children: const [
                                //     //       Padding(
                                //     //           padding: EdgeInsets.all(5),
                                //     //           child: Icon(Icons.video_label)),
                                //     //       Text('Cover')
                                //     //     ]),
                                //   ],
                                // ),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children:textoptions==false? _trimSlider():[
                                        Visibility(
                                          visible: textoptions,
                                          child: Container(
                                            height: 200,

                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                TextFormField(
                                                  style: TextStyle(color: Colors.white),
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Icon(Icons.text_fields,color: Colors.white,),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    filled: true,
                                                    labelStyle: TextStyle(color: Colors.white),
                                                    labelText: 'Doc Name',

                                                  ),
                                                  //onTap: () => name.selection = TextSelection(baseOffset: 0, extentOffset: name.value.text.length),
                                                  keyboardType: TextInputType.emailAddress,
                                                  controller: text,
                                                  onChanged: (value){
                                                    setState((){});
                                                  },
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Slider(
                                                      activeColor: Color(0xff97482A),
                                                      thumbColor: Color(0xff97482A),
                                                      inactiveColor:
                                                      Colors.white,
                                                      min: 12.0,
                                                      max: 80.0,
                                                      value: textSize.value,
                                                      onChanged:
                                                          (value){
                                                        setState((){
                                                          textSize.value=value;
                                                        });
                                                      }),
                                                ),
                                                GestureDetector(
                                                  behavior: HitTestBehavior.opaque,
                                                  onHorizontalDragStart: (DragStartDetails details) {
                                                    print("_-------------------------STARTED DRAG");
                                                    _colorChangeHandler(details.localPosition.dx);
                                                  },
                                                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                                                    _colorChangeHandler(details.localPosition.dx);
                                                  },
                                                  onTapDown: (TapDownDetails details) {
                                                    _colorChangeHandler(details.localPosition.dx);
                                                  },
                                                  //This outside padding makes it much easier to grab the   slider because the gesture detector has
                                                  // the extra padding to recognize gestures inside of
                                                  child: Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Container(
                                                      width: widget.width,
                                                      height: 15,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 2, color: Colors.grey),
                                                        borderRadius: BorderRadius.circular(15),
                                                        gradient: LinearGradient(colors: _colors),
                                                      ),
                                                      // child: CustomPaint(
                                                      //   painter: _SliderIndicatorPainter(_colorSliderPosition),
                                                      // ),
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),

                                      ]
                                  ),
                                ),
                                editBar(),
                                SizedBox(height: 3.h,)
                              ]
                              )),
                          _customSnackBar(),
                          ValueListenableBuilder(
                            valueListenable: _isExporting,
                            builder: (_, bool export, __) => OpacityTransition(
                              visible: export,
                              child: AlertDialog(
                                backgroundColor: Colors.white,
                                title: ValueListenableBuilder(
                                  valueListenable: _exportingProgress,
                                  builder: (_, double value, __) => Text(
                                    "Exporting video ${(value * 100).ceil()}%",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]))),

              ])
            ])),
          )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget editBar() {
    return Container(
      height: 8.h,
      width: 95.w,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(40)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:  EdgeInsets.only(left: 5.0.w,right: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () =>
                    _controller.rotate90Degrees(RotateDirection.left),
                  child: Column(
                    children: [
                      Icon(Icons.rotate_left),
                      Text('Rotate left'.tr)

                    ],
                  ),
                ),

                InkWell(
                  onTap:_openCropScreen,
                  child: Column(
                    children: [
                      Icon(Icons.crop),
                      Text('Crop'.tr)

                    ],
                  ),
                ),
                InkWell(
                  onTap: () =>_controller.rotate90Degrees(RotateDirection.right),
                  child: Column(
                    children: [
                      Icon(Icons.rotate_right),
                      Text('Rotate Right'.tr)

                    ],
                  ),
                ),
                // InkWell(
                //   onTap: () async{
                //     final ImagePicker _picker = ImagePicker();
                //     final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
                //     print('nsdngfmksxngjxdbngdjngdjbng:${file?.path}');
                //     EasyLoading.show();
                //
                //     if (mounted && file != null) {
                //       var newFile=File(file.path);
                //       // var filee= await compressVideo(newFile.path);
                //       final appDir = await getApplicationDocumentsDirectory();
                //       String rawDocumentPath = appDir.path;
                //       File outputFile=File('$rawDocumentPath/output1234.mp4');
                //       if(!outputFile.existsSync()){
                //         await outputFile.create();
                //       }
                //       final outputPath = '$rawDocumentPath/output1234.mp4';
                //       String videos = widget.file.path;
                //       videos = videos + ' -i ${newFile.path}';
                //       print(videos);
                //
                //       String commandToExecute = '-y -i ${widget.file.path} -i ${newFile.path} -filter_complex \'[0:0][1:0]concat=n=2:v=1:a=0[out]\' -map \'[out]\' $outputPath';
                //
                //       final ffmpegSession = await FFmpegKit.execute(commandToExecute);
                //       final returnCode = await ffmpegSession.getReturnCode();
                //       if (ReturnCode.isSuccess(returnCode)) {
                //         _controller.dispose();
                //         setState(() {
                //           _controller = VideoEditorController.file(File(outputPath),
                //               maxDuration: const Duration(seconds: 30))
                //             ..initialize().then((_) => setState(() {}));
                //         });
                //
                //         print('success');
                //       } else if (ReturnCode.isCancel(returnCode)) {
                //         // CANCEL
                //         print('cancel');
                //       } else {
                //         // ERROR
                //         print('error');
                //       }
                //       print(File(outputPath).lengthSync());
                //       EasyLoading.dismiss();
                //     }
                //   },
                //   child: Column(
                //     children: [
                //       Icon(Icons.merge),
                //       Text('Merge Videos')
                //
                //     ],
                //   ),
                // ),
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
    );
  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: _controller.video,
        builder: (_, __) {
          final duration = _controller.video.value.duration.inSeconds;
          final pos = _controller.trimPosition * duration;
          final start = _controller.minTrim * duration;
          final end = _controller.maxTrim * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(formatter(Duration(seconds: pos.toInt()))),
              const Expanded(child: SizedBox()),
              OpacityTransition(
                visible: _controller.isTrimming,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(formatter(Duration(seconds: start.toInt()))),
                  const SizedBox(width: 10),
                  Text(formatter(Duration(seconds: end.toInt()))),
                ]),
              )
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
            controller: _controller,
            height: height,
            horizontalMargin: height / 4,
            child: TrimTimeline(
                controller: _controller,
                margin: const EdgeInsets.only(top: 10))),
      )
    ];
  }

  Widget _coverSelection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: height / 4),
        child: CoverSelection(
          controller: _controller,
          height: height,
          quantity: 8,
        ));
  }

  Widget _customSnackBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SwipeTransition(
        visible: _exported,
        axisAlignment: 1.0,
        child: Container(
          height: height,
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: Text(_exportText,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}