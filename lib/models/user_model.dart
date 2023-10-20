
class UserModel {
  UserModel({
    this.id,
    required this.name,
    required this.number,
    required this.email,
    required this.photoUrl,
  });

  final int? id;
  final String name;
  final String number;
  final String email;
  final String photoUrl;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'number': number,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      number: map['number'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String,
    );
  }
}
