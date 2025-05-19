class User {
  final String id;
  final String email;
  final String passWord;
  final String phone;
  final String displayName;
  final int age;
  final String? role;
  String? status;

  User({
    required this.id,
    required this.email,
    required this.passWord,
    required this.phone,
    required this.displayName,
    required this.age,
    this.role,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      email: json['email'] as String,
      passWord: json['passWord'] as String,
      phone: json['phone'] as String,
      displayName: json['displayName'] as String,
      age: json['age'] as int,
      role: json['role'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}
