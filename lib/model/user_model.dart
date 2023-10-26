import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String name;
  final String phone;
  final String email;
  final String? profilePictureUrl;
  UserModel({
    required this.name,
    required this.phone,
    required this.email,
    this.profilePictureUrl,
  });

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? profilePictureUrl,
  }) {
    return UserModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      profilePictureUrl: map['profilePictureUrl'] != null
          ? map['profilePictureUrl'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, phone: $phone, email: $email, profilePictureUrl: $profilePictureUrl)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.profilePictureUrl == profilePictureUrl;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        profilePictureUrl.hashCode;
  }
}
