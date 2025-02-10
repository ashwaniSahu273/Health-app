import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/nurse_service_model.dart';
import 'package:harees_new_project/View/Admin%20Screen/CRUD%20Operations/nurse_create_service.dart';

class NurseServicesList extends StatefulWidget {
  @override
  _NurseServicesListState createState() => _NurseServicesListState();
}

class _NurseServicesListState extends State<NurseServicesList> {
  late Future<List<NurseServiceModel>> _serviceListFuture;
  var isloading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _serviceListFuture = _fetchServices();
    });
    print(_serviceListFuture);
  }

  Future<List<NurseServiceModel>> _fetchServices() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('NurseServices').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('Document ID: ${doc.id}');
        print('Document Data: $data');
        return NurseServiceModel.fromJson(data);
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
                    .collection('NurseServices')
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

  // void _deleteService(String serviceId) async {
  //   await FirebaseFirestore.instance
  //       .collection('NurseServices')
  //       .doc(serviceId)
  //       .delete();

  //   // Refresh the list
  //   setState(() {
  //     _serviceListFuture = _fetchServices();
  //   });
  // }

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
                    builder: (context) => NurseCreateService(
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
  //       builder: (context) => NurseCreateService(
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
        builder: (context) => NurseCreateService(
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
        title: Text('Service List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addService,
          ),
        ],
      ),
      body: FutureBuilder<List<NurseServiceModel>>(
        future: _serviceListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
                child: Text('Error fetching services.${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No services available.'));
          }

          final services = snapshot.data!;

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              String languageCode = Get.locale?.languageCode ?? 'en';
              print("This is list:$service");

              final localizedData = languageCode == 'ar'
                  ? service.localized.ar
                  : service.localized.en;

              final serviceName = localizedData.serviceName;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.image),
                    title: Text(serviceName),
                    subtitle: Text(localizedData.price),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editService(context, service),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteService(context, service.id.toString()),
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
