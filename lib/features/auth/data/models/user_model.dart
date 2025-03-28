class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? token;
  final bool success;
  final String? message;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.token,
    required this.success,
    this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      token: json['token'] ?? json['access_token'],
      success: json['success'] ?? false,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'token': token,
      'success': success,
      'message': message,
    };
  }
}
