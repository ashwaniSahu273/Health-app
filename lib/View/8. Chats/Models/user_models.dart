import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? fullname;
  String? idNumber;
  String? email;
  String? uid;
  String? profilePic;
  String? experience;
  String? designation;
  String? mobileNumber;
  String? gender;
  String? dob;
  String? role;
  Timestamp? timeStamp;
  bool? isDeleted;

  UserModel({
    this.isDeleted,
    this.fullname,
    this.idNumber,
    this.email,
    this.uid,
    this.profilePic,
    this.experience,
    this.designation,
    this.mobileNumber,
    this.gender,
    this.dob,
    this.role,
    this.timeStamp,
  });

  UserModel.frommap(Map<String, dynamic> map) {
    uid = map['uid'];
    email = map['email'];
    fullname = map['fullname'];
    idNumber = map['idNumber'];
    profilePic = map['profilePic'];
    experience = map['experience'];
    designation = map['designation'];
    mobileNumber = map['mobileNumber'];
    gender = map['gender'];
    dob = map['dob'];
    role = map['role'];
    timeStamp = map['timeStamp'];
    isDeleted = map['isDeleted'];
  }

  Map<String, dynamic> tomap() {
    return {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'idNumber': idNumber,
      'profilePic': profilePic,
      'experience': experience,
      'designation': designation,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'dob': dob,
      'role': role,
      'timeStamp': timeStamp,
      'isDeleted': isDeleted
    };
  }
}
