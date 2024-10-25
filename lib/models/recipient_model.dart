class Recipient {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final String relation;
  final String gender;

  Recipient({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.relation,
    required this.gender,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      phone: json['phone'],
      relation: json['relation'],
      gender: json['gender'],
    );
  }
}
