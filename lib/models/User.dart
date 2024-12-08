class User {
  String? id;
  String? username;
  String? password;
  String? firstname;
  String? lastname;
  String? birthdate;
  String? email;
  String? phone;
  String? avatarImg;

  User({
    this.id,
    this.username,
    this.password,
    this.firstname,
    this.lastname,
    this.birthdate,
    this.email,
    this.phone,
    this.avatarImg,
  });

  // Khởi tạo từ JSON
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    birthdate = json['birthdate'];
    email = json['email'];
    phone = json['phone'];
    avatarImg = json['avatarImg'];
  }

  // Chuyển đối tượng User sang JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['birthdate'] = birthdate;
    data['email'] = email;
    data['phone'] = phone;
    data['avatarImg'] = avatarImg;
    return data;
  }
}
