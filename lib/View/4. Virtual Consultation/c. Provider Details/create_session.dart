import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateSessionButton extends StatelessWidget {
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;

  const CreateSessionButton({
    Key? key,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
  }) : super(key: key);

  Future<String> createTelemedicineSession({
    required String description,
    required DateTime startDateTime,
    required DateTime endDateTime,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('You must be signed in to create a session.');
      }

      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'createTelemedicineSession',
      );
      print("==============================> Callable Function Initialized");

      // Test data
      final data = {
        'description': 'Consultation for general health',
        'startDateTime': DateTime(2025, 1, 25, 14, 0, 0).toIso8601String(),
        'endDateTime': DateTime(2025, 1, 25, 14, 30, 0).toIso8601String(),
      };

      final response = await callable.call(data);

      print("==============================> Response: ${response.data}");

//    final data = {
//   'description': 'Consultation for general health',
//   'startDateTime': DateTime(2025, 1, 20, 14, 0, 0).toIso8601String(), // 20th Jan 2025, 2:00 PM
//   'endDateTime': DateTime(2025, 1, 20, 14, 30, 0).toIso8601String(),  // 20th Jan 2025, 2:30 PM
// };

      final HttpsCallableResult result = await callable.call(data);

      print("==============================>result call link $result");

      final responseData = result.data as Map<String, dynamic>? ?? {};
      if (responseData['success'] == true && responseData['meetLink'] != null) {
        return responseData['meetLink'] as String;
      } else {
        throw Exception('Failed to create telemedicine session.');
      }
    } on FirebaseFunctionsException catch (e) {
      print('Firebase Functions Exception: ${e.code} - ${e.message}');
      throw Exception('Firebase Functions Error: ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
      throw Exception('Unknown Error: $e');
    }
  }

  Future<void> _handleCreateSession(BuildContext context) async {
    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()),
      );
      String meetLink = await createTelemedicineSession(
        description: description,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
      );
      print("==============================>after meeet link $meetLink");

      // Dismiss the loading indicator
      Navigator.of(context).pop();

      // Show the Meet link to the user
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Session Created'),
            ],
          ),
          content: SelectableText(
            'Google Meet Link:\n$meetLink',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();

      // Show an error message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Text(
            'Failed to create session: ${e.toString()}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Retry',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Telemedicine Session'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 20),
            Text(
              'Create a Telemedicine Session',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Click the button below to create a Google Meet session for your telemedicine consultation.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _handleCreateSession(context),
              style: ElevatedButton.styleFrom(
                padding:
                    EdgeInsets.symmetric(horizontal: 32, vertical: 12), // Size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Create Session',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
