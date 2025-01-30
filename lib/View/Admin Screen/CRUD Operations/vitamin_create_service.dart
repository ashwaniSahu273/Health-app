import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VitaminCreateService extends StatelessWidget {
  final bool isEditing;
  final service;

  VitaminCreateService({required this.isEditing, this.service});

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
  final TextEditingController _imagePathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (isEditing && service != null) {
      _arServiceNameController.text = service!.localized.ar.serviceName ?? '';
      _enServiceNameController.text = service!.localized.en.serviceName ?? '';
      _arDescriptionController.text = service!.localized.ar.description ?? '';
      _enDescriptionController.text = service!.localized.en.description ?? '';
      _arInstructionsController.text = service!.localized.ar.components ?? '';
      _enInstructionsController.text = service!.localized.en.components ?? '';
      _priceController.text = service!.localized.en.price ?? '';
      _imagePathController.text = service!.imagePath ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Service' : 'Add Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              SizedBox(height: 10),
              // Image Path
              TextFormField(
                controller: _imagePathController,
                decoration: InputDecoration(
                  labelText: 'Image Path',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the image path' : null,
              ),
              SizedBox(height: 20),
              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var newService = {
                      'localized': {
                        'ar': {
                          'serviceName': _arServiceNameController.text ?? "No service name",
                          'description': _arDescriptionController.text ?? "No description",
                          'instructions': _arInstructionsController.text ?? "No instructions",
                          'components': _arInstructionsController.text ?? "No components",
                          'price': _priceController.text ?? "No price",
                        },
                        'en': {
                          'serviceName': _enServiceNameController.text ?? "No service name",
                          'description': _enDescriptionController.text  ?? "No description",
                          'components': _enInstructionsController.text  ?? "No components",
                          'instructions': _enInstructionsController.text  ?? "No instructions",
                          'price': _priceController.text ?? "No price",
                        },
                      },
                      'imagePath': _imagePathController.text,
                    };

                    if (isEditing) {
                      FirebaseFirestore.instance
                          .collection('VitaminServices')
                          .doc(service.id
                              .toString()) // Replace with the actual serviceId you want to update
                          .update(newService);
                    } else {
                      final docRef = FirebaseFirestore.instance
                          .collection('VitaminServices')
                          .doc();
                      final id = docRef.id; // Get the generated document ID

                      newService = {...newService, id: id};

                      docRef.set(newService);
                    }

                    Navigator.pop(context, newService);
                  }
                },
                child: Text(isEditing ? 'Update Service' : 'Add Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
