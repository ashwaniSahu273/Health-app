import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
// import 'package:harees_new_project/View/8.%20Chats/Models/lab_service_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/vitamin_service_model.dart';
// import 'package:harees_new_project/View/8.%20Chats/Models/vitamin_service_model.dart';
// import 'package:harees_new_project/View/Admin%20Screen/CRUD%20Operations/create_service.dart';
import 'package:harees_new_project/View/Admin%20Screen/CRUD%20Operations/vitamin_create_service.dart';

class VitaminServicesList extends StatefulWidget {
  @override
  _VitaminServicesListState createState() => _VitaminServicesListState();
}

class _VitaminServicesListState extends State<VitaminServicesList> {
  late Future<List<Service>> _serviceListFuture;
  var isloading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _serviceListFuture = _fetchServices();
    });
  }

  Future<List<Service>> _fetchServices() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('VitaminServices').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Service.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }

  void _deleteService(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this Service?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseFirestore.instance
                    .collection('VitaminServices')
                    .doc(docId)
                    .delete();

                setState(() {
                  _serviceListFuture = _fetchServices();
                });
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _editService(BuildContext context, service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Edition"),
          content: const Text("Are you sure you want to edit this Service?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VitaminCreateService(
                      isEditing: true,
                      service: service,
                    ),
                  ),
                ).then((_) {
                  // Refresh the list after editing
                  setState(() {
                    _serviceListFuture = _fetchServices();
                  });
                  Navigator.pop(context);
                });
              },
              child: const Text("Edit", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // void _editService(service) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => VitaminCreateService(
  //         isEditing: true,
  //         service: service,
  //       ),
  //     ),
  //   ).then((_) {
  //     // Refresh the list after editing
  //     setState(() {
  //       _serviceListFuture = _fetchServices();
  //     });
  //   });
  // }

  void _addService() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VitaminCreateService(
          isEditing: false,
          service: null,
        ),
      ),
    ).then((_) {
      // Refresh the list after adding
      setState(() {
        _serviceListFuture = _fetchServices();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addService,
          ),
        ],
      ),
      body: FutureBuilder<List<Service>>(
        future: _serviceListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching services.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No services available.'));
          }

          final services = snapshot.data!;

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              String languageCode = Get.locale?.languageCode ?? 'en';

              // Fetch localized data dynamically
              final localizedData = languageCode == 'ar'
                  ? service.localized.ar
                  : service.localized.en;

              // Extract fields from localized data
              final serviceName = localizedData.serviceName;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.image),
                    title: Text(serviceName),
                    subtitle: Text(localizedData.price),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editService(context, service),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteService(context, service.id),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
