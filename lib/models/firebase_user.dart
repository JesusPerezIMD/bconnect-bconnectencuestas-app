class FirebaseUser {
  String? uid;
  String? email;
  String? displayName;
  String? photoURL;
  bool? emailVerified;

  FirebaseUser(
      {this.uid,
      this.email,
      this.displayName,
      this.photoURL,
      this.emailVerified});

  FirebaseUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    displayName = json['displayName'];
    photoURL = json['photoURL'];
    emailVerified = json['emailVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['displayName'] = displayName;
    data['photoURL'] = photoURL;
    data['emailVerified'] = emailVerified;
    return data;
  }
}