class LoginModel {
  final String userName;
  final String token;

  LoginModel(this.userName, this.token);

  LoginModel.fromJson(Map<String, dynamic> json)
      : userName = json['display_name'],
        token = json['session_key'];

  Map<String, dynamic> toJson() => {
        'name': userName,
        'token': token,
      };
}
