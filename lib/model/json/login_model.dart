class LoginModel {
  LoginModel(this.userName, this.token, this.userType);

  LoginModel.fromJson(Map<String, dynamic> json)
      : userName = json['display_name'],
        userType = json['user_type'],
        token = json['session_key'];

  final String userName;
  final String token;
  final String userType;

  Map<String, dynamic> toJson() => {
        'name': userName,
        'user_type': userType,
        'token': token,
      };
}
