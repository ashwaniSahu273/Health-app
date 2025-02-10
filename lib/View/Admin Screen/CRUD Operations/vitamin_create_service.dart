import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/Admin%20Screen/CRUD%20Operations/service_create_controller.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';

class VitaminCreateService extends StatefulWidget {
  final bool isEditing;
  final service;

  VitaminCreateService({required this.isEditing, this.service});

  @override
  State<VitaminCreateService> createState() => _VitaminCreateServiceState();
}

class _VitaminCreateServiceState extends State<VitaminCreateService> {
  final _formKey = GlobalKey<FormState>();
  File? imageFile;
  // String? controller.vitaminUploadedImageUrl.value;

  final TextEditingController _arServiceNameController =
      TextEditingController();

  final TextEditingController _enServiceNameController =
      TextEditingController();

  final TextEditingController _arDescriptionController =
      TextEditingController();

  final TextEditingController _enDescriptionController =
      TextEditingController();

  final TextEditingController _arAboutController = TextEditingController();

  final TextEditingController _enAboutController = TextEditingController();

  final TextEditingController _arServiceIncludesController =
      TextEditingController();

  final TextEditingController _enServiceIncludesController =
      TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ServiceCreateController controller = Get.put(ServiceCreateController());
    // controller.selectedServiceVitaminType.value = "package";

    if (widget.isEditing && widget.service != null) {
      _arServiceNameController.text =
          widget.service!.localized.ar.serviceName ?? '';
      _enServiceNameController.text =
          widget.service!.localized.en.serviceName ?? '';
      _arDescriptionController.text =
          widget.service!.localized.ar.instructions ?? '';
      _enDescriptionController.text =
          widget.service!.localized.en.instructions ?? '';
      _arAboutController.text = widget.service!.localized.ar.description ?? '';
      _enAboutController.text = widget.service!.localized.en.description ?? '';
      _arServiceIncludesController.text =
          widget.service!.localized.ar.components ?? '';
      _enServiceIncludesController.text =
          widget.service!.localized.en.components ?? '';

      _priceController.text = widget.service!.localized.en.price
              ?.replaceAll(RegExp(r'[^0-9]'), '') ??
          '';
      controller.vitaminUploadedImageUrl.value =
          widget.service!.imagePath ?? '';
      controller.selectedServiceVitaminType.value = widget.service!.type;
    }

    Future<void> uploadImage() async {
      controller.isLoadingNurseService.value = true;

      if (imageFile == null) return;

      try {
        final storageRef = FirebaseStorage.instance.ref().child(
            'service_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(imageFile!);

        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        controller.vitaminUploadedImageUrl.value = downloadUrl;

        controller.isLoadingNurseService.value = false;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed: $e')),
        );
      }
    }

    Future<void> cropImage(File file) async {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 50,
      );

      if (croppedFile != null) {
        setState(() {
          imageFile = File(croppedFile.path);
        });
        await uploadImage();
      }
    }

    Future<void> selectImage(ImageSource source) async {
      final XFile? pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        cropImage(File(pickedFile.path));
      }
    }

    return WillPopScope(
      onWillPop: () async {
        controller.vitaminUploadedImageUrl.value = ''; // Reset the variable
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing ? 'Edit Service' : 'Add Service'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => controller.isLoadingNurseService.value
                          ? const CircularProgressIndicator()
                          : controller.vitaminUploadedImageUrl.value != null &&
                                  controller
                                      .vitaminUploadedImageUrl.value!.isNotEmpty
                              ? Container(
                                  height: 120,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(
                                        0xFFE6F5FF), // Circle background color
                                  ),
                                  child: Image.network(
                                    controller.vitaminUploadedImageUrl.value!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text(
                                        "No Image",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      );
                                    },
                                  ),
                                )
                              : const Text(
                                  "There Is No Image",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => selectImage(ImageSource.gallery),
                      icon: const Icon(Icons.image),
                      label: const Text('Select Image'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedServiceVitaminType.value,
                    decoration: InputDecoration(
                        labelText: "Package Type",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        // filled: true,
                        // fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        )),
                    items: ['package', 'individual'].map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      controller.selectedServiceVitaminType.value = newValue!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildTextField(
                    _arServiceNameController, 'Service Name (Arabic)'),
                _buildTextField(
                    _enServiceNameController, 'Service Name (English)'),
                Obx(
                  () => controller.selectedServiceVitaminType.value !=
                          "individual"
                      ? Column(
                          children: [
                            _buildTextField(_arDescriptionController,
                                'Instructions (Arabic)',
                                maxLines: 4),
                            _buildTextField(_enDescriptionController,
                                'Instructions (English)',
                                maxLines: 4),
                            _buildTextField(
                                _arAboutController, 'About (Arabic)',
                                maxLines: 5),
                            _buildTextField(
                                _enAboutController, 'About (English)',
                                maxLines: 5),
                            _buildTextField(_arServiceIncludesController,
                                'Components (Arabic)',
                                maxLines: 6),
                            _buildTextField(_enServiceIncludesController,
                                'Components (English)',
                                maxLines: 6),
                            // _buildTextField(_arTermsOfServiceController,
                            //     'Terms of Service (Arabic)',
                            //     maxLines: 6),
                            // _buildTextField(_enTermsOfServiceController,
                            //     'Terms of Service (English)',
                            //     maxLines: 6),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                _buildTextField(_priceController, 'Price',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print(
                        "uploading==========>${controller.vitaminUploadedImageUrl.value}");
                    var newService = {
                      'id': widget.isEditing ? widget.service.id : '',
                      'imagePath':
                          controller.vitaminUploadedImageUrl.value ?? " ",
                      "type": controller.selectedServiceVitaminType.value,
                      'localized': {
                        'ar': {
                          'serviceName': _arServiceNameController.text,
                          'description': _arAboutController.text,
                          'components': _arServiceIncludesController.text,
                          'instructions': _arDescriptionController.text,
                          'price': "${_priceController.text} ريال",
                        },
                        'en': {
                          'serviceName': _enServiceNameController.text,
                          'description': _enAboutController.text,
                          'components': _enServiceIncludesController.text,
                          'instructions': _enDescriptionController.text,
                          'price': "${_priceController.text} SAR",
                        },
                      },
                    };

                    if (widget.isEditing) {
                      FirebaseFirestore.instance
                          .collection('VitaminServices')
                          .doc(widget.service.id.toString())
                          .update(newService);
                    } else {
                      final docRef = FirebaseFirestore.instance
                          .collection('VitaminServices')
                          .doc();
                      final id = docRef.id;
                      newService['id'] = id;
                      docRef.set(newService);
                    }

                    Navigator.pop(context, newService);
                  },
                  child:
                      Text(widget.isEditing ? 'Update Service' : 'Add Service'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text, // Default to text input
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
