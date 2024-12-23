class UserModel {
  String? fullname;
  String? email;
  String? uid;
  String? profilePic;
  String? experience;
  String? designation; // New variable added

  UserModel({
    this.fullname,
    this.email,
    this.uid,
    this.profilePic,
    this.experience,
    this.designation,
  });

  UserModel.frommap(Map<String, dynamic> map) {
    uid = map['uid'];
    email = map['email'];
    fullname = map['fullname'];
    profilePic = map['profilePic'];
    experience = map['experience'];
    designation = map['designation']; // New variable added
  }

  Map<String, dynamic> tomap() {
    return {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'profilePic': profilePic,
      'experience': experience,
      'designation': designation, // New variable added
    };
  }
}
