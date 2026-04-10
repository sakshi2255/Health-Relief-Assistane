class UserModel {
  final String uid;
  final String name;
  final String email;
  final String lang;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.lang,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      lang: data['lang'] ?? 'en',
    );
  }

  // This part converts our Flutter data back into a Map
  // so we can save it to Firebase.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'lang': lang,
    };
  }
}