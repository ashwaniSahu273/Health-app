import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/Admin%20Screen/CRUD%20Operations/service_create_controller.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';

class NurseCreateService extends StatefulWidget {
  final bool isEditing;
  final service;

  NurseCreateService({required this.isEditing, this.service});

  @override
  State<NurseCreateService> createState() => _NurseCreateServiceState();
}

class _NurseCreateServiceState extends State<NurseCreateService> {
  final _formKey = GlobalKey<FormState>();

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

  final TextEditingController _arTermsOfServiceController =
      TextEditingController();

  final TextEditingController _enTermsOfServiceController =
      TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _imagePathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ServiceCreateController controller = Get.put(ServiceCreateController());
    controller.selectedServiceNurseType.value = "group";
    File? imageFile;
    String? uploadedImageUrl;

    if (widget.isEditing && widget.service != null) {
      _arServiceNameController.text =
          widget.service!.localized.ar.serviceName ?? '';
      _enServiceNameController.text =
          widget.service!.localized.en.serviceName ?? '';
      _arDescriptionController.text =
          widget.service!.localized.ar.description ?? '';
      _enDescriptionController.text =
          widget.service!.localized.en.description ?? '';
      _arAboutController.text = widget.service!.localized.ar.about ?? '';
      _enAboutController.text = widget.service!.localized.en.about ?? '';
      _arServiceIncludesController.text =
          widget.service!.localized.ar.serviceIncludes ?? '';
      _enServiceIncludesController.text =
          widget.service!.localized.en.serviceIncludes ?? '';
      _arTermsOfServiceController.text =
          widget.service!.localized.ar.termsOfService ?? '';
      _enTermsOfServiceController.text =
          widget.service!.localized.en.termsOfService ?? '';
      _priceController.text = widget.service!.localized.en.price ?? '';
      uploadedImageUrl = widget.service!.imagePath ?? '';
      controller.selectedServiceNurseType.value = widget.service!.type;
    }

    Future<void> uploadImage() async {
      if (imageFile == null) return;

      try {
        final storageRef = FirebaseStorage.instance.ref().child(
            'service_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(imageFile!);

        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          uploadedImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully!')),
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

    return Scaffold(
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
                  imageFile != null
                      ? Image.file(
                          imageFile!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : uploadedImageUrl != null
                          ? Image.network(
                              uploadedImageUrl!,
                              height: 100,
                              width: 100,
                              // fit: BoxFit.cover,
                            )
                          : Text("There is no image"),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => selectImage(ImageSource.gallery),
                    icon: Icon(Icons.image),
                    label: Text('Select Image'),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedServiceNurseType.value,
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
                  items: ['group', 'individual'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    controller.selectedServiceNurseType.value = newValue!;
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
                () => controller.selectedServiceNurseType.value != "individual"
                    ? Column(
                        children: [
                          _buildTextField(
                              _arDescriptionController, 'Description (Arabic)',
                              maxLines: 4),
                          _buildTextField(
                              _enDescriptionController, 'Description (English)',
                              maxLines: 4),
                          _buildTextField(_arAboutController, 'About (Arabic)',
                              maxLines: 5),
                          _buildTextField(_enAboutController, 'About (English)',
                              maxLines: 5),
                          _buildTextField(_arServiceIncludesController,
                              'Service Includes (Arabic)',
                              maxLines: 6),
                          _buildTextField(_enServiceIncludesController,
                              'Service Includes (English)',
                              maxLines: 6),
                          _buildTextField(_arTermsOfServiceController,
                              'Terms of Service (Arabic)',
                              maxLines: 6),
                          _buildTextField(_enTermsOfServiceController,
                              'Terms of Service (English)',
                              maxLines: 6),
                        ],
                      )
                    : SizedBox.shrink(),
              ),

              _buildTextField(_priceController, 'Price'),
              // _buildTextField(_imagePathController, 'Image Path'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  var newService = {
                    'id': widget.isEditing ? widget.service.id : '',
                    'imagePath': _imagePathController.text,
                    "type": "individual",
                    'localized': {
                      'ar': {
                        'serviceName':
                            _arServiceNameController.text ?? "No service name",
                        'description':
                            _arDescriptionController.text ?? "No description",
                        'about': _arAboutController.text ?? "No about",
                        'serviceIncludes': _arServiceIncludesController.text ??
                            "No service includes",
                        'TermsOfService': _arTermsOfServiceController.text ??
                            "No service terms of service",
                        'price': _priceController.text ?? "No price",
                      },
                      'en': {
                        'serviceName':
                            _enServiceNameController.text ?? "No service name",
                        'description':
                            _enDescriptionController.text ?? "No description",
                        'about': _enAboutController.text ?? "No about",
                        'serviceIncludes': _enServiceIncludesController.text ??
                            "No service includes",
                        'TermsOfService': _enTermsOfServiceController.text ??
                            "No terms of service",
                        'price': _priceController.text ?? "No price",
                      },
                    },
                  };

                  if (widget.isEditing) {
                    FirebaseFirestore.instance
                        .collection('NurseServices')
                        .doc(widget.service.id.toString())
                        .update(newService);
                  } else {
                    final docRef = FirebaseFirestore.instance
                        .collection('NurseServices')
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            // validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
          ),
        ],
      ),
    );
  }
}
