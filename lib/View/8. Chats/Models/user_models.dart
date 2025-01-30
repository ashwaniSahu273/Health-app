class UserModel {
  String? fullname;
  String? iqamaNumber;
  String? email;
  String? uid;
  String? profilePic;
  String? experience;
  String? designation;
  String? mobileNumber;
  String? gender;
  String? dob;
  String? role;

  UserModel({
    this.fullname,
    this.iqamaNumber,
    this.email,
    this.uid,
    this.profilePic,
    this.experience,
    this.designation,
    this.mobileNumber,
    this.gender,
    this.dob,
    this.role,
  });

  UserModel.frommap(Map<String, dynamic> map) {
    uid = map['uid'];
    email = map['email'];
    fullname = map['fullname'];
    iqamaNumber = map['iqamaNumber'];
    profilePic = map['profilePic'];
    experience = map['experience'];
    designation = map['designation'];
    mobileNumber = map['mobileNumber'];
    gender = map['gender'];
    dob = map['dob'];
    role = map['role'];
  }

  Map<String, dynamic> tomap() {
    return {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'iqamaNumber': iqamaNumber,
      'profilePic': profilePic,
      'experience': experience,
      'designation': designation,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'dob': dob,
      'role': role,
    };
  }
}
