import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:events_demo/models/event_info.dart';
import 'package:flutter/material.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/f.%20Google%20Meet/event_info_model.dart';

final CollectionReference mainCollection = FirebaseFirestore.instance.collection('event');
final DocumentReference documentReference = mainCollection.doc('test');

class Storage {
  Future<void> storeEventData(EventInfo eventInfo) async {
    DocumentReference documentReferencer = documentReference.collection('events').doc(eventInfo.id);

    Map<String, dynamic> data = eventInfo.toJson();

    print('DATA:\n$data');

    await documentReferencer.set(data).whenComplete(() {
      print("Event added to the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }

  Future<void> updateEventData(EventInfo eventInfo) async {
    DocumentReference documentReferencer = documentReference.collection('events').doc(eventInfo.id);

    Map<String, dynamic> data = eventInfo.toJson();

    print('DATA:\n$data');

    await documentReferencer.update(data).whenComplete(() {
      print("Event updated in the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }

  Future<void> deleteEvent({required String id}) async {
    DocumentReference documentReferencer = documentReference.collection('events').doc(id);

    await documentReferencer.delete().catchError((e) => print(e));

    print('Event deleted, id: $id');
  }

  Stream<QuerySnapshot> retrieveEvents() {
    Stream<QuerySnapshot> myClasses = documentReference.collection('events').orderBy('start').snapshots();

    return myClasses;
  }
}