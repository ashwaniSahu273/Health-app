import 'dart:io';
import 'package:get/get.dart';

class ServiceCreateController extends GetxController {
  var nurseImageFile = Rx<File?>(null);
  var nurseUploadedImageUrl = Rx<String?>(null);
  var vitaminUploadedImageUrl = Rx<String?>(null);
  var labUploadedImageUrl = Rx<String?>(null);
  var isLoadingNurseService = false.obs;
  var selectedServiceNurseType = "package".obs;
  var selectedServiceVitaminType = "package".obs;
  var selectedServiceLabType = "package".obs;

  void setSelectedService(String serviceType) {
    selectedServiceNurseType.value = serviceType;
  }

  @override
  void onClose() {
    labUploadedImageUrl.value = ''; // Reset the variable
    super.onClose();
  }

  void setImageFile(File file) {
    nurseImageFile.value = file;
  }

  void setUploadedImageUrl(String url) {
    nurseUploadedImageUrl.value = url;
  }
}
