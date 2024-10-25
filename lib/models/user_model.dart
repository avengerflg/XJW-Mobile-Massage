class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String uid;
  final String auth;
  final bool error; // Added to handle login error
  final String message; // Added to hold error message

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.uid,
    required this.auth,
    this.error = false, // Default to false if not specified
    this.message = '', // Default to empty if not specified
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      uid: json['uid'],
      auth: json['auth'],
      error: json['error'] ?? false, // Handle error field
      message: json['message'] ?? '', // Handle message field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'uid': uid,
      'auth': auth,
      'error': error, // Added to JSON
      'message': message, // Added to JSON
    };
  }
}
