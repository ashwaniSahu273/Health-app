import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddOrEditServiceForm extends StatefulWidget {
  final bool isEditing;
  final dynamic service;

  AddOrEditServiceForm({required this.isEditing, this.service});

  @override
  _AddOrEditServiceFormState createState() => _AddOrEditServiceFormState();
}

class _AddOrEditServiceFormState extends State<AddOrEditServiceForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _arServiceNameController =
      TextEditingController();
  final TextEditingController _enServiceNameController =
      TextEditingController();
  final TextEditingController _arDescriptionController =
      TextEditingController();
  final TextEditingController _enDescriptionController =
      TextEditingController();
  final TextEditingController _arInstructionsController =
      TextEditingController();
  final TextEditingController _enInstructionsController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _imageFile;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.service != null) {
      _arServiceNameController.text =
          widget.service!.localized.ar.serviceName ?? '';
      _enServiceNameController.text =
          widget.service!.localized.en.serviceName ?? '';
      _arDescriptionController.text =
          widget.service!.localized.ar.description ?? '';
      _enDescriptionController.text =
          widget.service!.localized.en.description ?? '';
      _arInstructionsController.text =
          widget.service!.localized.ar.instructions ?? '';
      _enInstructionsController.text =
          widget.service!.localized.en.instructions ?? '';
      _priceController.text = widget.service!.localized.en.price ?? '';
      _uploadedImageUrl = widget.service!.imagePath ?? "";
    }
  }

  Future<void> selectImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(File(pickedFile.path));
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
        _imageFile = File(croppedFile.path);
      });
      await uploadImage();
    }
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('service_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_imageFile!);

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageUrl = downloadUrl;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Service' : 'Add Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Section
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     _imageFile != null
              //         ? Image.file(
              //             _imageFile!,
              //             height: 200,
              //             width: double.infinity,
              //             fit: BoxFit.cover,
              //           )
              //         : _uploadedImageUrl != null
              //             ? Image.network(
              //                 _uploadedImageUrl!,
              //                 height: 200,
              //                 width: double.infinity,
              //                 fit: BoxFit.cover,
              //               )
              //             : Text("There is no image"),
              //     SizedBox(height: 10),
              //     ElevatedButton.icon(
              //       onPressed: () => selectImage(ImageSource.gallery),
              //       icon: Icon(Icons.image),
              //       label: Text('Select Image'),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20),

              // Arabic Service Name
              TextFormField(
                controller: _arServiceNameController,
                decoration: InputDecoration(
                  labelText: 'Service Name (Arabic)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Please enter a service name in Arabic'
                    : null,
              ),
              SizedBox(height: 10),
              // English Service Name
              TextFormField(
                controller: _enServiceNameController,
                decoration: InputDecoration(
                  labelText: 'Service Name (English)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Please enter a service name in English'
                    : null,
              ),
              SizedBox(height: 10),
              // Arabic Description
              TextFormField(
                controller: _arDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (Arabic)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Please enter a description in Arabic'
                    : null,
              ),
              SizedBox(height: 10),
              // English Description
              TextFormField(
                controller: _enDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (English)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Please enter a description in English'
                    : null,
              ),
              SizedBox(height: 10),
              // Arabic Instructions
              TextFormField(
                controller: _arInstructionsController,
                decoration: InputDecoration(
                  labelText: 'Instructions (Arabic)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Please enter instructions in Arabic'
                    : null,
              ),
              SizedBox(height: 10),
              // English Instructions
              TextFormField(
                controller: _enInstructionsController,
                decoration: InputDecoration(
                  labelText: 'Instructions (English)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Please enter instructions in English'
                    : null,
              ),
              SizedBox(height: 10),
              // Price
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the price' : null,
              ),
              SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _uploadedImageUrl != null) {
                    var newService = {
                      'localized': {
                        'ar': {
                          'serviceName': _arServiceNameController.text,
                          'description': _arDescriptionController.text,
                          'Instructions': _arInstructionsController.text,
                          'price': _priceController.text,
                        },
                        'en': {
                          'serviceName': _enServiceNameController.text,
                          'description': _enDescriptionController.text,
                          'Instructions': _enInstructionsController.text,
                          'price': _priceController.text,
                        },
                      },
                      'imagePath': _uploadedImageUrl,
                    };

                    if (widget.isEditing) {
                      FirebaseFirestore.instance
                          .collection('LaboratoryServices')
                          .doc(widget.service.id.toString())
                          .update(newService);
                    } else {
                      final docRef = FirebaseFirestore.instance
                          .collection('LaboratoryServices')
                          .doc();
                      final id = docRef.id;

                      newService = {...newService, 'id': id};
                      docRef.set(newService);
                    }

                    Navigator.pop(context, newService);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please upload an image!')),
                    );
                  }
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
}
