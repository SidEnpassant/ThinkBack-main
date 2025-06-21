class RegisterModel {
  final String name;
  final String email;
  final String password;

  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
  };
}

class RegisterResponse {
  final String token;
  final Map<String, dynamic> user;

  RegisterResponse({required this.token, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(token: json['token'], user: json['user']);
  }
}
