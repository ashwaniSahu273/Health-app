import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/lab_service_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/vitamin_service_model.dart';
// import 'package:harees_new_project/View/8.%20Chats/Models/vitamin_service_model.dart';
import 'package:harees_new_project/View/Admin%20Screen/CRUD%20Operations/create_service.dart';

class ServiceListScreen extends StatefulWidget {
  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  late Future<List<LabService>> _serviceListFuture;
  var isloading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      
    _serviceListFuture = _fetchServices();
    });
    print(_serviceListFuture);
  }

Future<List<LabService>> _fetchServices() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('LaboratoryServices').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
          print('Document ID: ${doc.id}');
      print('Document Data: $data');
      return LabService.fromJson(data);
    }).toList();


  } catch (e) {
    print('Error fetching services: $e');
    return [];
  }
}

  void _deleteService(int serviceId) async {
    await FirebaseFirestore.instance
        .collection('LaboratoryServices')
        .doc(serviceId.toString())
        .delete();

    // Refresh the list
    setState(() {
      _serviceListFuture = _fetchServices();
    });
  }

  void _editService( service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOrEditServiceForm(
          isEditing: true,
          service: service,
        ),
      ),
    ).then((_) {
      // Refresh the list after editing
      setState(() {
        _serviceListFuture = _fetchServices();
      });
    });
  }

  void _addService() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOrEditServiceForm(
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
      body: FutureBuilder<List<LabService>>(
        future: _serviceListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             print('Error: ${snapshot.error}');
            return Center(child: Text('Error fetching services.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No services available.'));
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
              final serviceName =
                  localizedData.serviceName ?? 'Unknown Service';
              final description =
                  localizedData.description ?? 'No description available';
              final instructions =
                  localizedData.instructions ?? 'No instructions provided';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 6),
                child: Card(
                  child: ListTile(
                    leading:  Icon(Icons.image),
                    title: Text(serviceName),
                    subtitle: Text(localizedData.price),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editService(service),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteService(service.id),
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
