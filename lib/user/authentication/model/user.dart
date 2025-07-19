// lib/models/user_model.dart
class User {
  int? user_id; 
  String user_name;
  String user_email;
  String user_password; 

  User(
    this.user_name,
    this.user_email,
    this.user_password,
    {this.user_id} 
  );


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['user_name'] as String,
      json['user_email'] as String,
      json['user_password'] as String, 
      user_id: json['user_id'] as int,
    );
  }

  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'user_name': user_name,
      'user_email': user_email,
      'user_password': user_password, 
    };
    if (user_id != null) {
      data['user_id'] = user_id.toString(); 
    }
    return data;
  }
}