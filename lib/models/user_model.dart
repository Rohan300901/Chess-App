import '../helper/constants.dart';

class UserModel{

  String userId;
  String name;
  String email;

  String createdAt;
  UserModel({

    required this.userId,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(

    userId: json[Constants.uid] ?? "",
    name: json[Constants.userName] ?? "",
    email: json[Constants.email] ?? "",
    createdAt: json[Constants.createdAt] ?? "",
  );

  Map<String, dynamic> toJson() => {

    Constants.uid: userId,
    Constants.userName: name,
    Constants.email: email,
    Constants.createdAt: createdAt,
  };
  @override
  String toString() {
    return 'UserModel(userId: $userId, name: $name, email: $email, createdAt: $createdAt)';
  }
}