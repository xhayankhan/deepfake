
import 'package:deepfake/Controllers/EditingController.dart';
import 'package:deepfake/Controllers/ImageController.dart';
import 'package:deepfake/Controllers/ServerController.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class defaultBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<EditingController>(EditingController());
    Get.put<ServerController>(ServerController());
    Get.put<ImageController>(ImageController());
    // Get.lazyPut(()=>ItemController(),fenix: true);
    // Get.put(customerController());
    // Get.lazyPut(()=>LoginController());
  }

}